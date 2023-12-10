import 'package:flutter/material.dart';

class SettingsField extends StatelessWidget {
  final String title;
  final String description;
  final void Function()? onTap;
  final Widget? suffixWidget;

  const SettingsField({
    super.key,
    required this.title,
    required this.description,
    this.onTap,
    this.suffixWidget,
  });

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Widget> children = [
      Container(
        width: size.width - 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(description, softWrap: true),
          ],
        ),
      ),
      Spacer(),
    ];
    if (suffixWidget != null) children.add(suffixWidget!);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 16,
          left: 48,
          right: 16,
        ),
        child: Row(children: children),
      ),
    );
  }
}
