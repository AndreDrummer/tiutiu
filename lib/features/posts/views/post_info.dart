import 'package:tiutiu/features/posts/validators/form_validators.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/Widgets/underline_input_dropdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/pets/model/pet_model.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/Widgets/underline_text.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/core/utils/validators.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final monthsList = List<String>.generate(13, (index) => '$index');
    final yearsList = List.generate(22, (index) => '$index');

    return Obx(
      () => ListView(
        children: [
          _petName(),
          SizedBox(height: 8.0.h),
          _petAge(yearsList, monthsList),
          SizedBox(height: 8.0.h),
          _petSize(),
          SizedBox(height: 40.0.h),
          _health(),
        ],
      ),
    );
  }

  Padding _petName() {
    return Padding(
      padding: EdgeInsets.fromLTRB(3.0.w, 0.0.h, 3.0.w, 16.0.h),
      child: Form(
        key: nameKeyForm,
        child: Obx(
          () => UnderlineInputText(
            initialValue: postsController.post.name,
            validator: Validators.verifyEmpty,
            onChanged: (name) {
              nameKeyForm.currentState!.validate();
              postsController.updatePost(PetEnum.name, name);
            },
            labelText: PostFlowStrings.petName,
            fontSizeLabelText: 14.0.sp,
          ),
        ),
      ),
    );
  }

  Column _petAge(List<String> yearsList, List<String> monthsList) {
    return Column(
      children: [
        OneLineText(
          widgetAlignment: Alignment(-0.92, 1),
          fontWeight: FontWeight.w500,
          color: AppColors.secondary,
          text: PostFlowStrings.age,
          fontSize: 14,
        ),
        Row(
          children: [
            Expanded(
              child: UnderlineInputDropdown(
                initialValue: postsController.post.ageYear.toString(),
                onChanged: (anos) {
                  postsController.updatePost(
                    PetEnum.ageYear,
                    int.parse(anos ?? '0'),
                  );
                },
                labelText: PostFlowStrings.years,
                fontSize: 14.0.sp,
                items: yearsList,
              ),
            ),
            Expanded(
              child: UnderlineInputDropdown(
                initialValue: postsController.post.ageMonth.toString(),
                onChanged: (meses) {
                  postsController.updatePost(
                    PetEnum.ageMonth,
                    int.parse(meses ?? '0'),
                  );
                },
                labelText: PostFlowStrings.months,
                fontSize: 14.0.sp,
                items: monthsList,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Padding _petSize() {
    return Padding(
      padding: EdgeInsets.only(top: 32.0.h),
      child: UnderlineInputDropdown(
        isInErrorState: !postsController.post.size.isNotEmptyNeighterNull() && !postsController.formIsValid,
        initialValue: postsController.post.size.toString(),
        onChanged: (size) {
          postsController.updatePost(PetEnum.size, size);
        },
        labelText: PostFlowStrings.size,
        items: DummyData.size,
        fontSize: 14.0.sp,
      ),
    );
  }

  Widget _health() {
    return AnimatedContainer(
      height: postsController.existChronicDisease ? 136.0.h : 72.0.h,
      margin: EdgeInsets.only(bottom: 8.0.h),
      duration: Duration(milliseconds: 500),
      child: ListView(
        children: [
          UnderlineInputDropdown(
            isInErrorState: !postsController.post.health.isNotEmptyNeighterNull() && !postsController.formIsValid,
            initialValue: postsController.post.health.toString(),
            onChanged: (health) {
              postsController.updatePost(PetEnum.health, health);
            },
            labelText: PetDetailsStrings.health,
            items: DummyData.health,
            fontSize: 14.0.sp,
          ),
          _chronicDiseaseInfo(),
        ],
      ),
    );
  }

  Visibility _chronicDiseaseInfo() {
    return Visibility(
      visible: postsController.existChronicDisease,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16.0.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: Form(
                key: diaseaseForm,
                child: TextArea(
                  isInErrorState:
                      !postsController.post.chronicDiseaseInfo.isNotEmptyNeighterNull() && !postsController.formIsValid,
                  maxLines: 1,
                  onChanged: (chronicDiseaseInfo) {
                    postsController.updatePost(
                      PetEnum.chronicDiseaseInfo,
                      chronicDiseaseInfo,
                    );
                  },
                  initialValue: postsController.post.chronicDiseaseInfo,
                  validator: postsController.existChronicDisease ? Validators.verifyEmpty : null,
                  labelText: PostFlowStrings.describeDiseaseType,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
