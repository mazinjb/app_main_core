import 'package:flutter/material.dart';



// ===================================================================
// القسم 6: كلاسات التبويبات المخصصة (AppTab)
// ===================================================================
enum AppTabStyle {
  /// النمط الأول: شريط العنوان يتمرر مع المحتوى. مثالي للمحتوى الطويل.
  nestedScroll,

  /// النمط الثاني: شريط العنوان يبقى ثابتًا في الأعلى.
  fixedHeader,
}

class AppTab extends StatelessWidget {
  final String title;
  final List<Tab> tabs;
  final List<Widget> children;
  final AppTabStyle style;
  final bool pinned;
  final bool floating;

  const AppTab({
    super.key,
    required this.title,
    required this.tabs,
    required this.children,
    this.style = AppTabStyle.nestedScroll, // القيمة الافتراضية هي النمط المتمرر
    this.pinned = true,
    this.floating = true,
  }) : assert(tabs.length == children.length);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: _buildUI(context),
    );
  }

  /// دالة مساعدة لبناء الواجهة بناءً على النمط المختار
  Widget _buildUI(BuildContext context) {
    switch (style) {
      case AppTabStyle.nestedScroll:
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: Text(title),
                  pinned: pinned,
                  floating: floating,
                  bottom: TabBar(tabs: tabs),
                ),
              ];
            },
            body: TabBarView(children: children),
          ),
        );
      case AppTabStyle.fixedHeader:
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            bottom: TabBar(tabs: tabs),
          ),
          body: TabBarView(children: children),
        );
    }
  }
}