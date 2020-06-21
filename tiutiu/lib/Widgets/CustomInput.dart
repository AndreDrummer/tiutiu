import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final Function showFilter;
  
  CustomInput({this.showFilter});

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
      margin: EdgeInsets.fromLTRB(20, 200, 20.0, 0.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Encontre um PET',
                labelStyle: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color),
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
                  Icons.filter_list,
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
