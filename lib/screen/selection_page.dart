import 'package:flutter/material.dart';

class SelectionPage extends StatefulWidget {
  SelectionPage({
    @required this.list,
    @required this.title,
    @required this.valueSelected,
    this.onTap,
  });

  final List list;
  final valueSelected;
  final Function(String text) onTap;

  final String title;

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  List list;
  dynamic valueSelected = '';

  @override
  void initState() {
    super.initState();
    list = widget.list;
    list.sort((a, b) => a.length.compareTo(b.length));
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
        actions: widget.onTap != null
            ? [
                FlatButton(
                  child: Text(
                    'Prosseguir',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, index) {
            return InkWell(
              onTap: widget.onTap != null
                  ? () {
                      setState(() {
                        widget.onTap(list[index]);
                      });
                    }
                  : () {
                      Navigator.pop(context, list[index]);
                    },
              child: ListTile(
                title: Text(list[index]),
                trailing: widget.onTap != null &&
                        widget.valueSelected.contains(list[index])
                    ? Icon(Icons.done, color: Colors.purple)
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
