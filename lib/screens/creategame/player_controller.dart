import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';

class PlayerController {
  final TextEditingController textController;
  Palette color;

  PlayerController()
      : this.textController = TextEditingController(),
        this.color = Palette.red;

  PlayerController.withColor(this.color)
      : this.textController = TextEditingController();

  PlayerController.random()
      : this.textController = TextEditingController(),
        this.color = Palette.random;

  @override
  void dispose() {
    textController.dispose();
  }

  String get text => textController.text;

  void randomColor() {
    color = Palette.random;
  }
}
