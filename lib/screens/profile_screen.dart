// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/eunoia_store.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, this.onTab});
  final ValueChanged<int>? onTab;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final store = EunoiaStore.instance;
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  @override
  void initState() {
    super.initState();
    nameController.text = store.name;
    contactController.text = store.contact;
  }

  Future<void> exportData() async {
    final json = JsonEncoder.withIndent('  ').convert({
      'name': store.name,
      'moods': store.moods,
      'entries': store.entries,
      'assessments': store.assessments,
      'safety': store.safety,
    });
    await Clipboard.setData(ClipboardData(text: json));
    if (mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('نسخة JSON من بياناتك نُسخت للحافظة.')),
      );
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final wide = constraints.maxWidth >= 900;
      return ListView(
        padding: EdgeInsets.all(wide ? 28 : 18),
        children: [
          PageHeading(
            eyebrow: 'مساحتك وإعداداتك',
            title: 'ملفي الشخصي',
            subtitle: 'اختاري إيه اللي يخلي استخدامك ليونويا أريح وأأمن.',
          ),
          SizedBox(height: 20),
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _profileDataCard()),
                SizedBox(width: 18),
                Expanded(child: _preferencesCard()),
              ],
            )
          else ...[
            _profileDataCard(),
            SizedBox(height: 16),
            _preferencesCard(),
          ],
          SizedBox(height: 18),
          _supportCard(),
          SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => widget.onTab?.call(5),
            icon: Icon(Icons.favorite_border),
            label: Text('خطة الأمان الشخصية'),
          ),
          SizedBox(height: 22),
          Text(
            'أداة دعم وتأمل أولية، وليست تشخيصًا أو خدمة طوارئ.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 14),
          ),
        ],
      );
    },
  );

  Widget _profileDataCard() => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'بياناتك',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'اسم تحبي نناديكي بيه',
          textAlign: TextAlign.right,
          style: TextStyle(color: AppColors.muted, fontSize: 16),
        ),
        TextField(
          controller: nameController,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(hintText: 'اسمك أو اسم مستعار'),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: () async {
              store.name = nameController.text.trim();
              await store.save();
            },
            child: Text('احفظي التعديلات'),
          ),
        ),
        Text(
          'استخدمي اسم مستعار لو حابة. البيانات محفوظة محليًا في النموذج.',
          textAlign: TextAlign.right,
          style: TextStyle(color: AppColors.muted, fontSize: 14),
        ),
      ],
    ),
  );

  Widget _preferencesCard() => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'تفضيلاتك',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Material(
          color: AppColors.surface,
          child: SwitchListTile(
            title: Text('تذكير لطيف', textAlign: TextAlign.right),
            subtitle: Text(
              'تذكير أسبوعي إنك تاخدي لحظة لنفسك',
              textAlign: TextAlign.right,
            ),
            value: store.reminders,
            onChanged: (v) async {
              store.reminders = v;
              await store.save();
              setState(() {});
            },
          ),
        ),
        Material(
          color: AppColors.surface,
          child: SwitchListTile(
            title: Text('الوضع المريح', textAlign: TextAlign.right),
            subtitle: Text(
              'ألوان داكنة أهدى للعين',
              textAlign: TextAlign.right,
            ),
            value: store.dark,
            onChanged: (v) async {
              store.dark = v;
              await store.save();
            },
          ),
        ),
        Material(
          color: AppColors.surface,
          child: ListTile(
            title: Text('تصدير بياناتك', textAlign: TextAlign.right),
            subtitle: Text(
              'نزّلي نسخة من اليوميات والتسجيلات',
              textAlign: TextAlign.right,
            ),
            trailing: Icon(Icons.download_outlined),
            onTap: exportData,
          ),
        ),
        Material(
          color: AppColors.surface,
          child: ListTile(
            title: Text('مسح بيانات النموذج', textAlign: TextAlign.right),
            subtitle: Text(
              'حذفها من الجهاز الحالي',
              textAlign: TextAlign.right,
            ),
            trailing: Icon(Icons.delete_outline, color: AppColors.coral),
            onTap: _confirmClearData,
          ),
        ),
      ],
    ),
  );

  Future<void> _confirmClearData() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('متأكدة تمسحي بياناتك؟'),
        content: Text('الحذف هيمسح اليوميات والتسجيلات وخطة الأمان من الجهاز.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
          FilledButton(
            onPressed: () async {
              await store.clear();
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) {
                setState(() {
                  nameController.clear();
                  contactController.clear();
                });
              }
            },
            child: Text('امسحي البيانات'),
          ),
        ],
      ),
    );
  }

  Widget _supportCard() => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'شخص دعم تثقي فيه',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'اختياري: احفظي رقم شخص قريب منك. واتساب يفتح مسودة تراجعيها بنفسك قبل الإرسال.',
          textAlign: TextAlign.right,
          style: TextStyle(color: AppColors.muted, fontSize: 15),
        ),
        TextField(
          controller: contactController,
          keyboardType: TextInputType.phone,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            labelText: 'رقم واتساب مع كود الدولة',
            hintText: 'مثال: 2010XXXXXXXX',
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: () async {
              store.contact = contactController.text.replaceAll(
                RegExp(r'[^0-9]'),
                '',
              );
              await store.save();
            },
            child: Text('احفظي الرقم'),
          ),
        ),
      ],
    ),
  );

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    super.dispose();
  }
}
