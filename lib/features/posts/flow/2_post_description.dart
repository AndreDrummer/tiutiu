import 'package:tiutiu/features/posts/validators/form_validators.dart';
import 'package:tiutiu/core/widgets/underline_input_dropdown.dart';
import 'package:tiutiu/core/extensions/string_extension.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/controllers/controllers.dart';
import 'package:tiutiu/core/widgets/underline_text.dart';
import 'package:tiutiu/core/widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/features/posts/model/post.dart';
import 'package:tiutiu/core/pets/model/pet_model.dart';
import 'package:tiutiu/core/utils/validators.dart';
import 'package:tiutiu/core/data/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final monthsList = List<String>.generate(13, (index) => '$index');
    final yearsList = List.generate(22, (index) => '$index');

    return Obx(
      () => ListView(
        padding: EdgeInsets.only(top: 8.0.h),
        children: [
          _breed(context),
          _spacer(),
          _color(context),
          _spacer(),
          _petAge(context, yearsList, monthsList),
          _spacer(),
          _postDescription(context),
          _spacer(),
        ],
      ),
    );
  }

  Widget _breed(BuildContext context) {
    final postType = postsController.post.type;

    return Visibility(
      visible: postType != AppLocalizations.of(context).other,
      child: UnderlineInputDropdown(
        isInErrorState: !(postsController.post as Pet).breed.isNotEmptyNeighterNull() && !postsController.formIsValid,
        initialValue: (postsController.post as Pet).breed,
        onChanged: (breed) {
          postsController.updatePost(PetEnum.breed.name, breed);
        },
        labelText:
            '${postsController.post.type == AppLocalizations.of(context).bird ? AppLocalizations.of(context).selectSpecie : AppLocalizations.of(context).selectBreed}',
        items: postType == AppLocalizations.of(context).other ? [] : DummyData.breeds[postsController.post.type]!,
        fontSize: 12.0,
      ),
      replacement: Padding(
        padding: EdgeInsets.fromLTRB(3.0.w, 0.0.h, 3.0.w, 16.0.h),
        child: Obx(
          () => Form(
            key: breedFormKey,
            child: UnderlineInputText(
              initialValue: (postsController.post as Pet).breed,
              validator: Validators.verifyEmpty,
              onChanged: (exoticBreed) {
                postsController.updatePost(PetEnum.breed.name, exoticBreed);
              },
              labelText: AppLocalizations.of(context).describBreed,
              fontSizeLabelText: 12.0,
            ),
          ),
        ),
      ),
    );
  }

  UnderlineInputDropdown _color(BuildContext context) {
    final petType = (postsController.post as Pet).type;
    late List<String> items;

    if (petType == AppLocalizations.of(context).dog) {
      items = DummyData.dogColors;
    } else if (petType == AppLocalizations.of(context).cat) {
      items = DummyData.catColors;
    } else {
      items = DummyData.allColors;
    }

    return UnderlineInputDropdown(
      isInErrorState: !(postsController.post as Pet).color.isNotEmptyNeighterNull() && !postsController.formIsValid,
      initialValue: (postsController.post as Pet).color,
      onChanged: (color) {
        postsController.updatePost(PetEnum.color.name, color);
      },
      labelText: AppLocalizations.of(context).color,
      items: items,
      fontSize: 12.0,
    );
  }

  Column _petAge(BuildContext context, List<String> yearsList, List<String> monthsList) {
    return Column(
      children: [
        OneLineText(
          widgetAlignment: Alignment(-0.965, 1),
          fontWeight: FontWeight.w500,
          color: AppColors.secondary,
          text: AppLocalizations.of(context).age,
          fontSize: 12,
        ),
        Row(
          children: [
            Expanded(
              child: UnderlineInputDropdown(
                initialValue: (postsController.post as Pet).ageYear.toString(),
                onChanged: (anos) {
                  postsController.updatePost(
                    PetEnum.ageYear.name,
                    int.parse(anos ?? '0'),
                  );
                },
                labelText: AppLocalizations.of(context).years,
                fontSize: 12.0,
                items: yearsList,
              ),
            ),
            Expanded(
              child: UnderlineInputDropdown(
                initialValue: (postsController.post as Pet).ageMonth.toString(),
                onChanged: (meses) {
                  postsController.updatePost(
                    PetEnum.ageMonth.name,
                    int.parse(meses ?? '0'),
                  );
                },
                labelText: AppLocalizations.of(context).months,
                fontSize: 12.0,
                items: monthsList,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _postDescription(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          OneLineText(
            widgetAlignment: Alignment(-0.965, 1),
            fontWeight: FontWeight.w500,
            color: AppColors.secondary,
            text: AppLocalizations.of(context).talkAboutThisPet,
            fontSize: 12,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 8.0.h),
            child: TextArea(
              isInErrorState:
                  !postsController.post.description.isNotEmptyNeighterNull() && !postsController.formIsValid,
              labelText: AppLocalizations.of(context).jotSomethingDown,
              initialValue: postsController.post.description,
              maxLines: 5,
              onChanged: (description) {
                postsController.updatePost(PostEnum.description.name, description);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _spacer() => SizedBox(height: 16.0.h);
}
