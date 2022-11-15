import 'package:tiutiu/core/constants/text_styles.dart';
import 'package:flutter/material.dart';

class CustomDropdownButtonSearch extends StatefulWidget {
  CustomDropdownButtonSearch({
    this.colorText = Colors.black,
    this.withPipe = true,
    this.initialValue,
    this.isExpanded,
    this.itemList,
    this.fontSize,
    this.onChange,
    this.label,
  });
  final Function(String)? onChange;
  final List<String>? itemList;
  final String? initialValue;
  final bool? isExpanded;
  final double? fontSize;
  final Color? colorText;
  final bool? withPipe;
  final String? label;

  @override
  _CustomDropdownButtonSearchState createState() => _CustomDropdownButtonSearchState();
}

class _CustomDropdownButtonSearchState extends State<CustomDropdownButtonSearch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          underline: Container(),
          value: widget.initialValue,
          onChanged: (value) {
            widget.onChange?.call(value!);
          },
          items: widget.itemList!.map<DropdownMenuItem<String>>((String e) {
            return DropdownMenuItem<String>(
              child: AutoSizeTexts.autoSizeText12(e),
              value: e,
            );
          }).toList(),
        ),
        widget.withPipe! ? Container(height: 30, width: 1, color: Colors.black38) : Container()
      ],
    );
  }
}
