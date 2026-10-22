import 'package:flutter/material.dart';
import '../data/eunoia_store.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class RatingScreen extends StatelessWidget {
  RatingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final data = EunoiaStore.instance;
    return ListView(padding: EdgeInsets.all(20), children: [
      PageHeading(eyebrow: 'ملاحظاتك على مدار الوقت', title: 'تقييمي', subtitle: 'نظرة بسيطة على الإحساس اللي سجلتيه بنفسك. ده مش تشخيص ولا قياس طبي.'),
      SizedBox(height: 18),
      Wrap(spacing: 10, runSpacing: 10, children: [
        _stat('إحساسات آخر ٧ أيام', '${data.moods.length}', 'تسجيلات انعكاسية'),
        _stat('الأسبوع اللي قبله', '—', 'مفيش بيانات كفاية للمقارنة'),
        _stat('اليوميات والمتابعات', '${data.entries.length} / ${data.assessments.length}', 'يوميات محفوظة / متابعات'),
      ]),
      SizedBox(height: 16),
      AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('الأسبوع ده كان عامل إزاي؟', style: TextStyle(color: AppColors.gold, fontSize: 19, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        SizedBox(height: 160, child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(7, (i) {
          final values = data.moods.reversed.take(7).toList();
          final h = i < values.length ? 30.0 + ((values[i]['label'] == 'رايقة' ? 4 : values[i]['label'] == 'متوازنة' ? 3 : values[i]['label'] == 'قلقانة' ? 2 : 1) * 25) : 12.0;
          return Container(width: 18, height: h, decoration: BoxDecoration(color: i < values.length ? AppColors.gold : AppColors.border, borderRadius: BorderRadius.circular(9)));
        }))),
        Text('مفيش تسجيل في يوم؟ مش هنعمل له تقدير.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
      ])),
      SizedBox(height: 16),
      AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('إنتِ بتقدمي إزاي؟', style: TextStyle(color: AppColors.gold, fontSize: 19, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('تمرين التنفس: ${data.breathSessions} · تسجيل الإحساس: ${data.moods.length} · أسئلة المتابعة: ${data.assessments.length}', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, height: 1.8)),
        Text('الاستجابة هنا معناها إنك بتاخدي وقت لنفسك وتستخدمي الأدوات، مش إن فيه نتيجة نفسية محددة لازم توصليلها.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted)),
      ])),
    ]);
  }

  Widget _stat(String title, String value, String note) => SizedBox(width: 160, child: AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(title, textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, fontSize: 12)), Text(value, style: TextStyle(color: AppColors.gold, fontSize: 27, fontWeight: FontWeight.bold)), Text(note, textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, fontSize: 11))])));
}
