import 'package:flutter/material.dart';
import '../data/eunoia_store.dart';
import '../theme/app_theme.dart';
import 'brand_mark.dart';
import 'theme_toggle_button.dart';

const appTabs = [
  (Icons.home_outlined, 'الرئيسية'),
  (Icons.edit_note, 'يومياتي'),
  (Icons.auto_awesome, 'احكي'),
  (Icons.donut_small, 'تقييمي'),
  (Icons.person_outline, 'ملفي'),
];

class AppScaffold extends StatelessWidget {
  AppScaffold({super.key, required this.title, required this.selectedIndex, required this.onSelect, required this.child});
  final String title;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth > 850;
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: desktop
                  ? Row(children: [
                      _sidebar(context),
                      Expanded(child: Column(children: [
                        _desktopTopbar(context),
                        Expanded(child: _content()),
                      ])),
                    ])
                  : Column(children: [
                      _mobileTopbar(context),
                      Expanded(child: _content()),
                    ]),
            ),
            bottomNavigationBar: desktop ? null : _mobileNavigation(),
          );
        },
      );

  Widget _content() => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1150),
          child: SizedBox.expand(child: child),
        ),
      );

  Widget _desktopTopbar(BuildContext context) => Container(
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: .35))),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title, style: TextStyle(color: AppColors.muted, fontSize: 12)),
          Text(_today(), style: TextStyle(color: AppColors.muted, fontSize: 12)),
          Row(children: [
          IconButton(onPressed: () => onSelect(5), icon: Icon(Icons.favorite_border, color: AppColors.gold), tooltip: 'خطة الأمان'),
            ThemeToggleButton(),
            IconButton(onPressed: () => _about(context), icon: Icon(Icons.info_outline, color: AppColors.gold), tooltip: 'عن يونويا'),
          ]),
        ]),
      );

  Widget _mobileTopbar(BuildContext context) => Container(
        height: 58,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: .35)))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          BrandMark(light: AppColors.darkMode, compact: true, arabic: true),
          Row(children: [
            IconButton(onPressed: () => onSelect(5), icon: Icon(Icons.favorite_border, color: AppColors.gold), tooltip: 'خطة الأمان'),
            ThemeToggleButton(compact: true),
            IconButton(onPressed: () => _about(context), icon: Icon(Icons.info_outline, color: AppColors.gold), tooltip: 'عن يونويا'),
          ]),
        ]),
      );

  Widget _sidebar(BuildContext context) => Container(
        width: 255,
        height: double.infinity,
        padding: EdgeInsets.fromLTRB(17, 22, 17, 18),
        decoration: BoxDecoration(color: AppColors.rail, border: Border(left: BorderSide(color: AppColors.border.withValues(alpha: .3)))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Align(alignment: Alignment.centerRight, child: BrandMark(light: AppColors.darkMode, compact: true, arabic: true)),
          SizedBox(height: 30),
          Padding(padding: EdgeInsets.symmetric(horizontal: 14), child: Text('مساحتك الآمنة', style: TextStyle(color: AppColors.muted, fontSize: 11))),
          SizedBox(height: 8),
          for (int i = 0; i < appTabs.length; i++) _sideItem(i),
          Spacer(),
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(19)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('افتكري دايمًا', style: TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text('يونويا مساحة مساندة، مش تشخيص ولا بديل عن المساعدة المتخصصة.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, fontSize: 10, height: 1.7)),
              TextButton(onPressed: () => onSelect(5), child: Text('افتحي خطة الأمان ←', style: TextStyle(color: AppColors.gold, fontSize: 11))),
            ]),
          ),
          SizedBox(height: 12),
          Row(children: [
            CircleAvatar(backgroundColor: AppColors.coral, child: Text(_firstLetter(), style: TextStyle(color: AppColors.forestDark))),
            SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_profileName(), style: TextStyle(color: AppColors.cream, fontWeight: FontWeight.bold)), Text('مساحتك الخاصة', style: TextStyle(color: AppColors.muted, fontSize: 10))]),
          ]),
        ]),
      );

  Widget _sideItem(int i) {
    final active = i == selectedIndex;
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Material(
        color: active ? AppColors.gold : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => onSelect(i),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(children: [
              Icon(appTabs[i].$1, color: active ? AppColors.forestDark : AppColors.muted, size: 21),
              SizedBox(width: 12),
              Text(appTabs[i].$2, style: TextStyle(color: active ? AppColors.forestDark : AppColors.cream, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _mobileNavigation() => NavigationBar(
        selectedIndex: selectedIndex < appTabs.length ? selectedIndex : 0,
        onDestinationSelected: onSelect,
        backgroundColor: AppColors.rail,
        indicatorColor: AppColors.gold,
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(color: states.contains(WidgetState.selected) ? AppColors.gold : AppColors.muted, fontSize: 11)),
        destinations: [for (final tab in appTabs) NavigationDestination(icon: Icon(tab.$1), label: tab.$2)],
      );

  void _about(BuildContext context) => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('عن يونويا'),
          content: Text('يونويا مساحة للتأمل والدعم الذاتي. المحتوى والتمارين هنا نموذج أولي، وليست تشخيصًا أو علاجًا نفسيًا.'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('تمام'))],
        ),
      );

  String _today() {
    final days = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    final now = DateTime.now();
    return '${days[now.weekday - 1]}، ${now.day} ${now.month}';
  }

  String _profileName() => EunoiaStore.instance.name.isEmpty ? 'صاحبة المساحة' : EunoiaStore.instance.name;
  String _firstLetter() => EunoiaStore.instance.name.isEmpty ? 'م' : EunoiaStore.instance.name[0];
}

class PageHeading extends StatelessWidget {
  PageHeading({super.key, required this.eyebrow, required this.title, this.subtitle});
  final String eyebrow, title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(eyebrow, textAlign: TextAlign.right, style: TextStyle(color: AppColors.coral, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(title, textAlign: TextAlign.right, style: TextStyle(color: AppColors.gold, fontSize: 34, fontWeight: FontWeight.bold)),
          if (subtitle != null) Text(subtitle!, textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, height: 1.7)),
        ],
      );
}

class AppCard extends StatelessWidget {
  AppCard({super.key, required this.child, Color? color}) : color = color;
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: color ?? AppColors.surface, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(24)),
        child: child,
      );
}
