import 'package:flutter/material.dart';

import '../../config/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final Function? onTap;
  final bool disble;
  final double fountSize;
  final double height;
  final double white;
  final Color? colors;
  final bool outline;
  final double radius;

  const CustomButton({
    required this.title,
    required this.onTap,
    this.outline = false,
    this.height = 35,
    this.white = 90,
    this.colors,
    this.radius = 100,
    this.disble = false,
    this.fountSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        disble == false ? onTap!() : null;
      },
      child: AnimatedContainer(
        width: white,
        decoration: BoxDecoration(
          color: outline == false
              ? disble == false
                  ? colors == null
                      ? AppColor.primaryColor
                      : colors
                  : Theme.of(context).colorScheme.onSecondary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          border: outline == false
              ? const Border()
              : Border.all(
                  color: Theme.of(context).colorScheme.onSecondary,
                  width: 1,
                ),
        ),
        height: height,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 150),
        child: Center(
          child: Text(
            "$title",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: outline == false ? Colors.white : AppColor.primaryColor,
                fontSize: fountSize),
          ),
        ),
      ),
    );
  }
}
