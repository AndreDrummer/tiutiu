import 'package:tiutiu/features/talk_with_us/widgets/body_card.dart';
import 'package:tiutiu/core/widgets/underline_input_dropdown.dart';
import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/posts/widgets/text_area.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/widgets/add_image.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:tiutiu/core/widgets/button_wide.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';

class TalkWithUs extends StatelessWidget {
  const TalkWithUs({super.key});

  @override
  Widget build(BuildContext context) {
    final talkWithUsSubjects = [
      TalkWithUsStrings.wannaAnnounceOnApp,
      TalkWithUsStrings.writeYourMessage,
      TalkWithUsStrings.anotherUserIssue,
      TalkWithUsStrings.dificultsUse,
      TalkWithUsStrings.partnership,
      DeleteAccountStrings.bugs,
      '-',
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultBasicAppBar(text: MyProfileOptionsTile.talkWithUs),
      body: BodyCard(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0.h),
              child: UnderlineInputDropdown(
                labelText: TalkWithUsStrings.subject,
                items: talkWithUsSubjects,
                onChanged: (value) {},
                initialValue: '-',
                fontSize: 18,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.w),
              child: TextArea(
                labelText: TalkWithUsStrings.writeYourMessage,
                maxLines: 5,
              ),
            ),
            CheckboxListTile(
              title: AutoSizeTexts.autoSizeText16(
                TalkWithUsStrings.addImages,
                fontWeight: FontWeight.w500,
                color: AppColors.secondary,
              ),
              onChanged: (value) {},
              value: false,
            ),
            // SizedBox(
            //   height: 280.0.h,
            //   child: AddImage(),
            // ),
            ButtonWide()
          ],
        ),
      ),
    );
  }
}
