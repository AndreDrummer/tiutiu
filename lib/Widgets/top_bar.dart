import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/core/constants/strings.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0.w, 16.0.h, 8.0.w, 8.0.h),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: HomeStrings.searchForName,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 24.0.h, left: 16.0.w),
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.comments,
                    size: 16.0.h,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.gear,
                    size: 16.0.h,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
