import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverSizedGrid extends StatelessWidget {
  final int crossAxisCount;
  final SliverChildDelegate delegate;
  final double? crossAxisExtent;
  final double itemExtent;

  const SliverSizedGrid({
    super.key,
    required this.crossAxisCount,
    required this.delegate,
    this.crossAxisExtent = null,
    required this.itemExtent,
  });

  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SizedGridDelegate(
        crossAxisCount: crossAxisCount,
        crossAxisExtent: crossAxisExtent,
        itemExtent: itemExtent,
      ),
      delegate: delegate,
    );
  }
}

class SizedGridDelegate extends SliverGridDelegate {
  final int crossAxisCount;
  final double? crossAxisExtent;
  final double itemExtent;

  SizedGridDelegate({
    required this.crossAxisCount,
    this.crossAxisExtent = null,
    required this.itemExtent,
  });

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    return SizedGridLayout(
      crossAxisCount: crossAxisCount,
      crossAxisExtent: crossAxisExtent == null
          ? constraints.crossAxisExtent / crossAxisCount
          : crossAxisExtent!,
      itemExtent: itemExtent,
    );
  }

  @override
  bool shouldRelayout(SizedGridDelegate oldDelegate) {
    return oldDelegate.crossAxisCount != crossAxisCount ||
        oldDelegate.crossAxisExtent != crossAxisExtent ||
        oldDelegate.itemExtent != itemExtent;
  }
}

class SizedGridLayout extends SliverGridLayout {
  final int crossAxisCount;
  final double crossAxisExtent;
  final double itemExtent;

  SizedGridLayout({
    required this.crossAxisCount,
    required this.crossAxisExtent,
    required this.itemExtent,
  });

  @override
  double computeMaxScrollOffset(int childCount) {
    if (childCount == 0 || itemExtent == 0) return 0;
    var sliceIndex = childCount ~/ crossAxisCount;
    if (childCount % crossAxisCount != 0) sliceIndex += 1;
    return sliceIndex * itemExtent;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final scrollOffset = (index ~/ crossAxisCount) * itemExtent;
    final crossAxisOffset = (index % crossAxisCount) * crossAxisExtent;
    return SliverGridGeometry(
      scrollOffset: scrollOffset,
      crossAxisOffset: crossAxisOffset,
      mainAxisExtent: itemExtent,
      crossAxisExtent: crossAxisExtent,
    );
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    final sliceIndex = scrollOffset ~/ itemExtent;
    return sliceIndex * crossAxisCount;
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    var sliceIndex = scrollOffset ~/ itemExtent;
    if (scrollOffset % itemExtent != 0) sliceIndex += 1;
    return sliceIndex * crossAxisCount;
  }
}
