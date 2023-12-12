import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitRing;
import 'package:gamesheet/common/color.dart';

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

void colorChooserDialog(BuildContext context,
    [void Function(Palette)? onTap = null]) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 75,
            childAspectRatio: 1.0,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: Palette.values.length,
          itemBuilder: (context, index) {
            return InkWell(
              borderRadius: BorderRadius.circular(37.5),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Palette.values[index].background,
                  borderRadius: BorderRadius.circular(37.5),
                ),
              ),
              onTap: () {
                if (onTap != null) onTap!(Palette.values[index]);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      );
    },
  );
}
