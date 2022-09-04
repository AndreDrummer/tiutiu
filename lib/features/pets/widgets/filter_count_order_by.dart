import 'package:flutter/material.dart';
import 'package:tiutiu/Widgets/custom_input_search.dart';
import 'package:tiutiu/features/system/controllers.dart';

class FilterResultCount extends StatelessWidget {
  const FilterResultCount({
    required this.count,
    super.key,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      alignment: Alignment(-0.9, 1),
      padding: const EdgeInsets.only(left: 10, right: 10),
      margin: const EdgeInsets.only(bottom: 10, top: 5),
      child: Row(
        children: [
          Row(
            children: [
              Text(
                '$count ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black26,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  'encontrados',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black26,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Text(
                  'ordenar por:  ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black26,
                  ),
                ),
              ),
              CustomDropdownButtonSearch(
                colorText: Colors.black54,
                fontSize: 13,
                initialValue: petsController.orderType,
                isExpanded: false,
                withPipe: false,
                itemList: petsController.orderTypeList,
                label: '',
                onChange: (String text) {
                  petsController.changeOrderType(
                    text,
                    'null',
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
