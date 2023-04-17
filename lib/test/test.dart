import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

import '../service/data_store.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  DataStore store = DataStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getSurveyTask(store),
          builder: (context, snap) {
            if (snap.hasData && snap.data != null) {
              return SurveyKit(
                task: snap.data!,
                onResult: (SurveyResult result) {
                  if (result.finishReason == FinishReason.COMPLETED) {
                    var res = result.results
                        .map((ans) => int.tryParse(
                            ans.results.first.valueIdentifier ?? ''))
                        .toList();
                    int? resultInt =
                        res.where((el) => el != null).reduce((a, b) => a! + b!);
                    Navigator.of(context).pushReplacementNamed(
                      '/results',
                      arguments: {'result': resultInt!},
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                themeData: Theme.of(context).copyWith(
                  textTheme: const TextTheme(
                    displayMedium: TextStyle(
                      fontSize: 38.0,
                      color: Colors.black,
                    ),
                    headlineSmall: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                    ),
                    bodyMedium: TextStyle(
                      fontSize: 22.0,
                      color: Colors.black,
                    ),
                    titleMedium: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator.adaptive());
          }),
    );
  }

  Future<Task> getSurveyTask(DataStore store) async {
    List ls = await store.getQuestions();
    List ao = await store.getAnswerOptions();

    NavigableTask task = NavigableTask(
      id: TaskIdentifier(),
      steps: [
        InstructionStep(
          title: 'Welcome to Ngwiro Test',
          text:
              'Get ready to answer some questions that will help identifying what you are feeling and possibly help you find help!',
          buttonText: 'Let\'s go!',
        ),
        InstructionStep(
          title: 'Instructions',
          text:
              'You should answer based how often have you been bothered by any of the following problems over the last 2 weeks.',
          buttonText: 'Start Test',
        ),
        ...ls
            .map((q) => QuestionStep(
                  text: '${q['number']}. ${q['question']}',
                  isOptional: false,
                  answerFormat: SingleChoiceAnswerFormat(
                      textChoices: ao
                          .map((a) => TextChoice(
                                text: '${a['text']}',
                                value: '${a['value']}',
                              ))
                          .toList()),
                ))
            .toList(),
        CompletionStep(
          stepIdentifier: StepIdentifier(id: '321'),
          assetPath: '',
          text: 'Thanks for taking the test!',
          title: 'Done!',
          buttonText: 'Submit test for analysis',
        ),
      ],
    );
    return Future.value(task);
  }
}
