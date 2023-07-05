import 'package:flutter/material.dart';
import 'package:ngwiro/service/data_store.dart';
import 'package:ngwiro/service/supabase_api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../map.dart';

class TestResultsScreen extends StatefulWidget {
  const TestResultsScreen({Key? key}) : super(key: key);

  @override
  State<TestResultsScreen> createState() => _TestResultsScreenState();
}

class _TestResultsScreenState extends State<TestResultsScreen> {
  DataStore store = DataStore();
  Map? scoreScale;
  Color scoreColor = Colors.green.shade500;

  getScoreScale(int score) async {
    if (score >= 9) {
      setState(() {
        scoreColor = Colors.orange;
      });
    }
    if (score >= 15) {
      setState(() {
        scoreColor = Colors.red;
      });
    }

    if (scoreScale != null) return;
    List scales = await store.getScoreScales();
    Map scale = scales
        .where(
          (e) => e['from'] <= score && score <= e['to'],
        )
        .first;

    setState(() {
      scoreScale = scale;
    });
    try {
      SupabaseApi().addResponse({
        'score': score,
        'score_scale': scale['id'],
        'age_group': store.getUserAge(),
        'gender': store.getUserGender(),
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    int? score = arguments['result'];
    getScoreScale(score ?? 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Results'),
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: ColoredBox(
                      color: scoreColor,
                      child: Center(
                        child: Text(
                          '$score',
                          style: const TextStyle(
                              fontSize: 84,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Text('based on your test responses you might have a'),
            scoreScale != null
                ? Text(
                    '${scoreScale!['text'] ?? ''}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: scoreColor,
                    ),
                  )
                : const Text(''),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('FINISH AND CLOSE')),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'WHERE TO GET HELP!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            FutureBuilder(
                future: store.getHealthCenters(),
                builder: (context, snap) {
                  if (snap.hasData) {
                    return Column(
                      children: ((snap.data ?? []) as List)
                          .map((hc) => ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CenterMap()),
                                  );
                                },
                                title: Text(hc['name']),
                                subtitle: Text(
                                    '${hc['district']['name']} - ${hc['phone_number']}'),
                                trailing: IconButton(
                                  onPressed: () {
                                    launchUrl(
                                        Uri.parse('tel:${hc['phone_number']}'));
                                  },
                                  icon: Icon(
                                    Icons.call,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  }

                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text('No data available'),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
