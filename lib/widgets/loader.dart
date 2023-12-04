import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;

Future loaderDialog(BuildContext context, Future Function() task) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return Dialog(
        child: Container(
          width: 100,
          height: 100,
          child: SpinKitRing(
            color: Theme.of(context).colorScheme.primary,
            size: 50,
          ),
        ),
      );
    },
  );
  await task();
  Navigator.of(context).pop();
}
