import 'package:flutter/material.dart';

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
      highlightColor: const Color(0xFF695CFE),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFF695CFE).withOpacity(0.3);
        }
        return null;
      }),
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF695CFE) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Icon(
                iconData,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
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
