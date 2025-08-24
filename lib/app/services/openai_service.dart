import 'package:dart_openai/dart_openai.dart';

class OpenAIService {
  OpenAIService(String apiKey) {
    OpenAI.apiKey = apiKey;
  }

  // Generate a smart summary of a TODO
  Future<String> summarizeTask(String taskText) async {
    final response = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini", // or gpt-4o
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              "Summarize this task into a short TODO: $taskText",
            ),
          ],
        ),
      ],
    );

    return response.choices.first.message.content?.first.text ?? taskText;
  }

  // Categorize task (Work, Personal, Urgent, etc.)
  Future<String> categorizeTask(String taskText) async {
    final response = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              "Categorize this task briefly: $taskText",
            ),
          ],
        ),
      ],
    );

    return response.choices.first.message.content?.first.text ?? "General";
  }
}
