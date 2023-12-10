import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;

Future<void> loaderDialog(BuildContext context, Future Function() task) async {
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

Future<bool> confirmDeleteDialog(BuildContext context, String message) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirm'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStatePropertyAll<Color>(
                  Theme.of(context).colorScheme.error),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
