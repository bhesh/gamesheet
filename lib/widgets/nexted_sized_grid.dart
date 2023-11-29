import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverFixedExtentGrid extends StatelessWidget {
  final Axis crossAxis;
  final int crossAxisCount;
  final List<Widget> items;
  final double crossAxisExtent;
  final double itemExtent;

  const SliverFixedExtentGrid({
    super.key,
    this.crossAxis = Axis.vertical,
    required this.crossAxisCount,
    required this.items,
    this.crossAxisExtent = double.infinity,
    required this.itemExtent,
  });

  SliverFixedExtentGrid.builder({
    super.key,
    this.crossAxis = Axis.vertical,
    required this.crossAxisCount,
    required delegate,
    this.crossAxisExtent = double.infinity,
    required this.itemExtent,
  }) : this.items = List.empty(growable: true) {
      items = 
  }
}

class SizedGrid extends StatelessWidget {
  final Axis crossAxis;
  final double crossAxisExtent;
  final List<Widget> headerItems;
  final double headerExtent;
  final List<Widget> bodyItems;
  final double bodyExtent;

  const SizedGrid({
    super.key,
    this.crossAxis = Axis.vertical,
    this.crossAxisExtent = double.infinity,
    required this.headerItems,
    required this.headerExtent,
    required this.bodyItems,
    required this.bodyExtent,
  });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      scrollDirection: crossAxis,
      headerSliverBuilder: (context, isScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: SizedGridHeader(
                crossAxis: crossAxis,
                crossAxisExtent: crossAxisExtent,
                itemExtent: headerExtent,
                children: headerItems,
              ),
            ),
          ),
        ];
      },
      body: Builder(
        builder: (context) {
          return CustomScrollView(
            scrollDirection: crossAxis,
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverGrid(
                gridDelegate: SizedGridDelegate(
                  crossAxis: crossAxis,
                  crossAxisCount: crossAxisCount,
                  itemWidth: itemWidth,
                  itemHeight: itemHeight,
                ),
                delegate: itemDelegate,
              ),
            ],
          );
        },
      ),
    );
  }
}

class SizedGridHeader extends SliverPersistentHeaderDelegate {
  final Axis crossAxis;
  final double crossAxisExtent;
  final List<Widget> children;
  final double itemExtent;

  SizedGridHeader({
    this.crossAxis = Axis.vertical,
    this.crossAxisExtent = double.infinity,
    required this.children,
    required this.itemExtent,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      width: crossAxis == Axis.vertical ? crossAxisExtent : itemExtent,
      heigth: crossAxis == Axis.vertical ? itemExtent : crossAxisExtent,
      child: crossAxis == Axis.verticial
          ? Row(children: children)
          : Column(children: children),
    );
  }

  @override
  double get maxExtent => itemExtent;

  @override
  double get minExtent => itemExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class SizedGridDelegate extends SliverGridDelegate {
  final Axis crossAxis;
  final int crossAxisCount;
  final double itemWidth;
  final double itemHeight;

  SizedGridDelegate({
    required this.crossAxis,
    required this.crossAxisCount,
    required this.itemWidth,
    required this.itemHeight,
  });

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    return SizedGridLayout(
      crossAxis: crossAxis,
      crossAxisCount: crossAxisCount,
      itemWidth: itemWidth,
      itemHeight: itemHeight,
    );
  }

  @override
  bool shouldRelayout(SizedGridDelegate oldDelegate) => false;
}

class SizedGridLayout extends SliverGridLayout {
  final Axis crossAxis;
  final int crossAxisCount;
  final double itemWidth;
  final double itemHeight;

  SizedGridLayout({
    required this.crossAxis,
    required this.crossAxisCount,
    required this.itemWidth,
    required this.itemHeight,
  });

  @override
  double computeMaxScrollOffset(int childCount) {
    final constraint = crossAxis == Axis.vertical ? itemHeight : itemWidth;
    if (childCount == 0 || constraint == 0) return 0;
    var numRows = childCount ~/ crossAxisCount;
    if (childCount % crossAxisCount != 0) numRows += 1;
    return numRows * constraint;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final mainAxisExtent = crossAxis == Axis.vertical ? itemWidth : itemHeight;
    final crossAxisExtent = crossAxis == Axis.vertical ? itemWidth : itemHeight;
    final scrollOffset = (index ~/ crossAxisCount) * mainAxisExtent;
    final crossAxisOffset = (index % crossAxisCount) * crossAxisExtent;
    return SliverGridGeometry(
      scrollOffset: scrollOffset,
      crossAxisOffset: crossAxisOffset,
      mainAxisExtent: mainAxisExtent,
      crossAxisExtent: crossAxisExtent,
    );
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    final constraint = crossAxis == Axis.vertical ? itemHeight : itemWidth;
    final mainAxisIndex = scrollOffset ~/ constraint;
    return mainAxisIndex * crossAxisCount;
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    final constraint = crossAxis == Axis.vertical ? itemHeight : itemWidth;
    var mainAxisIndex = scrollOffset ~/ constraint;
    if (scrollOffset % constraint != 0) mainAxisIndex += 1;
    return mainAxisIndex * crossAxisCount;
  }
}
