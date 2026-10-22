// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_mark.dart';
import '../widgets/primary_button.dart';
import '../widgets/theme_toggle_button.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int page = 0;
  final pages = const [
    _PageData(Icons.favorite_border, 'مكان أهدأ تبدأ منه', 'افسح مكانًا لما تشعر به حقًا.', 'EUNOIA مساحة خاصة تطمئن فيها على نفسك، وتلاحظ أنماطك، وتجد خطوات صغيرة للأمام، بلا أحكام ولا ضغوط.', 'رفاهيتك ملك لك.'),
    _PageData(Icons.lock_outline, 'مبني حول خصوصيتك', 'أفكارك تبقى شخصية.', 'تأملاتك ملك لك. نبقي تجربتك هادئة وواضحة، بلا ملفات عامة ولا خلاصة اجتماعية ولا أداة تحاول مجاراتك.', 'خاص بالتصميم. داعم بالطبيعة.'),
    _PageData(Icons.auto_awesome, 'نقطة بداية مفيدة', 'افهم الإشارة، لا الوصمة.', 'فحص الرفاهية الاختياري يساعدك تلاحظ متى قد يفيدك دعم إضافي. ليس تشخيصًا ولا يغني عن رعاية مختص.', 'فحوصات صغيرة. فهم أعمق لنفسك.'),
  ];

  void next() {
    if (page < 2) { setState(() => page++); } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AuthScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = pages[page];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: Column(children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(24, 20, 24, 26),
          decoration: BoxDecoration(color: AppColors.forest, borderRadius: BorderRadius.vertical(bottom: Radius.circular(38))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [BrandMark(light: true, compact: true), SizedBox(width: 8), ThemeToggleButton(compact: true)]),
              TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AuthScreen())), child: Text('تخطي', style: TextStyle(color: Colors.white, fontSize: 17))),
            ]),
            SizedBox(height: 26),
            Text('طريقة اللطف\nلتلتقي بنفسك.', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontSize: 38, height: 1.25, fontWeight: FontWeight.w700)),
            SizedBox(height: 14),
            Text('رفيق خاص للرفاهية، للأيام الواضحة... وتلك التي ليست كذلك.', textAlign: TextAlign.right, style: TextStyle(color: Color(0xFFD2DEDA), fontSize: 17, height: 1.6)),
          ]),
        ),
        Expanded(child: SingleChildScrollView(child: Padding(padding: EdgeInsets.fromLTRB(26, 22, 26, 18), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('03 / 0${page + 1}', style: TextStyle(color: AppColors.cream, fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(width: 14),
            ...List.generate(3, (i) => Container(width: i == page ? 48 : 27, height: 5, margin: EdgeInsets.only(left: 8), decoration: BoxDecoration(color: i == page ? AppColors.gold : AppColors.border, borderRadius: BorderRadius.circular(9))),
        )]),
          SizedBox(height: 34),
          Align(alignment: Alignment.centerRight, child: Container(width: 76, height: 76, decoration: BoxDecoration(color: AppColors.surface2, borderRadius: BorderRadius.circular(24)), child: Icon(item.icon, color: AppColors.gold, size: 38))),
          SizedBox(height: 30),
          Text(item.eyebrow, textAlign: TextAlign.right, style: TextStyle(color: AppColors.coral, fontSize: 17, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(item.title, textAlign: TextAlign.right, style: TextStyle(color: AppColors.cream, fontSize: 33, height: 1.25, fontWeight: FontWeight.w700)),
          SizedBox(height: 16),
          Text(item.body, textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, fontSize: 18, height: 1.75)),
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Flexible(child: Text(item.note, textAlign: TextAlign.right, style: TextStyle(color: AppColors.cream, fontSize: 17, fontWeight: FontWeight.w700))),
            SizedBox(width: 12), CircleAvatar(radius: 18, backgroundColor: AppColors.surface2, child: Icon(Icons.check, color: AppColors.gold, size: 20)),
          ]),
          SizedBox(height: 28), Divider(color: AppColors.border, height: 28),
          LayoutBuilder(builder: (context, box) => box.maxWidth < 390
              ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  PrimaryButton(label: page == 2 ? 'ادخل EUNOIA' : 'متابعة', onPressed: next),
                  SizedBox(height: 10),
                  Text('يمكنك تغيير تفضيلاتك في أي وقت.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.5)),
                ])
              : Row(children: [
                  SizedBox(width: 174, child: PrimaryButton(label: page == 2 ? 'ادخل EUNOIA' : 'متابعة', onPressed: next)),
                  SizedBox(width: 14),
                  Expanded(child: Text('يمكنك تغيير تفضيلاتك في أي وقت.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.5))),
                ])),
        ])))),
      ])),
    );
  }
}

class _PageData {
  const _PageData(this.icon, this.eyebrow, this.title, this.body, this.note);
  final IconData icon;
  final String eyebrow, title, body, note;
}
