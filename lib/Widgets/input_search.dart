import 'package:flutter/material.dart';
import 'package:tiutiu/Widgets/custom_input_search.dart';

// ignore: must_be_immutable
class CustomInput extends StatefulWidget {
  CustomInput({
    this.onDropdownTypeChange,
    this.onDropdownHomeSearchOptionsChange,
    this.onChanged,
    this.isType = false,
    this.searchInitialValue,
    this.searchValues,
    this.searchPetTypeInitialValue,
    this.searchPetTypeValues,
  });

  final Function(String) onDropdownTypeChange;
  final Function(String) onDropdownHomeSearchOptionsChange;
  final Function(String) onChanged;
  final bool isType;
  String searchInitialValue;
  String searchPetTypeInitialValue;
  final List<String> searchValues;
  final List<String> searchPetTypeValues;

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          style: BorderStyle.solid,
          color: Colors.white,
          width: 1,
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 130,
            child: CustomDropdownButtonSearch(
              initialValue: widget.searchInitialValue,
              isExpanded: false,
              itemList: widget.searchValues,
              label: '',
              onChange: widget.onDropdownTypeChange,
            ),
          ),
          Expanded(
            child: !widget.isType
                ? Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      key: widget.key,
                      onChanged: (text) {
                        widget.onChanged(text);
                      },
                      controller: _controller,
                      cursorColor: Colors.grey,
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                      decoration: InputDecoration(
                        labelText: 'Pesquisar',
                        labelStyle: TextStyle(
                          color: Colors.black12,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.none),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.none),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.18),
                    child: CustomDropdownButtonSearch(
                      initialValue: widget.searchPetTypeInitialValue,
                      isExpanded: true,
                      withPipe: false,
                      itemList: widget.searchPetTypeValues,
                      label: '',
                      onChange: widget.onDropdownHomeSearchOptionsChange,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
