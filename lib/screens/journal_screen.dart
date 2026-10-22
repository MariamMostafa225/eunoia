import 'package:flutter/material.dart';
import '../data/eunoia_store.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import 'assessment_screen.dart';

class JournalScreen extends StatefulWidget {
  JournalScreen({super.key, this.onTab});
  final ValueChanged<int>? onTab;
  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final controller = TextEditingController();
  final selected = <String>{};
  final feelings = const ['قلق', 'حزن', 'ضغط', 'هدوء', 'أمل', 'إرهاق', 'وحدة', 'امتنان'];
  final store = EunoiaStore.instance;

  Future<void> saveEntry() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    store.entries.add({'id': DateTime.now().microsecondsSinceEpoch.toString(), 'text': text, 'feelings': selected.toList(), 'date': DateTime.now().toIso8601String()});
    controller.clear(); selected.clear(); await store.save();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final wide = MediaQuery.sizeOf(context).width > 850;
        return ListView(
          padding: EdgeInsets.fromLTRB(wide ? 72 : 20, wide ? 38 : 20, wide ? 72 : 20, 90),
          children: [
            PageHeading(eyebrow: 'كلماتك ومساحتك', title: 'يومياتي', subtitle: 'اكتبي عن إحساسك اليوم أو الفترة اللي فاتت. اكتبي اللي ييجي في بالك، حتى لو مش مرتب.'),
            SizedBox(height: 18),
            wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: _editor()), SizedBox(width: 17), Expanded(child: _entries())])
                : Column(children: [_editor(), SizedBox(height: 16), _entries()]),
          ],
        );
      });

  Widget _editor() => AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('إيه اللي شاغل بالك؟', style: TextStyle(color: AppColors.gold, fontSize: 20, fontWeight: FontWeight.bold)),
        Text('إيه اللي حصل؟ وإيه أكتر حاجة محتاجة اهتمام منك؟', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted)),
        SizedBox(height: 10),
        TextField(controller: controller, maxLength: 1800, maxLines: 6, textAlign: TextAlign.right, decoration: InputDecoration(hintText: 'أنا حاسة بـ... اليومين دول...', filled: true, fillColor: AppColors.rail, border: OutlineInputBorder())),
        SizedBox(height: 8), Text('اختاري إحساس أو أكتر (اختياري)', style: TextStyle(color: AppColors.gold)),
        Wrap(alignment: WrapAlignment.end, children: feelings.map((f) => FilterChip(label: Text(f), selected: selected.contains(f), onSelected: (v) => setState(() => v ? selected.add(f) : selected.remove(f))).marginOnly(left: 4, top: 4)).toList()),
        Align(alignment: Alignment.centerRight, child: FilledButton(onPressed: saveEntry, child: Text('احفظي اليومية'))),
        Text('اليوميات محفوظة على نفس الجهاز. مفيش تحليل نفسي فعلي للكلام هنا.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, fontSize: 12)),
      ]));

  Widget _entries() => AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('ملاحظاتك الأخيرة · ${store.entries.length} يومية', style: TextStyle(color: AppColors.gold, fontSize: 19, fontWeight: FontWeight.bold)),
        if (store.entries.isEmpty) Text('لما تحفظي أول يومية، هتلاقيها هنا.', style: TextStyle(color: AppColors.muted))
        else ...store.entries.reversed.take(8).map((e) => ListTile(contentPadding: EdgeInsets.zero, title: Text(e['text'] ?? '', textAlign: TextAlign.right), subtitle: Text((e['feelings'] as List? ?? []).join(' · '), textAlign: TextAlign.right), trailing: Icon(Icons.edit_note, color: AppColors.coral))),
        if (store.entries.isNotEmpty) Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AssessmentScreen())), child: Text('ابدئي أسئلة المتابعة الاختيارية'))),
      ]));
}

extension _ChipMargin on Widget {
  Widget marginOnly({double left = 0, double top = 0}) => Padding(padding: EdgeInsets.only(left: left, top: top), child: this);
}
