import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDropdownButtonSearch extends StatefulWidget {
  CustomDropdownButtonSearch({
    this.initialValue,
    this.itemList,
    this.fontSize,
    this.onChange,
    this.isExpanded,
    this.withPipe = true,
    this.label,
    this.colorText = Colors.black
  });
  final List<String> itemList;
  String initialValue;
  final String label;
  final Function(String) onChange;
  final bool isExpanded;
  final bool withPipe;
  final Color colorText;
  final double fontSize;

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
          onChanged: (String value) {          
            widget.onChange(value);
          },
          items: widget.itemList.map<DropdownMenuItem<String>>((String e) {
            return DropdownMenuItem<String>(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(e, style: TextStyle(color: widget.colorText, fontSize: widget.fontSize)),
              ),
              value: e,
            );
          }).toList(),
        ),
        widget.withPipe
            ? Container(height: 30, width: 1, color: Colors.black38)
            : Container()
      ],
    );
  }
}
