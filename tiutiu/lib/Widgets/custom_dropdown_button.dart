import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDropdownButton extends StatefulWidget {
  CustomDropdownButton({this.initialValue, this.itemList, this.onChange, this.isExpanded, this.label});
  final List<String> itemList;
  String initialValue;
  final String label;
  final Function(String) onChange;
  final bool isExpanded;
  

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
          color: Colors.white,
          border: Border.all(
            style: BorderStyle.solid,
            color: Colors.white,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8.0),
            Align(
              child: Text(widget.label, style: TextStyle(color: Colors.black26, fontSize: 16,)),
              alignment: Alignment(-0.93, 1),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.isExpanded ? 15.0 : 0.0),
              child: DropdownButton<String>(                
                underline: Container(),
                isExpanded: widget.isExpanded,
                value: widget.initialValue,
                onChanged: (String value) {
                  setState(() {
                    widget.initialValue = value;
                    widget.onChange(value);
                  });
                },
                items:
                    widget.itemList.map<DropdownMenuItem<String>>((String e) {
                  return DropdownMenuItem<String>(
                    child: Text(e),
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
