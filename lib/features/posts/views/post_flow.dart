import 'package:tiutiu/core/widgets/default_basic_app_bar.dart';
import 'package:tiutiu/features/posts/views/pet_location.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/features/posts/widgets/steper.dart';
import 'package:tiutiu/features/system/controllers.dart';
import 'package:tiutiu/Widgets/column_button_bar.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:flutter/material.dart';

class PostFlow extends StatelessWidget {
  const PostFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultBasicAppBar(text: PostFlowStrings.fillAdData),
      body: Stack(
        children: [
          Column(
            children: [
              Steper(
                stepsName: _steps,
              ),
              Divider(height: 16.0.h),
              OneLineText(
                alignment: Alignment(-0.9, 1),
                text: 'Onde está o PET?',
                fontSize: 24.0.sp,
              ),
              Expanded(
                child: _screens.elementAt(postsController.flowIndex),
              ),
            ],
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: ColumnButtonBar(),
          ),
        ],
      ),
    );
  }
}

final _steps = [
  'Nome e idade',
  'Local',
];

final _screens = [
  PetLocation(),
];
