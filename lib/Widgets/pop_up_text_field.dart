import 'package:flutter/material.dart';
import 'package:tiutiu/Widgets/background.dart';
import 'package:tiutiu/Widgets/button.dart';
import 'package:tiutiu/Widgets/input_text.dart';

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
            Background(image: 'assets/patinhas.webp'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informe detalhes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Você pode passar detalhes sobre como ou onde viu o PET. (Opcional)',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
                ),
                SizedBox(height: 20),
                InputText(
                  placeholder: 'Escreva aqui...',
                  size: 150,
                  controller: controller,
                  multiline: true,
                  maxlines: 5,
                ),
                SizedBox(height: 25),
                ButtonWide(
                  action: callback,
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
