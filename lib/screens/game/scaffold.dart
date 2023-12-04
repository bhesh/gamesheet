import 'package:flutter/material.dart';

class GameScaffold extends StatelessWidget {
  final String title;
  final int numTabs;
  final Tab Function(BuildContext, int) headerBuilder;
  final Widget Function(BuildContext, int) pageBuilder;
  final TabController controller;

  const GameScaffold({
    super.key,
    required this.title,
    int? numTabs,
    required this.headerBuilder,
    required this.pageBuilder,
    required this.controller,
  }) : this.numTabs = numTabs ?? 1;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, isScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              title: Text(title),
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
        padding: const EdgeInsets.only(top: 8),
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
