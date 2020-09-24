import 'package:flutter/material.dart';

class SelectionPage extends StatefulWidget {
  SelectionPage({
    @required this.list,
    @required this.title,
    @required this.listSelected,
  });

  final List list;
  final List listSelected;
  final String title;

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  List list;
  List selectedValues = [];


  @override
  void initState() {
    super.initState();
    list = widget.list;
    selectedValues = widget.listSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            selectedValues.clear();
            Navigator.pop(context);
          },
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context, selectedValues);
            },
            child: Text(
              'Prosseguir',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedValues.contains(list[index])
                      ? selectedValues.remove(list[index])
                      : selectedValues.add(list[index]);
                });
              },
              child: ListTile(
                title: Text(list[index]),
                trailing: selectedValues.contains(list[index])
                    ? Icon(Icons.done, color: Colors.purple)
                    : Text(''),
              ),
            );
          },
        ),
      ),
    );
  }
}
