import 'package:get/get.dart';
import 'package:tiutiu/Widgets/one_line_text.dart';
import 'package:tiutiu/core/constants/strings.dart';
import 'package:tiutiu/features/posts/widgets/card_picture.dart';
import 'package:tiutiu/core/constants/images_assets.dart';
import 'package:tiutiu/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Pictures extends StatelessWidget {
  const Pictures({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (ctx, index) {
                return AdPicture(
                  imagePath: ImageAssets.bones,
                  color: AppColors.primary,
                  onPicturedRemoved: () {},
                  onAddPicture: () {},
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: TextButton.icon(
              icon: Icon(Icons.add),
              onPressed: null,
              label: Text('Adicionar mais fotos'),
            ),
          ),
          Divider(),
          OneLineText(
            text: PostFlowStrings.addVideo,
            alignment: Alignment(-0.92, 1),
            fontWeight: FontWeight.w500,
            color: AppColors.secondary,
          ),
          Container(
            height: 200,
            margin: const EdgeInsets.all(8.0),
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
