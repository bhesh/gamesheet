import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';

class PlayerController {
  final TextEditingController textController;
  final FocusNode focusNode;
  Palette color;

  PlayerController()
      : this.textController = TextEditingController(),
        this.focusNode = FocusNode(),
        this.color = Palette.red;

  PlayerController.withColor(this.color)
      : this.textController = TextEditingController(),
        this.focusNode = FocusNode();

  PlayerController.random()
      : this.textController = TextEditingController(),
        this.focusNode = FocusNode(),
        this.color = Palette.random;

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
  }

  String get text => textController.text;

  void randomColor() {
    color = Palette.random;
  }
}
