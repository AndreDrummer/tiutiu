import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiutiu/core/widgets/column_button_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/tiutiu_snackbar.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/underline_text.dart';
import 'package:tiutiu/core/views/load_dark_screen.dart';
import 'package:tiutiu/core/widgets/avatar_profile.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/assets_path.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/utils/validators.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  EditProfile({this.isEditingProfile = true});

  final bool isEditingProfile;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TiutiuUser previousUser;
  late String countryCode;

  @override
  void initState() {
    previousUser = tiutiuUserController.tiutiuUser;
    phoneNumberController.text = previousUser.phoneNumber ?? '';
    nameController.text = previousUser.displayName ?? '';
    countryCode = previousUser.countryCode ?? '+55';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEditingProfile
        ? AppLocalizations.of(context)!.editProfile
        : AppLocalizations.of(context)!.completeProfile;

    return SafeArea(
      child: Scaffold(
        appBar: DefaultBasicAppBar(
          automaticallyImplyLeading: false,
          text: title,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                height: Get.height,
                child: Stack(
                  children: [
                    Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0.h),
                      ),
                      child: _cardContent(context),
                    ),
                    _loadingWidget()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardContent(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView(
        children: [
          Stack(
            children: [
              _backgroundImage(),
              Positioned(
                right: 52.0,
                left: 52.0,
                top: 0.0.h,
                child: _roundedPicture(),
              ),
            ],
          ),
          Container(
            height: Get.height / 2,
            margin: EdgeInsets.only(left: 8.0.w, top: 16.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0.h),
                _userName(),
                SizedBox(height: 16.0.h),
                _userPhoneNumber(),
                SizedBox(height: 16.0.h),
                Spacer(),
                _buttons(context),
                SizedBox(
                    height: widget.isEditingProfile
                        ? 0.0
                        : Get.height < 700
                            ? 80.0.h
                            : 48.0.h),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _roundedPicture() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0.h),
      alignment: Alignment.center,
      child: Obx(
        () => AvatarProfile(
          hero: 'null',
          onAssetPicked: (file) {
            tiutiuUserController.updateTiutiuUser(
              TiutiuUserEnum.avatar,
              file,
            );
          },
          avatarPath: tiutiuUserController.tiutiuUser.avatar,
          radius: Get.width / 6,
          onAssetRemoved: () {
            tiutiuUserController.updateTiutiuUser(
              TiutiuUserEnum.avatar,
              null,
            );
          },
          viewOnly: false,
        ),
      ),
    );
  }

  Opacity _backgroundImage() {
    return Opacity(
      opacity: .3,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.0.h),
          topLeft: Radius.circular(12.0.h),
        ),
        child: Container(
          height: Get.width / 2,
          width: double.infinity,
          child: ClipRRect(
            child: Image.asset(
              ImageAssets.bones2,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }

  Widget _userName() {
    return UnderlineInputText(
      labelText: AppLocalizations.of(context)!.howCallYou,
      validator: Validators.verifyEmpty,
      controller: nameController,
      fontSizeLabelText: 12.0,
      readOnly: false,
    );
  }

  Widget _countryCode() {
    return SizedBox(
      width: 98.0.w,
      child: DropdownButton<String>(
        underline:
            Container(height: .4.h, color: AppColors.black, width: 98.0.w),
        value: countryCode,
        isExpanded: false,
        items: DummyData.countryCodes
            .map((String code) => DropdownMenuItem<String>(
                child: AutoSizeTexts.autoSizeText18(code), value: code))
            .toList(),
        onChanged: (value) {
          setState(() {
            countryCode = value!;
          });
        },
      ),
    );
  }

  Widget _userPhoneNumber() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0.h),
          AutoSizeTexts.autoSizeText14(AppLocalizations.of(context)!.whatsapp),
          Row(
            children: [
              _countryCode(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.0.h),
                  child: UnderlineInputText(
                    validator: (value) => Validators.verifyLength(value,
                        length: 14, field: AppLocalizations.of(context)!.phone),
                    keyboardType: TextInputType.number,
                    controller: phoneNumberController,
                    fontSizeLabelText: 12.0,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: ColumnButtonBar(
        isConnected: systemController.properties.internetConnected,
        showSimpleTextButton: widget.isEditingProfile,
        onPrimaryPressed: () async {
          if (_formIsValid()) {
            if (kDebugMode) debugPrint('TiuTiuApp: Updating profile...');
            FocusScope.of(context).unfocus();

            _setDataToUser();

            await moreController.save();

            if (widget.isEditingProfile) Get.back();

            ScaffoldMessenger.of(context).showSnackBar(TiuTiuSnackBar(
                message: AppLocalizations.of(context)!.profileUpdated));
          } else if (tiutiuUserController.tiutiuUser.avatar == null) {
            systemController.snackBarIsOpen = true;

            ScaffoldMessenger.of(context)
                .showSnackBar(TiuTiuSnackBar(
                    message: AppLocalizations.of(context)!.insertAPicture,
                    color: AppColors.danger))
                .closed
                .then((value) => systemController.snackBarIsOpen = false);
          }
        },
        onSecondaryPressed: () {
          tiutiuUserController.resetUserWithThisUser(user: previousUser);
          Get.back();
        },
      ),
    );
  }

  void _setDataToUser() {
    tiutiuUserController.updateTiutiuUser(
        TiutiuUserEnum.phoneNumber, phoneNumberController.text.trim());
    tiutiuUserController.updateTiutiuUser(
        TiutiuUserEnum.displayName, nameController.text.trim());
    tiutiuUserController.updateTiutiuUser(
        TiutiuUserEnum.countryCode, countryCode);

    if (phoneNumberController.text != previousUser.phoneNumber ||
        countryCode != previousUser.countryCode) {
      tiutiuUserController.updateTiutiuUser(
          TiutiuUserEnum.phoneVerified, false);
      tiutiuUserController.whatsappNumberHasBeenUpdated = true;
    }
  }

  Widget _loadingWidget() {
    return Obx(
      () => LoadDarkScreen(
        message: AppLocalizations.of(context)!.updatingProfile,
        visible: moreController.isLoading,
        roundeCorners: true,
      ),
    );
  }

  bool _formIsValid() {
    return _formKey.currentState!.validate() &&
        tiutiuUserController.tiutiuUser.avatar != null;
  }
}
