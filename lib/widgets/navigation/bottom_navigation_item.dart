import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigationItem extends StatelessWidget {
  final String iconPath;
  final String selectedPath;
  final bool isSelected;
  final VoidCallback onTap;

  const BottomNavigationItem({
    super.key,
    required this.iconPath,
    required this.selectedPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            isSelected ? selectedPath : iconPath,
            height: 20,
            width: 20,
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: 4,
              width: 9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}
