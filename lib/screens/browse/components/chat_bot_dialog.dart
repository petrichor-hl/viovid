import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/models/message.dart';
import 'package:viovid/screens/browse/browse_helper.dart';

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
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isBotTyping = false;

  XFile? _selectedImage;

  void handleSubmitMessage() async {
    final message = _controller.text;
    _controller.clear(); // Xóa nội dung trong TextField

    if (message.isEmpty) {
      return;
    }

    String? base64Image;
    if (_selectedImage != null) {
      base64Image = await convertImageToBase64(_selectedImage!);
    }

    setState(() {
      _messages.addAll([
        if (_selectedImage != null) Message(content: _selectedImage!.path, isUserMessage: true, type: MessageType.image),
        Message(content: message, isUserMessage: true, type: MessageType.text),
        Message(content: '🤖 đang trả lời ...', isUserMessage: false, type: MessageType.text),
      ]);
      _isBotTyping = true;
      _selectedImage = null;
    });

    // // Cuộn xuống cuối SAU khi thêm item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });

    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          message,
        ),
        if (base64Image != null)
          OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(
            base64Image,
          ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      responseFormat: {"type": "text"},
      messages: [userMessage],
      temperature: 1,
    );

    final reponseMessage = chatCompletion.choices.first.message.content?.first.text;
    setState(() {
      _messages.removeLast();
      _messages.add(
        Message(content: reponseMessage!, isUserMessage: false, type: MessageType.text),
      );
      _isBotTyping = false;
    });

    // Cuộn xuống cuối và requestFocus sau khi lệnh setState phía trên được được render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus(); // Giữ focus trên TextField

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });

    /*
    Reponse Format Ex:
    OpenAIChatCompletionModel chatCompletion = OpenAIChatCompletionModel(
      id: 'chatcmpl-APA8dvfifgIqrXrhGKcU4EXbW7AYi',
      created: DateTime.now(),
      choices: [
        OpenAIChatCompletionChoiceModel(
            index: 0,
            message: OpenAIChatCompletionChoiceMessageModel(
              role: OpenAIChatMessageRole.assistant,
              content: [
                OpenAIChatCompletionChoiceMessageContentItemModel.text('Hello! How can I assist you today?'),
              ],
            ),
            finishReason: 'stop')
      ],
      usage: const OpenAIChatCompletionUsageModel(
        promptTokens: 11,
        completionTokens: 9,
        totalTokens: 20,
      ),
      systemFingerprint: 'fp_9b78b61c52',
    );
    */
  }

  @override
  void dispose() {
    // Giải phóng controller và focus node khi không còn dùng đến
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
                  'VioVid Bot 🤖',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
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
            const Gap(12),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    ..._messages.map(
                      (message) => Align(
                        alignment: message.isUserMessage ? Alignment.centerRight : Alignment.bottomLeft,
                        child: message.type == MessageType.text
                            ? Container(
                                constraints: const BoxConstraints(maxWidth: 350),
                                decoration: BoxDecoration(
                                  color: message.isUserMessage ? const Color(0xFF3F3F3F) : Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  message.content,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    message.content,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton.filled(
                  onPressed: _isBotTyping
                      ? null
                      : () async {
                          final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                          setState(() {
                            _selectedImage = pickedImage;
                          });
                        },
                  icon: const Icon(Icons.image_outlined),
                  style: IconButton.styleFrom(
                    fixedSize: const Size(50, 50),
                    foregroundColor: Colors.white.withOpacity(0.7),
                    backgroundColor: const Color(0xFF3F3F3F),
                    disabledForegroundColor: Colors.white.withOpacity(0.7),
                    disabledBackgroundColor: const Color(0xFF3F3F3F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF3F3F3F),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_selectedImage != null) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    _selectedImage!.path,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: -6,
                                  right: -6,
                                  child: IconButton(
                                    onPressed: () => setState(() {
                                      _selectedImage = null;
                                    }),
                                    icon: const Icon(Icons.clear_rounded),
                                    style: IconButton.styleFrom(
                                      iconSize: 20,
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.black54,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                        TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: const TextStyle(color: Colors.white),
                          enabled: !_isBotTyping,
                          decoration: InputDecoration(
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
                          onEditingComplete: handleSubmitMessage,
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(8),
                IconButton(
                  onPressed: _isBotTyping ? null : handleSubmitMessage,
                  // icon: const Icon(Icons.arrow_upward_rounded),
                  icon: const Icon(Icons.arrow_upward_rounded),
                  style: IconButton.styleFrom(
                    fixedSize: const Size(50, 50),
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    disabledForegroundColor: Colors.black,
                    disabledBackgroundColor: const Color(0xFF676767),
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
