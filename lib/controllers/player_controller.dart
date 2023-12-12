import 'package:flutter/material.dart';
import 'package:gamesheet/common/color.dart';

class PlayerController {
  final TextEditingController textController;
  final FocusNode focusNode;
  Palette color;

  PlayerController({
    void Function()? onUnfocus,
  })  : this.textController = TextEditingController(),
        this.focusNode = FocusNode(),
        this.color = Palette.red {
    _addListener(this.focusNode, onUnfocus);
  }

  PlayerController.withColor({
    required this.color,
    void Function()? onUnfocus,
  })  : this.textController = TextEditingController(),
        this.focusNode = FocusNode() {
    _addListener(this.focusNode, onUnfocus);
  }

  PlayerController.random({
    void Function()? onUnfocus,
  })  : this.textController = TextEditingController(),
        this.focusNode = FocusNode(),
        this.color = Palette.random {
    _addListener(this.focusNode, onUnfocus);
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
  }

  String get text => textController.text.trim();

  String? get name => text.isNotEmpty ? text : null;

  static void _addListener(FocusNode focusNode, void Function()? onUnfocus) {
    if (onUnfocus != null) {
      focusNode.addListener(() {
        if (!focusNode.hasFocus) onUnfocus!();
      });
    }
  }
}
