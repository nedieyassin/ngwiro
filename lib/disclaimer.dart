import 'package:flutter/material.dart';
import 'package:ngwiro/service/data_store.dart';

class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({Key? key}) : super(key: key);

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  // final DataStore store = DataStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text('Disclaimer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'Ngwiro app is mainly meant to be used in conjunction with ongoing treatment by a qualified professional. The app is not a replacement for qualified mental health treatment. And Like all forms of online information, the content and quality of this app may change overtime due to availability of new and improved information. It is the primary responsibility of the user to use their individual judgment and to consult their health care professional to ensure that the app is appropriate for their treatment.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Theme.of(context).primaryColor),
                  foregroundColor: MaterialStatePropertyAll(
                      Theme.of(context).primaryColorLight),
                ),
                onPressed: () {
                  // store.acceptDisclaimer().then((r) {
                    Navigator.of(context).pushReplacementNamed('/');
                  // });
                },
                child: const Text('Accept and continue'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
