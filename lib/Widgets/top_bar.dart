import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/features/system/controllers.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2.0.w, 8.0.h, 8.0.w, 0.0.h),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                filterController.filterByName = value;
              },
              decoration: InputDecoration(
                constraints: BoxConstraints(maxHeight: 32.0.h),
                contentPadding: EdgeInsets.only(left: 8.0.w),
                fillColor: Colors.purple.withAlpha(20),
                hintStyle: TextStyles.fontSize12(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
                hintText: HomeStrings.searchForName,
                enabledBorder: _inputBorder(),
                errorBorder: _inputBorder(),
                border: _inputBorder(),
                filled: true,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0.h, left: 16.0.w),
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.comments,
                    color: Colors.purple,
                    size: 16.0.h,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.gear,
                    color: Colors.purple,
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

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        style: BorderStyle.solid,
        color: Colors.purple,
        width: 1.0.w,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
