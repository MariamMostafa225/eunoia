import 'package:flutter/material.dart';
import '../data/eunoia_store.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import 'breathing_screen.dart';
import 'chat_screen.dart';
import 'journal_screen.dart';
import 'profile_screen.dart';
import 'rating_screen.dart';
import 'safety_screen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int index = 0;
  final store = EunoiaStore.instance;
  String? selectedMood;
  final moods = const ['رايقة', 'متوازنة', 'قلقانة', 'مضغوطة'];
  final moodIcons = const [
    Icons.wb_sunny_outlined,
    Icons.balance,
    Icons.cloud_outlined,
    Icons.umbrella_outlined,
  ];

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
    if (mounted) {
      if (store.moods.isNotEmpty) selectedMood = store.moods.last['label'] as String?;
      setState(() {});
    }
  }

  void _select(int i) => setState(() => index = i);

  @override
  Widget build(BuildContext context) {
    final pages = [
      _home(),
      JournalScreen(onTab: _select),
      ChatScreen(),
      RatingScreen(),
      ProfileScreen(onTab: _select),
      SafetyScreen(),
    ];
    return AppScaffold(
      title: 'يونويا · مساحتك الآمنة',
      selectedIndex: index,
      onSelect: _select,
      child: pages[index],
    );
  }

  Widget _home() => LayoutBuilder(
        builder: (context, constraints) {
          final wide = MediaQuery.sizeOf(context).width > 850;
          return ListView(
            padding: EdgeInsets.fromLTRB(wide ? 72 : 17, 38, wide ? 72 : 17, 90),
            children: [
              PageHeading(
                eyebrow: 'الأربعاء، ٢١ أكتوبر · مساحتك',
                title: 'أهلًا بيكي، يا ${store.name.isEmpty ? 'صديقتي' : store.name}',
                subtitle: 'خدي نفس، وابتدي من المكان اللي إنتِ فيه النهارده.',
              ),
              SizedBox(height: 25),
              wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 8, child: _heroCard()),
                        SizedBox(width: 17),
                        Expanded(flex: 5, child: _moodCard()),
                      ],
                    )
                  : Column(
                      children: [
                        _heroCard(),
                        SizedBox(height: 16),
                        _moodCard(),
                      ],
                    ),
              SizedBox(height: 25),
              Text(
                'مساحتك للكتابة',
                textAlign: TextAlign.right,
                style: TextStyle(color: AppColors.gold, fontSize: 23, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              AppCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.edit_note, size: 38, color: AppColors.gold),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('إيه أكتر إحساس معاكي اليومين دول؟', textAlign: TextAlign.right, style: TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('اكتبي براحتك. دي يومياتك، مش محادثة.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted)),
                          TextButton(onPressed: () => _select(1), child: Text('اكتبي ملاحظة ←')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              AppCard(
                child: Row(children: [
                  OutlinedButton(onPressed: () => _select(5), child: Text('افتحي الخطة')),
                  SizedBox(width: 14),
                  Icon(Icons.favorite_border, color: AppColors.gold, size: 27),
                  SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('خطة الأمان', style: TextStyle(color: AppColors.coral, fontWeight: FontWeight.bold)),
                    Text('جهزي خطوات تساعدك وقت اللزوم', textAlign: TextAlign.right, style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('اكتبي اللي يطمنك ومين تقدري تكلميه.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted)),
                  ])),
                ]),
              ),
              SizedBox(height: 24),
              Text('حاجات بسيطة ممكن تساعد', textAlign: TextAlign.right, style: TextStyle(color: AppColors.gold, fontSize: 23, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              LayoutBuilder(builder: (context, box) {
                final count = box.maxWidth > 800 ? 3 : 1;
                final items = [
                  ('تنفسي على مهلك', 'دقيقة أو دقيقتين من الشهيق والزفير الهادئ.', Icons.circle_outlined, 'ابدئي', 0),
                  ('فضفضي على الورق', 'اكتبي اللي في بالك من غير ما ترتبيه.', Icons.edit_note, 'افتحي يومياتي', 1),
                  ('احكي شوية', 'مساحة كلام تجريبية للمساندة والتفكير.', Icons.auto_awesome, 'روحي للحكي', 2),
                ];
                return GridView.count(
                  crossAxisCount: count,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: wide ? 1.35 : 1.9,
                  children: [for (final item in items) _quickCard(item.$1, item.$2, item.$3, item.$4, item.$5)],
                );
              }),
            ],
          );
        },
      );

  Widget _heroCard() => AppCard(
        color: AppColors.gold,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('خطوة صغيرة مقترحة', style: TextStyle(color: AppColors.forestDark, fontSize: 12)),
            SizedBox(height: 6),
            Text('ابدئي بتسجيل بسيط', textAlign: TextAlign.right, style: TextStyle(color: AppColors.forestDark, fontSize: 25, fontWeight: FontWeight.bold)),
            Text('سيبي إحساس واحد ياخد مساحة. تمرين التنفس القصير ممكن يساعدك تهدي وتاخدي لحظة لنفسك.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.forestDark, height: 1.7)),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BreathingScreen())),
                icon: Icon(Icons.arrow_back),
                label: Text('ابدئي التدريب'),
              ),
            ),
          ],
        ),
      );

  Widget _moodCard() => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('إحساسك دلوقتي عامل إيه؟', textAlign: TextAlign.right, style: TextStyle(color: AppColors.gold, fontSize: 20, fontWeight: FontWeight.bold)),
            Text('اختاري الأقرب ليكي، من غير حكم.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, fontSize: 12)),
            SizedBox(height: 12),
            LayoutBuilder(builder: (context, box) => GridView.count(
              crossAxisCount: box.maxWidth > 320 ? 4 : 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 7,
              mainAxisSpacing: 7,
              childAspectRatio: .85,
              children: List.generate(moods.length, (i) => InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                    setState(() => selectedMood = moods[i]);
                    store.moods.add({'label': moods[i], 'date': DateTime.now().toIso8601String()});
                    await store.save();
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('سجلنا إحساسك. شكرًا إنك وقفتي مع نفسك لحظة.')));
                },
                child: Container(decoration: BoxDecoration(color: selectedMood == moods[i] ? AppColors.surface2 : AppColors.rail, border: Border.all(color: selectedMood == moods[i] ? AppColors.gold : AppColors.border, width: selectedMood == moods[i] ? 1.5 : 1), borderRadius: BorderRadius.circular(16)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(moodIcons[i], size: 22, color: AppColors.gold), SizedBox(height: 8), Text(moods[i], style: TextStyle(color: selectedMood == moods[i] ? AppColors.gold : AppColors.cream, fontSize: 11, fontWeight: selectedMood == moods[i] ? FontWeight.bold : FontWeight.normal))])),
              )),
            )),
            Text(store.moods.isEmpty ? 'مفيش إجابة صح أو غلط.' : 'تسجيلاتك بتساعدك تلاحظي التغيّر مع الوقت.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, fontSize: 12)),
          ],
        ),
      );

  Widget _quickCard(String title, String description, IconData icon, String action, int tab) => AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: AppColors.gold)),
          Spacer(),
          Text(title, textAlign: TextAlign.right, style: TextStyle(color: AppColors.gold, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(description, textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, fontSize: 12)),
          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {
            if (tab == 0) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => BreathingScreen()));
            } else {
              _select(tab);
            }
          }, child: Text('$action ←', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)))),
        ]),
      );
}
