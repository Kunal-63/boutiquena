import 'package:customer_app/config/text_styles.dart';
import 'package:customer_app/config/theme.dart';
import 'package:customer_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final VoidCallback menuPressed;
  final List<PopupMenuEntry<int>> menuItems;

  const CommonAppBar({
    required this.title,
    required this.menuPressed,
    required this.menuItems,
    super.key,
  });

  void _showCustomPopupMenu(BuildContext context) {
    final RenderBox appBar = context.findRenderObject() as RenderBox;
    final Offset offset = appBar.localToGlobal(Offset.zero, ancestor: null);

    showMenu(
      color: Colors.white,
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx + appBar.size.width - 140, // Align menu with button
        offset.dy + appBar.size.height - 20, // Place below AppBar
        offset.dx + appBar.size.width,
        offset.dy + appBar.size.height,
      ),
      shape: TooltipShapeMatch(), // Custom shape with an arrow
      elevation: 0, // Removed shadow or elevation

      items: menuItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      color: AppTheme.primaryColor,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: SvgPicture.asset('assets/icons/left-icon.svg'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              title,
              style: AppTextStyles.whitew400Outfit().copyWith(
                fontSize: 20 * SizeConfig.widthScale,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () => _showCustomPopupMenu(context),
            ),
          ],
        ),
      ),
    );
  }
}

class TooltipShapeMatch extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    const double arrowHeight = 10.0; // Height of the arrow
    const double arrowWidth = 15.0; // Width of the arrow
    const double radius = 5.0; // Rounded corners
    const double shiftRight = 10.0; // Adjust this to align the arrow properly
    const double rectWidth = 120.0; // Reduced width of the rectangle

    // Adjusted rectangle (excluding arrow) with fixed width
    final Rect adjustedRect = Rect.fromLTWH(
      rect.left - 10, // Move rectangle slightly to the right
      rect.top + arrowHeight,
      rectWidth,
      rect.height - arrowHeight,
    );

    final Path path = Path()
      // Rounded rectangle
      ..addRRect(
        RRect.fromRectAndRadius(
          adjustedRect,
          const Radius.circular(radius),
        ),
      )
      // Triangle (arrow) at the top-right corner
      ..moveTo(
        adjustedRect.right - arrowWidth - shiftRight,
        rect.top + arrowHeight,
      ) // Left point
      ..lineTo(
        adjustedRect.right - shiftRight - arrowHeight / 2,
        rect.top,
      ) // Tip of arrow
      ..lineTo(
        adjustedRect.right - shiftRight,
        rect.top + arrowHeight,
      ) // Right point
      ..close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
