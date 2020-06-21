import 'package:flutter/material.dart';

class FilterSearch extends StatefulWidget {
  final List<String> filterNames;
  final List<List<String>> filterValues;
  final Function() isFiltering;
  final Function() showFilter;

  FilterSearch({
    this.filterNames,
    this.filterValues,
    this.isFiltering,
    this.showFilter,
  });

  @override
  _FilterSearchState createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  List<String> filterNames = ['Distância', 'Tamanho'];
  List<List<String>> filterValues = [
    ['Até 1Km', 'Até 10Km', 'Até 100Km', 'Até 500Km'],
    ['Muito pequeno', 'Pequeno', 'Médio', 'Grande', 'Muito Grande']
  ];
  List<String> initialValues = [];
  List filters;
  Function() isFiltering;
  Function() showFilter;

  @override
  void initState() {
    super.initState();

    initializesDropdownValues();
    isFiltering = widget.isFiltering;
    showFilter = widget.showFilter;
  }

  @override
  Widget build(BuildContext context) {
    return isFiltering()
        ? Positioned(
            top: 265,
            left: MediaQuery.of(context).size.width - 250,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(children: mountFilter().toList()),
            ),
          )
        : SizedBox();
  }

  List<Widget> mountFilter() {
    List<Widget> filters = [];
    filterNames.asMap.call().forEach((index, name) {
      filters.add(
        Row(
          children: <Widget>[
            Text(
              name,
              style: Theme.of(context).primaryTextTheme.headline5,
            ),
            SizedBox(width: 10),
            DropdownButton<String>(
              value: initialValues[index],
              onChanged: (String newValue) {
                setState(() {
                  initialValues[index] = newValue;
                });
              },
              items: filterValues[index]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ],
        ),
      );
    });
    filters.add(ButtonBar(
      alignment: MainAxisAlignment.end,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            showFilter();
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Text(
            "OK",
            style: Theme.of(context).primaryTextTheme.button,
          ),
          color: Theme.of(context).primaryColor,
        )
      ],
    ));
    return filters;
  }

  initializesDropdownValues() {

    widget.filterNames != null
        ? filterNames = [...widget.filterNames]
        : filterNames = filterNames;

    widget.filterValues != null
        ? filterValues = [...widget.filterValues]
        : filterValues = filterValues;

    filterValues.asMap.call().forEach((index, element) {
      initialValues.add(element[0]);
    });

  }
}
