import 'package:flutter/material.dart';
import 'package:tiutiu/Custom/icons.dart';

class CustomInput extends StatelessWidget {
  final Function showFilter;

  CustomInput({this.showFilter});  

  @override
  Widget build(BuildContext context) {
    final marginTop = MediaQuery.of(context).size.height / 5;
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
      margin: EdgeInsets.fromLTRB(20, marginTop, 20.0, 0.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Adote um PET',
                labelStyle: TextStyle(
                  color: Theme.of(context).textTheme.headline5.color,
                ),
                hintText: 'Ex.: Chihuahua',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.none),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.none),
                ),
              ),
            ),
          ),
          SizedBox(
              child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {
                  print("Realizar Pesquisa");
                },
              ),
              IconButton(
                icon: Icon(
                  CustomIcon.filter,
                  size: 17,
                ),
                onPressed: () {
                  showFilter();
                },
              ),
            ],
          )),
        ],
      ),
    );
  }
}
