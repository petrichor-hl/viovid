import 'package:dart_openai/dart_openai.dart';
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

class Message {
  String content;
  bool isUserMessage;

  Message({
    required this.content,
    required this.isUserMessage,
  });
}

class _ChatBotDialogState extends State<ChatBotDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];

  void handleSubmitMessage() async {
    final message = _controller.text;
    _controller.clear(); // Xóa nội dung trong TextField
    _focusNode.requestFocus(); // Giữ focus trên TextField
    if (message.isEmpty) {
      return;
    }

    setState(() {
      _messages.addAll([
        Message(content: message, isUserMessage: true),
        Message(content: '🤖 đang trả lời ...', isUserMessage: false),
      ]);
    });

    // Cuộn xuống cuối SAU khi thêm item
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
        // OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(
        //   "https://placehold.co/600x400",
        // ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      responseFormat: {"type": "text"},
      messages: [userMessage],
      temperature: 1,
    );

    /*
    Reponse Format Ex:
    OpenAIChatCompletionModel(
      id: chatcmpl-APA8dvfifgIqrXrhGKcU4EXbW7AYi, 
      created: 2024-11-02 22:15:35.000, 
      choices: [
        OpenAIChatCompletionChoiceModel(
          index: 0, 
          message: OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.assistant, 
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel(
                type: text, 
                text: Hello! How can I assist you today?
              )
            ],
          ), 
          finishReason: stop
        )
      ],
      usage: OpenAIChatCompletionUsageModel(
        promptTokens: 11,
        completionTokens: 9, 
        totalTokens: 20,
      ), 
      systemFingerprint: fp_9b78b61c52,
    )
    */
    // print(chatCompletion.choices.first.message.content?.first.text);
    final reponseMessage = chatCompletion.choices.first.message.content?.first.text;
    setState(() {
      _messages.removeLast();
      _messages.add(Message(content: reponseMessage!, isUserMessage: false));
    });

    // Cuộn xuống cuối SAU khi thêm item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
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
                        child: Container(
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(12),
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
                    controller: _controller,
                    focusNode: _focusNode,
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
                    onSubmitted: (_) => handleSubmitMessage(),
                  ),
                ),
                const Gap(8),
                IconButton.filled(
                  onPressed: handleSubmitMessage,
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
