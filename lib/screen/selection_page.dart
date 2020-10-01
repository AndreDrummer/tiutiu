import 'package:flutter/material.dart';

class SelectionPage extends StatefulWidget {
  SelectionPage({
    @required this.list,
    @required this.title,
    @required this.valueSelected,
  });

  final List list;
  final String valueSelected;
  final String title;

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  List list;
  String valueSelected = '';


  @override
  void initState() {
    super.initState();
    list = widget.list;
    valueSelected = widget.valueSelected;
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
            valueSelected = '';
            Navigator.pop(context);
          },
        ),    
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context, list[index]);                
              },
              child: ListTile(
                title: Text(list[index]),                
              ),
            );
          },
        ),
      ),
    );
  }
}
