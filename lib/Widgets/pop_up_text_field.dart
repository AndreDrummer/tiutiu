import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/button_wide.dart';
import 'package:tiutiu/Widgets/outline_input_text.dart';
import 'package:tiutiu/core/constants/images_assets.dart';

class PopupTextField extends StatelessWidget {
  PopupTextField({
    this.controller,
    this.callback,
  });

  final TextEditingController? controller;
  final void Function()? callback;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Container(
        height: 300,
        child: Stack(
          children: [
            Background(image: ImageAssets.patinhas),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  'Informe detalhes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                AutoSizeText(
                  'Você pode passar detalhes sobre como ou onde viu o PET. (Opcional)',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
                ),
                SizedBox(height: 20),
                OutlinedInputText(
                  labelText: 'Escreva aqui...',
                ),
                SizedBox(height: 25),
                ButtonWide(
                  onPressed: callback,
                  text: 'Enviar',
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
