import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SelectionPage extends StatefulWidget {
  SelectionPage({
    required this.valueSelected,
    required this.title,
    required this.list,
    this.onTap,
  });

  final Function(String text)? onTap;
  final valueSelected;
  final List list;

  final String title;

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  dynamic valueSelected = '';
  late List list;

  @override
  void initState() {
    super.initState();
    list = [...widget.list];
    list.sort();
    valueSelected = widget.valueSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
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
                TextButton(
                  child: AutoSizeText(
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
          key: UniqueKey(),
          itemCount: list.length,
          itemBuilder: (_, index) {
            return InkWell(
              onTap: widget.onTap != null
                  ? () {
                      setState(() {
                        widget.onTap!(list[index]);
                      });
                    }
                  : () {
                      Navigator.pop(context, list[index]);
                    },
              child: ListTile(
                title: AutoSizeText(list[index]),
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
