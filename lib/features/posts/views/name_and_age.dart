import 'package:tiutiu/Widgets/underline_input_dropdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/Widgets/underline_text.dart';
import 'package:tiutiu/core/utils/validators.dart';
import 'package:flutter/material.dart';

class NameAndAge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
    final monthsList = List.generate(13, (index) => '$index');
    final yearsList = List.generate(22, (index) => '$index');

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: Form(
              key: _keyForm,
              child: UnderlineInputText(
                validator: Validators.verifyEmpty,
                labelText: 'Nome',
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 32.0.h),
              UnderlineInputDropdown(
                items: yearsList,
                labelText: 'Anos',
                initialValue: '0',
                onChanged: (value) {},
                fontSize: 22.0.sp,
              ),
              SizedBox(height: 32.0.h),
              UnderlineInputDropdown(
                items: monthsList,
                labelText: 'Meses',
                initialValue: '0',
                onChanged: (value) {},
                fontSize: 22.0.sp,
              ),
            ],
          )
        ],
      ),
    );
  }
}
