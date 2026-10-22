import 'package:flutter/material.dart';
import 'data/eunoia_store.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

class EunoiaApp extends StatefulWidget {
  const EunoiaApp({super.key});

  @override
  State<EunoiaApp> createState() => _EunoiaAppState();
}

class _EunoiaAppState extends State<EunoiaApp> {
  final store = EunoiaStore.instance;

  @override
  void initState() {
    super.initState();
    store.addListener(_refresh);
    store.load();
  }

  @override
  void dispose() {
    store.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppColors.darkMode = store.dark;
    return MaterialApp(
      title: 'EUNOIA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.current,
      home: const SplashScreen(),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}