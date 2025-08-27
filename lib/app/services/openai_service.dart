import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    final key = dotenv.env['GEMINI_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('GEMINI_API_KEY not found');
    }
    _model = GenerativeModel(
      model: 'gemini-pro', // or 'gemini-1.5-flash'
      apiKey: key,
    );
  }

  Future<String> generateSummaryAndCategory(String text) async {
    final response = await _model.generateContent([
      Content.text("""
Summarize this task in under 6 words and categorize it as Work, Personal, Urgent, Shopping, Learning, or Other in JSON format:
{"summary": "...", "category": "..."}
"""),
    ]);

    final raw = response.text;
    try {
      final cleaned = raw
          ?.replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      print("-----  cleaned: $cleaned");
      final json = Map<String, dynamic>.from(await jsonDecode(cleaned ?? "{}"));
      return json['summary'] + '|${json['category']}';
    } catch (error) {
      print("-----  _: $error");
      return '$text|Other';
    }
  }
}

// =============================================================
//  Flutter OpenAI Service
// =============================================================

// import 'dart:convert';
// import 'package:dart_openai/dart_openai.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class OpenAIService {
//   OpenAIService() {
//     final apiKey = dotenv.env['CHAT_GPT_API_KEY'];
//     print('--- apiKey: $apiKey');
//     if (apiKey == null || apiKey.isEmpty) {
//       throw Exception("CHAT_GPT_API_KEY is missing in .env file");
//     }
//     OpenAI.apiKey = apiKey;
//   }

//   /// Generate both summary & category for a Todo
//   Future<Map<String, String>> generateTodoDetails(String taskText) async {
//     final response = await OpenAI.instance.chat.create(
//       model: "gpt-4o-mini",
//       messages: [
//         OpenAIChatCompletionChoiceMessageModel(
//           role: OpenAIChatMessageRole.user,
//           content: [
//             OpenAIChatCompletionChoiceMessageContentItemModel.text("""
// Summarize and categorize this task: "$taskText"

// Return strictly in JSON:
// {
//   "summary": "short title (max 6 words)",
//   "category": "Work | Personal | Urgent | Shopping | Learning | Health | Other"
// }
// """),
//           ],
//         ),
//       ],
//     );

//     final raw = response.choices.first.message.content?.first.text ?? "{}";

//     String summary = taskText;
//     String category = "Other";

//     try {
//       // Remove markdown wrappers if AI adds them
//       final cleaned = raw
//           .replaceAll("```json", "")
//           .replaceAll("```", "")
//           .trim();

//       final parsed = json.decode(cleaned);

//       summary = parsed["summary"] ?? summary;
//       category = parsed["category"] ?? category;
//     } catch (e) {
//       print("⚠️ AI parsing failed, fallback used: $e");
//     }

//     return {"summary": summary, "category": category};
//   }
// }
