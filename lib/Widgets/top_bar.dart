import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/core/constants/strings.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.h),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.0.h),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: HomeStrings.searchForName,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0.h, left: 32.0.w),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(FontAwesomeIcons.comments),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(FontAwesomeIcons.gear),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
