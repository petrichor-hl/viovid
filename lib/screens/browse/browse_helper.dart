// import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viovid/data/dynamic/profile_data.dart';
import 'package:viovid/main.dart';
import 'package:viovid/models/message.dart';

// Future<String> convertImageToBase64(XFile image) async {
//   final bytes = await image.readAsBytes();
//   String base64Image = base64Encode(bytes);
//   return "data:${image.mimeType};base64,$base64Image";
// }

Future<String?> uploadFileToStorage(XFile image) async {
  final dio = Dio();
  // Tạo formData
  final formData = FormData.fromMap({
    'purpose': 'vision',
    'file': MultipartFile.fromBytes(await image.readAsBytes(),
        filename: image.name),
  });

  try {
    // Gửi yêu cầu
    final response = await dio.post(
      'https://api.openai.com/v1/files',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $openAIApiKey',
        },
      ),
    );

    print('Upload file successful.');
    print('Response: ${response.data}');
    return response.data['id'];
  } catch (e) {
    print('Upload file failed: $e');
    return null;
  }
}

Future<Uint8List?> getFileFromStorage(String fileId) async {
  final dio = Dio();
  // Tạo formData
  try {
    final response = await dio.get(
      'https://api.openai.com/v1/files/$fileId/content',
      options: Options(
        headers: {
          'Authorization': 'Bearer $openAIApiKey',
        },
        // Nếu bạn muốn tải file binary, thêm responseType này:
        responseType: ResponseType.bytes,
      ),
    );

    print("File tải về thành công!");
    return response.data;
  } catch (e) {
    print('Lỗi khi tải file: $e');
    return null;
  }
}

Future<String?> createThread() async {
  final dio = Dio();
  // Tạo formData
  try {
    final response = await dio.post(
      'https://api.openai.com/v1/threads',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIApiKey',
          'OpenAI-Beta': 'assistants=v2',
        },
      ),
    );

    print("CREATE Thread successful. ✅");
    print('Response: ${response.data}');
    return response.data['id'];
  } catch (e) {
    print('ERROR: CREATE Thread failed: ❌\n$e');
    return null;
  }
}

Future<bool> deleteThread() async {
  final dio = Dio();
  // Tạo formData
  try {
    final response = await dio.delete(
      'https://api.openai.com/v1/threads/${profileData['thread_id']}',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIApiKey',
          'OpenAI-Beta': 'assistants=v2',
        },
      ),
    );

    print("DELETE Thread successful. ✅");
    print('Response: ${response.data}');
    return response.data['deleted'];
  } catch (e) {
    print('ERROR: DELETE Thread failed. ❌\n$e');
    return false;
  }
}

Future<List<Message>?> getThreadMessages() async {
  final dio = Dio();
  // Tạo formData
  try {
    final response = await dio.get(
      'https://api.openai.com/v1/threads/${profileData['thread_id']}/messages',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIApiKey',
          'OpenAI-Beta': 'assistants=v2',
        },
      ),
    );

    // print('Response ${response.data}');
    Iterable<dynamic> listItem = (response.data['data'] as List).reversed;
    final List<Message> messages = [];

    for (final messageObj in listItem) {
      List<dynamic> contents = messageObj['content'];
      bool isUserMessage = messageObj['role'] == 'user';
      for (final content in contents) {
        if (content['type'] == 'text') {
          messages.add(
            Message(
              content: content['text']['value'],
              isUserMessage: isUserMessage,
              type: MessageType.text,
            ),
          );
        } else if (content['type'] == 'image_file') {
          final fileId = content['image_file']['file_id'];
          Uint8List? imageBytes = await getFileFromStorage(fileId);
          messages.add(
            Message(
              content: imageBytes,
              isUserMessage: isUserMessage,
              type: MessageType.image,
            ),
          );
        }
      }
    }
    print("GET Thread Messages successful. ✅");
    return messages;
  } catch (e) {
    print('ERROR: GET Thread Messages failed. ❌\n$e');
    return null;
  }
}

Future<Message?> getLastThreadMessages() async {
  final dio = Dio();
  // Tạo formData
  try {
    final response = await dio.get(
      'https://api.openai.com/v1/threads/${profileData['thread_id']}/messages',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIApiKey',
          'OpenAI-Beta': 'assistants=v2',
        },
      ),
    );

    // print('Response ${response.data}');
    final latestMessageObj = (response.data['data'] as List).first;

    print("GET LAST Thread Messages successful. ✅");
    return Message(
      content: latestMessageObj['content'][0]['text']['value'],
      isUserMessage: false,
      type: MessageType.text,
    );
  } catch (e) {
    print('ERROR: GET LAST Thread Messages failed. ❌\n$e');
    return null;
  }
}

Future<String?> addMessageToThread(String messageText, String? fileId) async {
  final dio = Dio();
  // Tạo formData
  try {
    final response = await dio.post(
      'https://api.openai.com/v1/threads/${profileData['thread_id']}/messages',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIApiKey',
          'OpenAI-Beta': 'assistants=v2',
        },
      ),
      data: {
        "role": "user",
        "content": [
          if (fileId != null)
            {
              "type": "image_file",
              "image_file": {
                "file_id": fileId,
              },
            },
          {
            "type": "text",
            "text": messageText,
          },
        ],
      },
    );

    print("ADD Message to Thread successful. ✅");
    return response.data['id'];
  } catch (e) {
    print('ERROR: ADD Message to Thread failed. ❌\n$e');
    return null;
  }
}

const viovidAssistantId = 'asst_XYzSdgaUiGMFv89iM41Bjm5H';
const terminalStates = [
  'expired',
  'completed',
  'failed',
  'incomplete',
  'cancelled'
];

Future<String?> createRun() async {
  final dio = Dio();
  Completer<void> completer = Completer();
  // Tạo formData
  try {
    final response = await dio.post(
      'https://api.openai.com/v1/threads/${profileData['thread_id']}/runs',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIApiKey',
          'OpenAI-Beta': 'assistants=v2',
        },
      ),
      data: {
        "assistant_id": viovidAssistantId,
      },
    );

    final runId = response.data['id'];
    print("CREATE Run successful - runId ${runId} ✅");
    print("Polling Run Object ... ⏰");

    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      checkRunStatus(runId).then((status) async {
        if (terminalStates.contains(status)) {
          print('Dừng theo dõi Run status');
          timer.cancel(); // Dừng vòng lặp

          if (!completer.isCompleted) {
            completer.complete();
          }
        }
      });
    });

    await completer.future;
    print("Done. ✅");
    return response.data['id'];
  } catch (e) {
    print('ERROR: CREATE Run failed. ❌\n$e');
    return null;
  }
}

Future<String> checkRunStatus(String runId) async {
  final dio = Dio();

  try {
    final response = await dio.get(
      'https://api.openai.com/v1/threads/${profileData['thread_id']}/runs/$runId',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIApiKey',
          'OpenAI-Beta': 'assistants=v2',
        },
      ),
    );
    // print("GET Run successful. ✅");
    print("runId ${response.data['id']} - status: ${response.data['status']}");
    return response.data['status'];
  } catch (e) {
    print('Error checking run status: $e');
    return 'failed';
  }
}
