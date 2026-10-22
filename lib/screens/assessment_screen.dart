import 'package:flutter/material.dart';
import '../data/eunoia_store.dart';
import '../theme/app_theme.dart';

class AssessmentScreen extends StatefulWidget { AssessmentScreen({super.key}); @override State<AssessmentScreen> createState() => _AssessmentScreenState(); }

class _AssessmentScreenState extends State<AssessmentScreen> {
  final questions = const [
    'خلال الأيام اللي فاتت، قد إيه حسّيتي إنك قادرة تهدي نفسك؟',
    'قد إيه لقيتي وقت لحاجة بتريحك؟',
    'هل قدرتي تطلبي دعم لما احتجتيه؟',
    'قد إيه كان النوم والراحة مناسبين ليكي؟',
    'إيه خطوة صغيرة تقدري تجربيها لنفسك؟',
    'هل كان فيه لحظات أمل أو امتنان؟',
    'إيه أكتر حاجة محتاجة اهتمام منك دلوقتي؟',
  ];
  final answers = <int>[];
  int index = 0;
  final choices = const ['ولا مرة', 'أحيانًا', 'غالبًا', 'تقريبًا دائمًا'];

  Future<void> next(int value) async {
    answers.add(value);
    if (index < 4) { setState(() => index++); return; }
    final store = EunoiaStore.instance;
    store.assessments.add({'date': DateTime.now().toIso8601String(), 'answers': answers});
    await store.save();
    if (!mounted) return;
    await showDialog<void>(context: context, builder: (ctx) => AlertDialog(title: Text('خلصتي المتابعة'), content: Text('إجاباتك تساعدك ترجعي لأفكارك، من غير تشخيص أو حكم. خدي اللي نافعك وسيبي الباقي.'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text('تمام'))]));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('متابعة اختيارية')),
        body: ListView(padding: EdgeInsets.all(22), children: [
          Text('أسئلة تساعدك تلاحظي', textAlign: TextAlign.right, style: TextStyle(color: AppColors.gold, fontSize: 27, fontWeight: FontWeight.bold)),
          Text('الأسئلة اختيارية، ومش اختبار تشخيصي. مفيش درجة نجاح أو رسوب.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, height: 1.6)),
          SizedBox(height: 20),
          LinearProgressIndicator(value: (index + 1) / 5, color: AppColors.gold, backgroundColor: AppColors.border),
          SizedBox(height: 22),
          Text('السؤال ${index + 1} من ٥', textAlign: TextAlign.right, style: TextStyle(color: AppColors.coral)),
          SizedBox(height: 10),
          Text(questions[(index + (questions.length - 5)) % questions.length], textAlign: TextAlign.right, style: TextStyle(color: AppColors.cream, fontSize: 20, height: 1.6)),
          SizedBox(height: 22),
          for (int i = 0; i < choices.length; i++) Padding(padding: EdgeInsets.only(bottom: 9), child: OutlinedButton(onPressed: () => next(i), child: Text(choices[i]))),
          SizedBox(height: 12), Text('فحوصات صغيرة للفهم الذاتي. ليست أداة تشخيص معتمدة.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted, fontSize: 12)),
        ]),
      );
}
