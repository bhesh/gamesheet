import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamesheet/widgets/card.dart';
import 'package:gamesheet/widgets/message.dart';

typedef TabBuilder = Tab Function(BuildContext, int);

typedef PageSliverBuilder = Widget Function(BuildContext, int);

class ScoreKeeper extends StatelessWidget {
  final String title;
  final int numTabs;
  final TabBuilder headerBuilder;
  final PageSliverBuilder pageBuilder;
  final TabController? controller;

  ScoreKeeper({
    super.key,
    required this.title,
    required this.numTabs,
    required this.headerBuilder,
    required this.pageBuilder,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, isScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Text(title),
              elevation: 1,
              scrolledUnderElevation: 1,
              shadowColor: Theme.of(context).colorScheme.shadow,
              surfaceTintColor: Theme.of(context).colorScheme.shadow,
              expandedHeight: 200,
              pinned: true,
              floating: false,
              bottom: TabBar(
                controller: controller,
                isScrollable: true,
                tabs: List.generate(
                  numTabs,
                  (index) => headerBuilder(context, index),
                ),
              ),
            ),
          ),
        ];
      },
      body: Padding(
        padding: EdgeInsets.only(top: 8),
        child: TabBarView(
          controller: controller,
          children: List.generate(
            numTabs,
            (index) {
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (context) {
                    return CustomScrollView(
                      controller: ScrollController(), // throws error otherwise
                      key: PageStorageKey<int>(index),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        pageBuilder(context, index),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
