import 'package:tiutiu/features/posts/validators/form_validators.dart';
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
    final petTypeList = [
      '-',
      PetTypeStrings.dog,
      PetTypeStrings.cat,
      PetTypeStrings.bird,
      PetTypeStrings.exotic,
    ];

    final monthsList = List<String>.generate(13, (index) => '$index');
    final yearsList = List.generate(22, (index) => '$index');

    return Obx(
      () => ListView(
        children: [
          SizedBox(height: 8.0.h),
          _petName(),
          _petAge(yearsList, monthsList),
          _petType(petTypeList),
          _petSize(),
        ],
      ),
    );
  }

  Padding _petName() {
    return Padding(
      padding: EdgeInsets.fromLTRB(3.0.w, 0.0.h, 3.0.w, 16.0.h),
      child: Form(
        key: nameKeyForm,
        child: UnderlineInputText(
          initialValue: postsController.post.name,
          validator: Validators.verifyEmpty,
          onChanged: (name) {
            nameKeyForm.currentState!.validate();
            postsController.updatePet(PetEnum.name, name);
          },
          labelText: PostFlowStrings.petName,
          fontSizeLabelText: 14.0.sp,
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
        ),
        Row(
          children: [
            Expanded(
              child: UnderlineInputDropdown(
                initialValue: postsController.post.ageYear.toString(),
                onChanged: (anos) {
                  postsController.updatePet(
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
                  postsController.updatePet(
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

  Padding _petType(List<String> petType) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0.h),
      child: UnderlineInputDropdown(
        isInErrorState: !postsController.post.type.isNotEmptyNeighterNull() &&
            !postsController.formIsValid,
        initialValue: postsController.post.type,
        onChanged: (type) {
          postsController.updatePet(PetEnum.type, type);
        },
        labelText: PostFlowStrings.petType,
        fontSize: 14.0.sp,
        items: petType,
      ),
    );
  }

  Padding _petSize() {
    return Padding(
      padding: EdgeInsets.only(top: 32.0.h),
      child: UnderlineInputDropdown(
        isInErrorState: !postsController.post.size.isNotEmptyNeighterNull() &&
            !postsController.formIsValid,
        initialValue: postsController.post.size.toString(),
        onChanged: (size) {
          postsController.updatePet(PetEnum.size, size);
        },
        labelText: PostFlowStrings.size,
        items: DummyData.size,
        fontSize: 14.0.sp,
      ),
    );
  }
}
