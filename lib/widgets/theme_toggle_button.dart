// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../data/eunoia_store.dart';
import '../theme/app_theme.dart';

class ThemeToggleButton extends StatelessWidget {
  ThemeToggleButton({super.key, this.compact = false});
  final bool compact;

  Future<void> _toggle() async {
    final store = EunoiaStore.instance;
    store.dark = !store.dark;
    await store.save();
  }

  @override
  Widget build(BuildContext context) => IconButton(
        visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
        tooltip: AppColors.darkMode ? 'الوضع الفاتح' : 'الوضع الداكن',
        onPressed: _toggle,
        icon: Icon(
          AppColors.darkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          color: AppColors.gold,
        ),
      );
}
