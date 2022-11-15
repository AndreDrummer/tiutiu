import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/core/constants/app_colors.dart';

// ignore: must_be_immutable
class CustomDropdownButton extends StatefulWidget {
  CustomDropdownButton({
    this.initialValue,
    this.isExpanded,
    this.itemList,
    this.onChange,
    this.label,
  });
  final Function(String)? onChange;
  final List<String>? itemList;
  String? initialValue;
  final bool? isExpanded;
  final String? label;

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: AppColors.white,
          border: Border.all(
            style: BorderStyle.solid,
            color: Colors.lightGreenAccent[200]!,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8.0),
            Align(
              child: AutoSizeText(widget.label!,
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 16,
                  )),
              alignment: Alignment(-0.93, 1),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.isExpanded! ? 15.0 : 0.0),
              child: DropdownButton<String>(
                underline: Container(),
                isExpanded: widget.isExpanded!,
                value: widget.initialValue,
                onChanged: (value) {
                  setState(() {
                    widget.initialValue = value;
                    widget.onChange?.call(value!);
                  });
                },
                items:
                    widget.itemList!.map<DropdownMenuItem<String>>((String e) {
                  return DropdownMenuItem<String>(
                    child: AutoSizeText(e),
                    value: e,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
