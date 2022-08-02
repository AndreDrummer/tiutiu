import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  Search({
    this.placeholder = 'Pesquisar',
    required this.onChanged,
  });

  final Function(String) onChanged;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        onChanged: onChanged,
        cursorColor: Colors.grey,
        style: TextStyle(fontSize: 20, color: Colors.grey),
        decoration: InputDecoration(
          labelText: placeholder,
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
    );
  }
}
