import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ngwiro/home.dart';
import 'package:ngwiro/service/data_store.dart';
import 'package:ngwiro/test/results.dart';
import 'package:ngwiro/test/test.dart';
import 'package:ngwiro/user_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'disclaimer.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://sdhnuybbtegesctjqpdx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNkaG51eWJidGVnZXNjdGpxcGR4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzUzMzQyMDQsImV4cCI6MTk5MDkxMDIwNH0.Okiwo2_kf7PNxuZ9ooSM1Pwp5V6-Q_g8_oTsFEbIYNk',
  );
  await Hive.initFlutter();
  await Hive.openBox('dataCache');
  await Hive.openBox('stateCache');
  runApp(const Ngwiro());
}

class Ngwiro extends StatefulWidget {
  const Ngwiro({super.key});

  @override
  State<Ngwiro> createState() => _NgwiroState();
}

class _NgwiroState extends State<Ngwiro> {
  DataStore store = DataStore();

  @override
  void initState() {
    super.initState();
    store.clearAllCache();
    store.updateAllCache();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ngwiro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/disclaimer': (context) => const DisclaimerScreen(),
        '/user_data': (context) => const UserDataScreen(),
        '/test': (context) => const TestScreen(),
        '/results': (context) => const TestResultsScreen(),
      },
    );
  }
}
