import 'package:tiutiu/features/tiutiu_user/model/tiutiu_user.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/core/widgets/column_button_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/load_dark_screen.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/underline_text.dart';
import 'package:tiutiu/core/widgets/avatar_profile.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/validators.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Settings extends StatefulWidget {
  Settings({this.isEditingProfile = true});

  final bool isEditingProfile;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TiutiuUser previousUser;

  @override
  void initState() {
    previousUser = tiutiuUserController.tiutiuUser;
    phoneNumberController.text = previousUser.phoneNumber ?? '';
    nameController.text = previousUser.displayName ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEditingProfile ? MoreStrings.editProfile : MoreStrings.completeProfile;

    return SafeArea(
      child: Scaffold(
        appBar: DefaultBasicAppBar(automaticallyImplyLeading: false, text: title),
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
              children: [
                SizedBox(height: 16.0.h),
                _userName(),
                SizedBox(height: 16.0.h),
                _userPhoneNumber(),
                SizedBox(height: 16.0.h),
                Spacer(),
                _buttons(context),
                SizedBox(height: 16.0.h),
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
      labelText: MoreStrings.howCallYou,
      validator: Validators.verifyEmpty,
      controller: nameController,
      fontSizeLabelText: 16.0,
      readOnly: false,
    );
  }

  Widget _userPhoneNumber() {
    return Column(
      children: [
        SizedBox(height: 16.0.h),
        UnderlineInputText(
          validator: (value) => Validators.verifyLength(value, length: 14, field: 'Telefone'),
          labelText: MoreStrings.whatsapp,
          keyboardType: TextInputType.number,
          controller: phoneNumberController,
          fontSizeLabelText: 16.0,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TelefoneInputFormatter(),
          ],
        ),
      ],
    );
  }

  Widget _buttons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
      child: ColumnButtonBar(
        showSimpleTextButton: widget.isEditingProfile,
        onPrimaryPressed: () async {
          if (_formIsValid()) {
            debugPrint('>> Updating profile...');
            FocusScope.of(context).unfocus();

            _setDataToUser();

            await moreController.save();

            if (widget.isEditingProfile) Get.back();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(MoreStrings.profileUpdated)));
          } else if (tiutiuUserController.tiutiuUser.avatar == null) {
            appController.snackBarIsOpen = true;

            ScaffoldMessenger.of(context)
                .showSnackBar(
                  SnackBar(
                    content: Text(MoreStrings.insertAPicture),
                    backgroundColor: AppColors.danger,
                  ),
                )
                .closed
                .then((value) => appController.snackBarIsOpen = false);
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
    tiutiuUserController.updateTiutiuUser(TiutiuUserEnum.phoneNumber, phoneNumberController.text.trim());
    tiutiuUserController.updateTiutiuUser(TiutiuUserEnum.displayName, nameController.text.trim());

    if (phoneNumberController.text != previousUser.phoneNumber) {
      tiutiuUserController.updateTiutiuUser(TiutiuUserEnum.phoneVerified, false);
      tiutiuUserController.whatsappNumberHasBeenUpdated = true;
    }
  }

  Widget _loadingWidget() {
    return Obx(
      () => LoadDarkScreen(
        message: MoreStrings.updatingProfile,
        visible: moreController.isLoading,
        roundeCorners: true,
      ),
    );
  }

  bool _formIsValid() {
    return _formKey.currentState!.validate() && tiutiuUserController.tiutiuUser.avatar != null;
  }
}
