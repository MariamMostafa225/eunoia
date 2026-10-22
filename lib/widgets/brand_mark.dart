import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BrandMark extends StatelessWidget {
  BrandMark({super.key, this.light = false, this.compact = false, this.arabic = false});
  final bool light;
  final bool compact;
  final bool arabic;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 48 : 68,
            height: compact ? 48 : 68,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(compact ? 14 : 22),
            ),
            child: Icon(Icons.eco_outlined, color: AppColors.forest, size: 34),
          ),
          SizedBox(width: 14),
          Text(arabic ? 'يونويا' : 'EUNOIA', style: TextStyle(
            color: light ? Colors.white : AppColors.forest,
            fontSize: compact ? 23 : 31,
            letterSpacing: arabic ? 1 : 5,
            fontWeight: FontWeight.w500,
          )),
        ],
      );
}
