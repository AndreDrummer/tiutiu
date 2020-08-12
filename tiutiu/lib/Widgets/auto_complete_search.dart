import 'package:flutter/material.dart';

class AutoCompleteSearch extends StatefulWidget {
  AutoCompleteSearch({
    this.autoCompleteCallback,
    this.placesList,
    this.onLocalSelected,
    this.onAutoCompleteClose,
  });

  final List<String> placesList;
  final Function(String) autoCompleteCallback;
  final Function(String) onLocalSelected;
  final Function() onAutoCompleteClose;

  @override
  _AutoCompleteSearchState createState() => _AutoCompleteSearchState();
}

class _AutoCompleteSearchState extends State<AutoCompleteSearch> {
  final TextEditingController _searchText = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        widget.placesList.isNotEmpty
            ? Container(
                height: 210,
                width: MediaQuery.of(context).size.width * 0.9,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: widget.placesList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          widget.onLocalSelected(widget.placesList[index]);
                          _searchText.clear();
                          widget.placesList.clear();
                        });
                      },
                      child: ListTile(
                        leading: Icon(Icons.pin_drop),
                        title: Text(widget.placesList[index]),
                      ),
                    );
                  },
                ),
              )
            : Container(),
        Container(
          height: 95,
          width: width - 10,
          child: FittedBox(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.pin_drop),
                      ),
                    ),
                    SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: width,
                            child: TextFormField(
                              controller: _searchText,
                              onChanged: (String value) {
                                if(_searchText.text.isEmpty) {
                                  widget.placesList.clear();
                                }
                                widget.autoCompleteCallback(value);
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                widget.placesList.clear();
                                widget.onAutoCompleteClose();
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(style: BorderStyle.solid),
                              ),
                              width: 40,
                              height: 40,
                              child: Icon(Icons.close, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
