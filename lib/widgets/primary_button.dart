import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({super.key, required this.label, required this.onPressed, this.icon = Icons.arrow_forward});
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 64,
        width: double.infinity,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.forest,
            foregroundColor: Colors.white,
            shape: StadiumBorder(),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon), SizedBox(width: 12),
            Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: Text(label, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700)))),
          ]),
        ),
      );
}
