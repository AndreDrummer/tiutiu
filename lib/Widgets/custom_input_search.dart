import 'package:flutter/material.dart';

// ignore: must_be_immutable
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
  final bool? isExpanded;
  final double? fontSize;
  final Color? colorText;
  final bool? withPipe;
  String? initialValue;
  final String? label;

  @override
  _CustomDropdownButtonSearchState createState() =>
      _CustomDropdownButtonSearchState();
}

class _CustomDropdownButtonSearchState
    extends State<CustomDropdownButtonSearch> {
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
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(e,
                    style: TextStyle(
                        color: widget.colorText, fontSize: widget.fontSize)),
              ),
              value: e,
            );
          }).toList(),
        ),
        widget.withPipe!
            ? Container(height: 30, width: 1, color: Colors.black38)
            : Container()
      ],
    );
  }
}
