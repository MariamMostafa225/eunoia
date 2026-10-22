import 'dart:async';
import 'package:flutter/material.dart';
import '../data/eunoia_store.dart';
import '../theme/app_theme.dart';

class BreathingScreen extends StatefulWidget { BreathingScreen({super.key}); @override State<BreathingScreen> createState() => _BreathingScreenState(); }

class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin {
  Timer? timer;
  Timer? phaseTimer;
  late final AnimationController orb = AnimationController(vsync: this, duration: Duration(seconds: 4), lowerBound: .82, upperBound: 1.2, value: 1);
  int duration = 60, remaining = 0, phase = 0, phaseSeconds = 4;
  bool running = false;
  String cue = 'خدي وضع مريح';
  final phaseNames = const ['شهيق', 'ثبات', 'زفير'];
  final phaseLengths = const [4, 2, 6];

  void start() {
    if (running) { pause(); return; }
    if (remaining == 0) remaining = duration;
    setState(() => running = true);
    _nextPhase();
    timer = Timer.periodic(Duration(seconds: 1), (t) async {
      if (remaining <= 1) {
        t.cancel(); phaseTimer?.cancel();
        setState(() { remaining = 0; running = false; cue = 'خلص التمرين'; });
        final store = EunoiaStore.instance; store.breathSessions++; await store.save();
        if (mounted) showDialog<void>(context: context, builder: (ctx) => AlertDialog(title: Text('خلص التمرين'), content: Text('شكرًا إنك خصصتي اللحظة دي لنفسك.'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text('تمام'))]));
      } else { setState(() => remaining--); }
    });
  }

  void _nextPhase() {
    if (!running) return;
    phaseSeconds = phaseLengths[phase];
    setState(() => cue = phaseNames[phase]);
    if (phase == 0) { orb.duration = Duration(seconds: 4); orb.forward(); }
    if (phase == 2) { orb.duration = Duration(seconds: 6); orb.reverse(); }
    phaseTimer?.cancel();
    phaseTimer = Timer.periodic(Duration(seconds: 1), (t) {
      if (phaseSeconds > 1) { setState(() => phaseSeconds--); }
      else { t.cancel(); phase = (phase + 1) % 3; _nextPhase(); }
    });
  }

  void pause() { timer?.cancel(); phaseTimer?.cancel(); setState(() { running = false; cue = 'خدي راحتك'; }); }
  @override
  void dispose() { timer?.cancel(); phaseTimer?.cancel(); orb.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('لحظة هدوء ليكي')),
        body: ListView(padding: EdgeInsets.all(20), children: [
          Text('تنفّسي على مهلك', textAlign: TextAlign.right, style: TextStyle(color: AppColors.gold, fontSize: 29, fontWeight: FontWeight.bold)),
          Text('لو التمرين مش مريح، وقفيه وارجعي لتنفسك الطبيعي.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted)),
          SizedBox(height: 18),
          Container(height: 420, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(28), border: Border.all(color: AppColors.border)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ScaleTransition(scale: orb, child: Container(width: 170, height: 170, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.gold), child: Center(child: Text('$phaseSeconds', style: TextStyle(color: AppColors.forest, fontSize: 30, fontWeight: FontWeight.bold))))),
            SizedBox(height: 22), Text(cue, style: TextStyle(color: AppColors.gold, fontSize: 23, fontWeight: FontWeight.bold)),
            Text('شهيق هادي ٤ ثواني · ثبات ثانيتين · زفير ٦ ثواني', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
            SizedBox(height: 10), Text(remaining == 0 ? 'اختاري المدة' : 'باقي $remaining ثانية', style: TextStyle(color: AppColors.gold)),
            SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [DropdownButton<int>(value: duration, items: const [DropdownMenuItem(value: 60, child: Text('دقيقة واحدة')), DropdownMenuItem(value: 120, child: Text('دقيقتين'))], onChanged: running ? null : (v) => setState(() => duration = v ?? 60)), SizedBox(width: 12), FilledButton(onPressed: start, child: Text(running ? 'إيقاف مؤقت' : remaining > 0 ? 'كمّلي التمرين' : 'ابدئي'))]),
          ])),
          SizedBox(height: 12), Text('مش لازم تاخدي نفس عميق. خلي النفس مريح وطبيعي، ووقفي لو حسيتي بدوخة أو ضيق.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted, fontSize: 12)),
        ]),
      );
}
