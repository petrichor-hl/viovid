import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:viovid/base/common_variables.dart';

class ChatBotDialog extends StatefulWidget {
  const ChatBotDialog({
    super.key,
    required this.minimizeDialog,
  });

  final void Function() minimizeDialog;

  @override
  State<ChatBotDialog> createState() => _ChatBotDialogState();
}

class _ChatBotDialogState extends State<ChatBotDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 440,
      height: 650,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF212121),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'VioVid Bot',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => widget.minimizeDialog(),
                  icon: const Icon(Icons.minimize_rounded),
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              ],
            ),
            const Spacer(),
            Row(
              children: [
                IconButton.filled(
                  onPressed: () {},
                  icon: const Icon(Icons.image_outlined),
                  style: IconButton.styleFrom(
                    fixedSize: const Size(50, 50),
                    foregroundColor: Colors.white.withOpacity(0.7),
                    backgroundColor: const Color(0xFF3F3F3F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF3F3F3F),
                      hintText: 'Tin nhắn ...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      border: MaterialStateOutlineInputBorder.resolveWith(
                        (states) {
                          if (states.contains(WidgetState.focused)) {
                            return const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              borderSide: BorderSide(color: Colors.amber, width: 2),
                            );
                          } else if (states.contains(WidgetState.hovered)) {
                            return const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              borderSide: BorderSide(color: Colors.amber, width: 1),
                            );
                          }
                          return const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(color: Colors.transparent),
                          );
                        },
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(14, 17, 14, 17),
                    ),
                  ),
                ),
                const Gap(8),
                IconButton.filled(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_upward_rounded),
                  style: IconButton.styleFrom(
                    fixedSize: const Size(50, 50),
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              ],
            ),
            const Gap(8),
          ],
        ),
      ),
    );
  }
}
