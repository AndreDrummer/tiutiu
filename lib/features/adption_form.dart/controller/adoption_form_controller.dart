import 'package:tiutiu/features/adption_form.dart/repository/adoption_form_repository.dart';
import 'package:tiutiu/features/adption_form.dart/model/adoption_form.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/utils/routes/routes_name.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:get/get.dart';
import 'dart:io';

const int _STEPS_QTY = 5;

class AdoptionFormController extends GetxController {
  AdoptionFormController({required AdoptionFormRepository adoptionFormRepository})
      : _adoptionFormRepository = adoptionFormRepository;

  final AdoptionFormRepository _adoptionFormRepository;

  final Rx<AdoptionForm> _adoptionForm = AdoptionForm().obs;
  final RxBool _isEditing = false.obs;
  final RxBool _isLoading = false.obs;
  final RxInt _formStep = 0.obs;

  AdoptionForm get adoptionForm => _adoptionForm.value;
  bool get isEditing => _isEditing.value;
  bool get isLoading => _isLoading.value;
  int get formStep => _formStep.value;

  void setLoading(bool loadingValue, {String loadingText = ''}) {
    _isLoading(loadingValue);
  }

  void nextStep() {
    if (formStep < _STEPS_QTY) {
      _formStep(formStep + 1);
    }
  }

  void previousStep() {
    if (formStep > 0) {
      _formStep(formStep - 1);
    } else if (formStep == 0) {
      Get.back();
    }
  }

  void setAdoptionForm(AdoptionForm adoptionForm) {
    _adoptionForm(adoptionForm);

    debugPrint('New Form ${adoptionForm.toMap()}');
  }

  bool lastStep() => _formStep == _STEPS_QTY;

  Future<void> saveForm() async {
    setLoading(true);
    await _adoptionFormRepository.saveForm(adoptionForm: adoptionForm);
    await Future.delayed(Duration(seconds: 1));
    setLoading(false);
  }

  void set isEditing(bool value) => _isEditing(value);

  void resetForm() {
    _adoptionForm(AdoptionForm());
    _formStep(0);
    isEditing = false;
  }

  Future<bool> formExists() async {
    final form = await _adoptionFormRepository.getForm();
    return form != null;
  }

  Future<void> loadForm() async {
    final form = await _adoptionFormRepository.getForm();
    _adoptionForm(form);
  }

  Future<void> shareFormText() async {
    await loadForm();
    await Share.share(adoptionForm.toString(), sharePositionOrigin: Rect.fromLTWH(0, 0, Get.width, Get.height / 2));
    Get.offNamedUntil(Routes.home, (route) => route.settings.name == Routes.home);
    resetForm();
  }

  Future<void> shareEmptyFormText() async {
    await Share.share(adoptionForm.toStringEmpty(),
        sharePositionOrigin: Rect.fromLTWH(0, 0, Get.width, Get.height / 2));
    Get.offNamedUntil(Routes.home, (route) => route.settings.name == Routes.home);
  }

  Future<void> shareFormPDF() async {
    await loadForm();
    await _generateFormPDF(part1: adoptionForm.toPDFPart1(), part2: adoptionForm.toPDFPart2());
    resetForm();
    Get.offNamedUntil(Routes.home, (route) => route.settings.name == Routes.home);
  }

  Future<void> shareEmptyFormPDF() async {
    await _generateFormPDF(
      part1: adoptionForm.toPDFPart1Empty(),
      part2: adoptionForm.toPDFPart2Empty(),
      isEmptyForm: true,
    );
  }

  Future<void> _generateFormPDF({required String part1, required String part2, bool isEmptyForm = false}) async {
    final pdf = pw.Document();

    final image = pw.MemoryImage(
      (await rootBundle.load(ImageAssets.pdfWaterMark)).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Transform.scale(
            scale: 1.1,
            child: pw.Stack(
              children: [
                pw.Positioned(
                  bottom: Get.height * (isEmptyForm ? .80 : .65),
                  right: 0,
                  child: pw.Opacity(
                    opacity: .5,
                    child: pw.Container(
                      height: 48.0.h,
                      width: 48.0.h,
                      child: pw.Image(
                        image,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                pw.Text(part1),
              ],
            ),
          );
        },
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Transform.scale(
            scale: 1.1,
            child: pw.Stack(
              children: [
                pw.Positioned(
                  bottom: Get.width / (isEmptyForm ? 1.6 : 1.75),
                  right: isEmptyForm ? 136.0.w : 32.0.w,
                  child: pw.Opacity(
                    opacity: .5,
                    child: pw.Container(
                      height: 48.0.h,
                      width: 48.0.h,
                      child: pw.Image(
                        image,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                pw.Text(part2),
              ],
            ),
          );
        },
      ),
    );

    String dir = (await getTemporaryDirectory()).path;

    File pdfFile = File('$dir/${AppLocalizations.of(Get.context!)!.formPdfName}${isEmptyForm ? ' (Vazio)' : ''}.pdf');

    await pdfFile.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(pdfFile.path)], sharePositionOrigin: Rect.fromLTWH(0, 0, Get.width, Get.height / 2));
  }

  final List<String> formStepsTitle = [
    AppLocalizations.of(Get.context!)!.personalInfo,
    AppLocalizations.of(Get.context!)!.referenceContacts,
    AppLocalizations.of(Get.context!)!.petInfo,
    AppLocalizations.of(Get.context!)!.houseInfo,
    AppLocalizations.of(Get.context!)!.financialInfo,
    AppLocalizations.of(Get.context!)!.backgroundInfo,
  ];

  final List<String> maritalStatus = [
    '-',
    AppLocalizations.of(Get.context!)!.marriedSeparated,
    AppLocalizations.of(Get.context!)!.stableUnion,
    AppLocalizations.of(Get.context!)!.divorced,
    AppLocalizations.of(Get.context!)!.separated,
    AppLocalizations.of(Get.context!)!.single,
    AppLocalizations.of(Get.context!)!.married,
    AppLocalizations.of(Get.context!)!.widower,
  ];

  final List<String> petsType = [
    '-',
    AppLocalizations.of(Get.context!)!.dog,
    AppLocalizations.of(Get.context!)!.cat,
    AppLocalizations.of(Get.context!)!.bird,
  ];
}
