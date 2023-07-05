import 'package:flutter/material.dart';
import 'package:ngwiro/service/data_store.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  DataStore store = DataStore();
  List? genderList = [];
  List? ageList = [];

  int? gender;
  int? age;

  initData() {
    store.getGenders().then((value) {
      setState(() {
        genderList = value;
      });
    });

    store.getAgeGroups().then((value) {
      setState(() {
        ageList = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Config User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Your Identity will be anonymous and will not be shared with anyone, share your gender, age group, and your test responses. Only to be used in survey.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 19),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text('Select Gender'),
            DropdownButton<int>(
              isExpanded: true,
              value: gender,
              items: genderList!
                  .map((e) => DropdownMenuItem(
                        child: Text(e['name']),
                        value: e['id'] as int,
                      ))
                  .toList(),
              onChanged: (int? value) {
                setState(() {
                  gender = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Select Age Group'),
            DropdownButton<int>(
              isExpanded: true,
              value: age,
              items: ageList!
                  .map((e) => DropdownMenuItem(
                        child: Text(e['group']),
                        value: e['id'] as int,
                      ))
                  .toList(),
              onChanged: (int? value) {
                setState(() {
                  age = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Theme.of(context).primaryColor),
                foregroundColor: MaterialStatePropertyAll(
                    Theme.of(context).primaryColorLight),
              ),
              onPressed: () {
                if (age != null && gender != null) {
                  store.userAge(age!);
                  store.userGender(gender!);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
