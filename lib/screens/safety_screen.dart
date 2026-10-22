import 'package:flutter/material.dart';
import '../data/eunoia_store.dart';
import '../theme/app_theme.dart';

class SafetyScreen extends StatefulWidget { const SafetyScreen({super.key}); @override State<SafetyScreen> createState() => _SafetyScreenState(); }

class _SafetyScreenState extends State<SafetyScreen> {
  final store = EunoiaStore.instance;
  final fields = const {
    'warning': ('علامات بتفهمني إني محتاجة أهدى', 'إيه العلامات اللي بتلاحظيها؟'),
    'calm': ('حاجات بتساعدني أهدى', 'اكتبي اختياراتك هنا...'),
    'safePlaces': ('أماكن بحس فيها بأمان', 'مكان أو نشاط ممكن يساعدك...'),
    'people': ('أشخاص أقدر أكلمهم', 'اسم أو رقم شخص تثقي فيه...'),
    'support': ('مختص أو خدمة دعم أقدر أوصل لها', 'بيانات تواصلك...'),
    'emergency': ('رقم الطوارئ المحلي', 'اكتبي الرقم المناسب لمكانك...'),
  };
  late final Map<String, TextEditingController> controllers = {for (final e in fields.entries) e.key: TextEditingController(text: store.safety[e.key] ?? '')};

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => ListView(padding: EdgeInsets.all(20), children: [
          Text('اكتبي خطواتك وقت الضغط', textAlign: TextAlign.right, style: TextStyle(color: AppColors.gold, fontSize: 26, fontWeight: FontWeight.bold)),
          Text('اكتبي خطوات عملية ترجعي لها. تقدري تعدليها في أي وقت.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted)),
          SizedBox(height: 14),
          Container(padding: EdgeInsets.all(14), decoration: BoxDecoration(color: Color(0xFF392F2B), borderRadius: BorderRadius.circular(16)), child: Text('لو في خطر فوري، أو مش قادرة تحافظي على سلامتك، اتصلي بالطوارئ المحلية أو توجهي لأقرب قسم طوارئ وخلي شخص موثوق معاكي. يونويا مش خدمة طوارئ.', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFFF3D9D1)))),
          SizedBox(height: 12),
          LayoutBuilder(builder: (context, constraints) {
            final columns = constraints.maxWidth >= 900 ? 3 : constraints.maxWidth >= 580 ? 2 : 1;
            return Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(24)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 14,
                  childAspectRatio: columns == 3 ? 1.9 : columns == 2 ? 1.55 : 2.5,
                  children: [for (final f in fields.entries) TextField(
                    controller: controllers[f.key],
                    maxLines: 3,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(labelText: f.value.$1, hintText: f.value.$2, alignLabelWithHint: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(18))),
                  )],
                ),
                SizedBox(height: 18),
                Align(alignment: Alignment.centerRight, child: FilledButton(onPressed: () async { for (final e in controllers.entries) { store.safety[e.key] = e.value.text.trim(); } await store.save(); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطة الأمان اتحفظت.'))); }, child: Text('احفظي الخطة'))),
                SizedBox(height: 8),
                Text('خطة الأمان محفوظة على هذا الجهاز فقط، وليست خدمة طوارئ.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, fontSize: 12)),
              ]),
            );
          }),
        ]);
}
