import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  OpenAIService() {
    final apiKey = dotenv.env['CHAT_GPT_API_KEY'];
    print('--- apiKey: $apiKey');
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("CHAT_GPT_API_KEY is missing in .env file");
    }
    OpenAI.apiKey = apiKey;
  }

  /// Generate both summary & category for a Todo
  Future<Map<String, String>> generateTodoDetails(String taskText) async {
    final response = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text("""
Summarize and categorize this task: "$taskText"

Return strictly in JSON:
{
  "summary": "short title (max 6 words)",
  "category": "Work | Personal | Urgent | Shopping | Learning | Health | Other"
}
"""),
          ],
        ),
      ],
    );

    final raw = response.choices.first.message.content?.first.text ?? "{}";

    String summary = taskText;
    String category = "Other";

    try {
      // Remove markdown wrappers if AI adds them
      final cleaned = raw
          .replaceAll("```json", "")
          .replaceAll("```", "")
          .trim();

      final parsed = json.decode(cleaned);

      summary = parsed["summary"] ?? summary;
      category = parsed["category"] ?? category;
    } catch (e) {
      print("⚠️ AI parsing failed, fallback used: $e");
    }

    return {"summary": summary, "category": category};
  }
}
