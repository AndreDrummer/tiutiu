import 'package:tiutiu/features/posts/widgets/post_type_card_selector.dart';
import 'package:flutter/material.dart';

class SelectPostTypeGridView extends StatelessWidget {
  const SelectPostTypeGridView({
    required this.pairRowAxisAlignment,
    required this.oddRowAxisAlignment,
    required this.petsTypeSelected,
    required this.filtersTypeText,
    required this.onTypeSelected,
    required this.petsTypeImage,
    required this.collsNumber,
    required this.rowsNumber,
    super.key,
  });

  final Function(String typeSelected) onTypeSelected;
  final MainAxisAlignment pairRowAxisAlignment;
  final MainAxisAlignment oddRowAxisAlignment;
  final List<String> filtersTypeText;
  final List<String> petsTypeImage;
  final String petsTypeSelected;
  final int collsNumber;
  final int rowsNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(
      rowsNumber,
      (rowIndex) {
        return Row(
          mainAxisAlignment: rowIndex.isOdd ? oddRowAxisAlignment : pairRowAxisAlignment,
          children: List.generate(
            collsNumber,
            (collIndex) {
              final useIndex = rowIndex < 1 ? rowIndex + collIndex : (rowIndex + 1) + collIndex;
              final type = filtersTypeText[useIndex];

              return PostTypeCardSelector(
                image: petsTypeImage.elementAt(useIndex),
                onTypeSelected: () => onTypeSelected(type),
                isSelected: petsTypeSelected == type,
                typeText: type,
              );
            },
          ),
        );
      },
    ));
  }
}
