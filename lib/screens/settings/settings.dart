import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String header;
  final List<Widget> children;
  final TextStyle? headerStyle;

  const SettingsSection({
    super.key,
    required this.header,
    required this.children,
    this.headerStyle,
  });

  @override
  Widget build(BuildContext context) {
    var _headerStyle = headerStyle == null
        ? Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Theme.of(context).colorScheme.primary)
        : headerStyle!;
    List<Widget> widgets = [
      Padding(
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 16,
          left: 48,
          right: 16,
        ),
        child: Text(
          header,
          style: _headerStyle,
        ),
      ),
    ];
    for (int i = 0; i < children.length; ++i)
      widgets.add(Padding(
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 16,
          left: 48,
          right: 16,
        ),
        child: children[i],
      ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}

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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(children: children),
    );
  }
}
