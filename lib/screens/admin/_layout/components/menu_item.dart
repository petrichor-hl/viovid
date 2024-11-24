import 'package:flutter/material.dart';
import 'package:viovid/base/common_variables.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.iconData,
    required this.text,
    this.isSelected = false,
    required this.onPress,
  });

  final IconData iconData;
  final String text;
  final bool isSelected;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      highlightColor: Colors.white.withOpacity(0.1),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return Colors.white;
        }
        return null;
      }),
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Icon(
                iconData,
                color: isSelected ? secondaryColor : secondaryColorSubtitle,
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? secondaryColor : secondaryColorSubtitle,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
