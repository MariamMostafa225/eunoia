import 'package:flutter/material.dart';
import '../data/eunoia_store.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class ChatScreen extends StatefulWidget { ChatScreen({super.key}); @override State<ChatScreen> createState() => _ChatScreenState(); }

class _ChatScreenState extends State<ChatScreen> {
  final store = EunoiaStore.instance;
  final input = TextEditingController();
  final scroll = ScrollController();
  static const greeting = 'أهلًا بيكي في «احكي» 🤍\nأنا مساحة تجريبية أسمعك وأساعدك ترتبي أفكارك. تحبي تحكيلي إيه شاغل بالك؟';
  void send() async {
    final text = input.text.trim(); if (text.isEmpty) return;
    input.clear(); store.chat.add({'from': 'user', 'text': text});
    final normalized = text.replaceAll(RegExp('[إأآ]'), 'ا').replaceAll('ى', 'ي');
    String reply;
    if (['انتحر', 'أقتل نفسي', 'اذي نفسي', 'أؤذي نفسي', 'مش عايزة أعيش'].any(normalized.contains)) {
      reply = 'أنا آسفة إنك بتمري بالوجع ده. سلامتك أهم حاجة دلوقتي. لو في خطر مباشر، ماتفضليش لوحدك: روحي لشخص قريب أو لمكان آمن واتصلي بالطوارئ المحلية فورًا. يونويا مش خدمة طوارئ.';
      WidgetsBinding.instance.addPostFrameCallback((_) => showDialog<void>(context: context, builder: (ctx) => AlertDialog(title: Text('خلّينا نركز على سلامتك'), content: Text('لو في خطر فوري، اتصلي بالطوارئ المحلية أو خلي حد قريب يفضل معاكي. يونويا مش خدمة طوارئ.'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text('حاضر'))])));
    } else if (RegExp('نوم|مرهق|تعب|إرهاق').hasMatch(text)) {
      reply = 'واضح إن الراحة شاغلة بالك. إيه تغيير صغير ممكن يسهّل عليكي الليلة؟';
    } else if (RegExp('شغل|دراسة|امتحان|جامعة').hasMatch(text)) {
      reply = 'ضغط الشغل أو الدراسة ممكن يبقى تقيل. إيه أول خطوة صغيرة تقدري تعمليها من غير ما تحلي كل حاجة مرة واحدة؟';
    } else if (RegExp('قلق|خايف|توتر').hasMatch(text)) {
      reply = 'القلق مرهق فعلًا. تحبي نجرب نفس هادي سوا، ولا تفضلي تكملي حكي؟';
    } else {
      reply = 'شكرًا إنك حكيتيلي. تحبي تقوليلي أكتر عن الجزء اللي مأثر عليكي؟';
    }
    store.chat.add({'from': 'bot', 'text': reply}); await store.save(); if (mounted) setState(() {});
  }

  @override
  void dispose() {
    input.dispose();
    scroll.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) => Column(children: [
        Padding(padding: EdgeInsets.fromLTRB(20, 16, 20, 8), child: PageHeading(eyebrow: 'مساحة كلام من غير أحكام', title: 'احكي', subtitle: 'خدي راحتك في الكلام. مش لازم ترتبي أفكارك.')),
        Expanded(child: Center(child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 900),
          child: Container(
            margin: EdgeInsets.fromLTRB(18, 8, 18, 18),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(26)),
            child: Column(children: [
              Container(width: double.infinity, padding: EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.rail, borderRadius: BorderRadius.circular(16)), child: Text('يونويا · مساعدة تجريبية · مش بديل عن مختص', textAlign: TextAlign.right, style: TextStyle(color: AppColors.gold))),
              Expanded(child: ListView(padding: EdgeInsets.symmetric(vertical: 12), children: [
                for (final m in (store.chat.isEmpty ? [{'from': 'bot', 'text': greeting}] : store.chat)) Align(
                  alignment: m['from'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(margin: EdgeInsets.symmetric(vertical: 6), padding: EdgeInsets.all(14), constraints: BoxConstraints(maxWidth: constraints.maxWidth < 520 ? constraints.maxWidth * .72 : 520), decoration: BoxDecoration(color: m['from'] == 'user' ? AppColors.gold : AppColors.surface2, borderRadius: BorderRadius.circular(18)), child: Text(m['text'] ?? '', textAlign: TextAlign.right, style: TextStyle(color: m['from'] == 'user' ? AppColors.forestDark : AppColors.cream))),
                ),
              ])),
              Row(children: [
                Expanded(child: TextField(controller: input, textAlign: TextAlign.right, maxLength: 1000, onSubmitted: (_) => send(), decoration: InputDecoration(counterText: '', hintText: 'اكتبي اللي حابة تحكيه...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(18))))),
                SizedBox(width: 8),
                IconButton.filled(onPressed: send, icon: Icon(Icons.send)),
              ]),
              SizedBox(height: 4),
              Text('ردود تجريبية جاهزة؛ الخدمة ليست متصلة فعليًا بـ NLP أو RAG. لا تكتبي معلومات تعريفية حساسة.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted, fontSize: 11)),
            ]),
          ),
        ))),
      ]));
}
