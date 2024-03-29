import 'package:flutter/material.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    Key? key,
    required this.title,
    this.actions = const [],
    this.body,
    this.floatingActionButton,
    this.endDrawer,
  }) : super(key: key);
  final String title;
  final List<Widget> actions;
  final Widget? body;
  final Widget? floatingActionButton;
  final Drawer? endDrawer;

  @override
  Widget build(BuildContext context) {
    // 1. look for an ancestor Scaffold
    final ancestorScaffold = Scaffold.maybeOf(context);
    // 2. check if it has a drawer
    final hasDrawer = ancestorScaffold != null && ancestorScaffold.hasDrawer;
    return Scaffold(
      appBar: AppBar(
        // 3. add a non-null leading argument if we have a drawer
        leading: hasDrawer
            ? IconButton(
                icon: const Icon(Icons.menu),
                // 4. open the drawer if we have one
                onPressed:
                    hasDrawer ? () => ancestorScaffold!.openDrawer() : null,
              )
            : null,
        title: Text(title),
        actions: actions,
        toolbarHeight: 78,
        automaticallyImplyLeading: false,
        shape: Border(bottom: BorderSide(color: Colors.grey[350]!, width: 0.5)),
      ),
      body: body,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
    );
  }
}
