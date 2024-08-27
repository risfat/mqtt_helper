import 'package:example/main.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onTap,
    required this.label,
    this.width,
    this.backgroundColor,
  });

  final VoidCallback onTap;
  final String label;
  final double? width;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: width ?? double.maxFinite,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? ColorsValue.blackColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.sixTeen,
            ),
          ),
          foregroundColor: ColorsValue.whiteColor,
        ),
        onPressed: onTap,
        child: Text(
          label,
        ),
      ),
    );
  }
}
