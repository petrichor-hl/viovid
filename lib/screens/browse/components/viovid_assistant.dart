import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viovid/base/assets.dart';
import 'package:viovid/base/common_variables.dart';
import 'package:viovid/data/dynamic/profile_data.dart';
import 'package:viovid/main.dart';
import 'package:viovid/models/message.dart';
import 'package:viovid/screens/browse/browse_helper.dart';

class ViovidAssistantDialog extends StatefulWidget {
  const ViovidAssistantDialog({
    super.key,
    required this.minimizeDialog,
  });

  final void Function() minimizeDialog;

  @override
  State<ViovidAssistantDialog> createState() => _ViovidAssistantDialogState();
}

class _ViovidAssistantDialogState extends State<ViovidAssistantDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  bool _isProcessing = false;
  bool _isClearingThread = false;

  XFile? _selectedImage;

  void getMessages() async {
    final messages = (await getThreadMessages()) ?? [];
    setState(() {
      _messages.addAll(messages);
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
  void initState() {
    super.initState();
    if (profileData['thread_id'] != null) {
      getMessages();
    }
  }

  void handleSubmitMessage() async {
    final message = _controller.text;
    if (message.isEmpty) {
      _focusNode.requestFocus();
      return;
    }
    _controller.clear(); // Xóa nội dung trong TextField

    setState(() {
      _isProcessing = true;
    });

    if (profileData['thread_id'] == null) {
      final threadId = await createThread();
      if (threadId != null) {
        setState(() {
          profileData['thread_id'] = threadId;
        });
        await supabase.from('profile').update(
          {
            'thread_id': threadId,
          },
        ).eq(
          'id',
          profileData['user_id'],
        );
      } else {
        // Show Thông báo tạo cuộc trò chuyện thất bại
      }
    }

    Uint8List? imageBytes;
    String? fileId;
    if (_selectedImage != null) {
      fileId = await uploadFileToStorage(_selectedImage!);
      if (fileId != null) {
        imageBytes = await getFileFromStorage(fileId);
      }
    }

    setState(() {
      _messages.addAll([
        if (imageBytes != null)
          Message(
            content: imageBytes,
            isUserMessage: true,
            type: MessageType.image,
          ),
        Message(
          content: message,
          isUserMessage: true,
          type: MessageType.text,
        ),
        Message(
          content: '🤖 đang trả lời ...',
          isUserMessage: false,
          type: MessageType.text,
        ),
      ]);
      _selectedImage = null;
    });

    // Cuộn xuống cuối SAU khi thêm item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });

    final messageId = await addMessageToThread(message, fileId);
    if (messageId != null) {
      final runId = await createRun();
      if (runId != null) {
        // Lấy ra message mới nhất
        final message = await getLastThreadMessages();
        if (message != null) {
          setState(() {
            _messages.removeLast();
            _messages.add(message);
          });
          _isProcessing = false;
        } else {
          setState(() {
            _messages.removeLast();
            _messages.add(
              Message(
                content:
                    'Có lỗi xảy ra trong khi tạo câu trả lời. :((\nVui lòng thử lại.',
                isUserMessage: false,
                type: MessageType.text,
              ),
            );
            _isProcessing = false;
          });
        }
      } else {
        setState(() {
          _messages.removeLast();
          _messages.add(
            Message(
              content:
                  'Có lỗi xảy ra trong khi tạo câu trả lời. :((\nVui lòng thử lại.',
              isUserMessage: false,
              type: MessageType.text,
            ),
          );
          _isProcessing = false;
        });
      }
    } else {
      setState(() {
        _messages.removeLast();
        _messages.add(
          Message(
            content:
                'Có lỗi xảy ra trong khi nhận tin nhắn từ bạn. :((\nVui lòng thử lại.',
            isUserMessage: false,
            type: MessageType.text,
          ),
        );
        _isProcessing = false;
      });
    }

    // Cuộn xuống cuối SAU khi thêm item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void clearChatHistory() async {
    setState(() {
      _isClearingThread = true;
    });
    final deleted = await deleteThread();
    if (deleted) {
      profileData['thread_id'] = null;
      await supabase.from('profile').update(
        {
          'thread_id': null,
        },
      ).eq(
        'id',
        profileData['user_id'],
      );
      setState(() {
        _isClearingThread = false;
        _messages.clear();
      });
    } else {
      // Show Message
    }
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
    bool isBlock = _isProcessing || _isClearingThread;

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
                  'VioVid Assistant 🤖',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                _isClearingThread
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white30,
                          strokeWidth: 3,
                        ),
                      )
                    : IconButton(
                        onPressed: clearChatHistory,
                        icon: const Icon(Icons.playlist_remove_rounded),
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                IconButton(
                  onPressed: () => widget.minimizeDialog(),
                  icon: const Icon(Icons.minimize_rounded),
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(12),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  controller: _scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: profileData['thread_id'] == null
                          ? constraints.maxHeight
                          : 0,
                    ),
                    child: Column(
                      mainAxisAlignment: profileData['thread_id'] == null
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      children: profileData['thread_id'] == null
                          ? [
                              Image.asset(
                                Assets.viovidAssistantBot,
                                height: 150,
                              ),
                              const Gap(16),
                              const Text(
                                'Bạn cần trợ giúp ư\nHãy trò chuyện với tôi nhé!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Gap(50),
                            ]
                          : [
                              ..._messages.map(
                                (message) => Align(
                                  alignment: message.isUserMessage
                                      ? Alignment.centerRight
                                      : Alignment.bottomLeft,
                                  child: message.type == MessageType.text
                                      ? Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 350),
                                          decoration: BoxDecoration(
                                            color: message.isUserMessage
                                                ? const Color(0xFF3F3F3F)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          margin:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Text(
                                            message.content,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: Image.memory(
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
                );
              }),
            ),
            const Gap(12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton.filled(
                  onPressed: isBlock
                      ? null
                      : () async {
                          final XFile? pickedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
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
                          enabled: !isBlock,
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
                                    borderSide: BorderSide(
                                        color: Colors.amber, width: 2),
                                  );
                                } else if (states
                                    .contains(WidgetState.hovered)) {
                                  return const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                        color: Colors.amber, width: 1),
                                  );
                                }
                                return const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                );
                              },
                            ),
                            contentPadding:
                                const EdgeInsets.fromLTRB(14, 17, 14, 17),
                          ),
                          onEditingComplete: handleSubmitMessage,
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(8),
                IconButton(
                  onPressed: isBlock ? null : handleSubmitMessage,
                  // icon: const Icon(Icons.arrow_upward_rounded),
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.arrow_upward_rounded),
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
