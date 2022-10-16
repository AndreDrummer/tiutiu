import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/core/constants/app_colors.dart';

class FilterSearch extends StatefulWidget {
  FilterSearch({
    this.filterValues,
    this.filterNames,
    this.isFiltering,
    this.showFilter,
  });

  final List<List<String>>? filterValues;
  final List<String>? filterNames;
  final Function()? isFiltering;
  final Function()? showFilter;

  @override
  _FilterSearchState createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  List<String> filterNames = ['Distância', 'Tamanho'];
  List<List<String>> filterValues = [
    ['Até 1Km', 'Até 10Km', 'Até 100Km', 'Até 500Km'],
    ['Pequeno-porte', 'Médio-porte', 'Grande-porte']
  ];
  List<String> initialValues = [];
  late Function() isFiltering;
  late Function() showFilter;
  late List filters;

  @override
  void initState() {
    super.initState();

    initializesDropdownValues();
    isFiltering = widget.isFiltering!;
    showFilter = widget.showFilter!;
  }

  @override
  Widget build(BuildContext context) {
    return isFiltering()
        ? Card(
            elevation: 8,
            color: Theme.of(context).primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(children: mountFilter().toList()),
            ),
          )
        : SizedBox();
  }

  List<Widget> mountFilter() {
    // ignore: omit_local_variable_types
    List<Widget> filters = [];
    filterNames.asMap.call().forEach((index, name) {
      filters.add(
        Row(
          children: <Widget>[
            AutoSizeText(name, style: Theme.of(context).textTheme.headline4),
            SizedBox(width: 10),
            DropdownButton<String>(
                value: initialValues[index],
                onChanged: (newValue) {
                  setState(() {
                    initialValues[index] = newValue!;
                  });
                },
                iconDisabledColor: AppColors.white,
                iconEnabledColor: AppColors.white,
                style: TextStyle(color: Colors.black, fontSize: 16),
                selectedItemBuilder: (BuildContext context) {
                  return filterValues[index].map((String value) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: AutoSizeText(value,
                          style: Theme.of(context).textTheme.headline4),
                    );
                  }).toList();
                },
                items: filterValues[index]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: AutoSizeText(value),
                  );
                }).toList()),
          ],
        ),
      );
    });
    filters.add(ButtonBar(
      alignment: MainAxisAlignment.end,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            showFilter();
          },
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            foregroundColor: Theme.of(context).primaryColor,
          ),
          child: AutoSizeText(
            'OK',
            style: Theme.of(context).textTheme.button,
          ),
        )
      ],
    ));
    return filters;
  }

  void initializesDropdownValues() {
    widget.filterNames != null
        ? filterNames = [...widget.filterNames!]
        : filterNames = filterNames;

    widget.filterValues != null
        ? filterValues = [...widget.filterValues!]
        : filterValues = filterValues;

    filterValues.asMap.call().forEach((index, element) {
      initialValues.add(element[0]);
    });
  }
}
