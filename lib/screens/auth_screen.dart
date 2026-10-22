import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_mark.dart';
import '../widgets/primary_button.dart';
import '../widgets/theme_toggle_button.dart';
import 'dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isRegister = true;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: SingleChildScrollView(child: Column(children: [
          Container(width: double.infinity, padding: EdgeInsets.fromLTRB(24, 20, 24, 28), decoration: BoxDecoration(color: AppColors.forest, borderRadius: BorderRadius.vertical(bottom: Radius.circular(38))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [BrandMark(light: true, compact: true), ThemeToggleButton(compact: true)])),
          Center(child: ConstrainedBox(constraints: BoxConstraints(maxWidth: 640), child: Padding(padding: EdgeInsets.fromLTRB(24, 32, 24, 24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(isRegister ? 'افسح مساحة لنفسك' : 'أهلًا بعودتك', textAlign: TextAlign.right, style: TextStyle(color: AppColors.coral, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(isRegister ? 'ابدأ بلطف.' : 'سعداء برؤيتك.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.cream, fontSize: 39, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text(isRegister ? 'بضع تفاصيل، ثم تصبح مساحتك الخاصة جاهزة.' : 'مساحتك الشخصية بانتظارك.', textAlign: TextAlign.right, style: TextStyle(color: AppColors.muted, fontSize: 17)),
            SizedBox(height: 26),
            Container(height: 58, padding: EdgeInsets.all(5), decoration: BoxDecoration(color: AppColors.sand, borderRadius: BorderRadius.circular(32)), child: Row(children: [
              _tab('إنشاء حساب', true), _tab('تسجيل الدخول', false),
            ])),
            SizedBox(height: 18),
            OutlinedButton.icon(onPressed: () => _notice('تسجيل Google تجريبي'), icon: CircleAvatar(radius: 12, backgroundColor: AppColors.coral, child: Text('G', style: TextStyle(color: Colors.white, fontSize: 13))), label: Text('المتابعة عبر جوجل'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.cream, side: BorderSide(color: AppColors.border), minimumSize: Size.fromHeight(58), shape: StadiumBorder(), textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
            SizedBox(height: 18),
            Row(children: [Expanded(child: Divider(color: AppColors.border)), Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('أو استخدم البريد', style: TextStyle(color: AppColors.muted))), Expanded(child: Divider(color: AppColors.border))]),
            SizedBox(height: 20),
            if (isRegister) ...[
              _field('اسمك', 'بماذا نناديك؟', Icons.person_outline), SizedBox(height: 16),
            ],
            _field('البريد الإلكتروني', 'you@example.com', Icons.mail_outline, keyboard: TextInputType.emailAddress),
            SizedBox(height: 16), _field('كلمة المرور', '٦ أحرف على الأقل', Icons.lock_outline, obscure: hidePassword, suffix: IconButton(onPressed: () => setState(() => hidePassword = !hidePassword), icon: Icon(hidePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.muted))),
            if (!isRegister) Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => _notice('استعادة كلمة المرور'), child: Text('نسيت كلمة المرور؟', style: TextStyle(color: AppColors.forest, fontWeight: FontWeight.bold)))),
            SizedBox(height: 20),
            PrimaryButton(label: isRegister ? 'أنشئ مساحتي' : 'افتح مساحتي', onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen()))),
            SizedBox(height: 18),
            Text('بالمتابعة، أنت توافق على استخدام EUNOIA لمعلوماتك بعناية. بلا تشخيص، بلا أحكام.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.6)),
          ])))),
        ]))),
      );

  Widget _tab(String label, bool register) {
    final selected = isRegister == register;
    return Expanded(child: GestureDetector(onTap: () => setState(() => isRegister = register), child: Container(alignment: Alignment.center, decoration: BoxDecoration(color: selected ? AppColors.surface : Colors.transparent, borderRadius: BorderRadius.circular(28), boxShadow: selected ? [BoxShadow(color: Color(0x18000000), blurRadius: 8)] : null), child: Text(label, style: TextStyle(color: AppColors.cream, fontWeight: FontWeight.bold, fontSize: 16)))));
  }

  Widget _field(String label, String hint, IconData icon, {TextInputType? keyboard, bool obscure = false, Widget? suffix}) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(label, textAlign: TextAlign.right, style: TextStyle(color: AppColors.cream, fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8), TextField(keyboardType: keyboard, obscureText: obscure, textAlign: TextAlign.right, decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: AppColors.muted), prefixIcon: Icon(icon, color: AppColors.muted), suffixIcon: suffix, filled: true, fillColor: AppColors.surface, contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20), border: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide(color: AppColors.border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide(color: AppColors.border)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40), borderSide: BorderSide(color: AppColors.forest, width: 1.5)))),
      ]);

  void _notice(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message, textAlign: TextAlign.right), behavior: SnackBarBehavior.floating));
}
