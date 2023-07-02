import 'package:flutter/material.dart';
import 'package:ngwiro/components/cards.dart';
import 'package:ngwiro/service/data_store.dart';

import 'map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DataStore store = DataStore();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: const SizedBox(),
              expandedHeight: 150.0,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text(
                  'Ngwiro',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              floating: true,
              pinned: true,
              snap: true,
              // elevation: 2,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/disclaimer');
                    },
                    icon: const Icon(Icons.info_outline_rounded)),
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Card(
                  elevation: 0,
                  // color: Theme.of(context).colorScheme.surfaceVariant,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(12)),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, left: 8, right: 8),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: ColoredBox(
                                color: Theme.of(context).primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.adjust_rounded,
                                    size: 18,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Take a test',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Text(
                            'Take a test that will help you identify what you are feeling and possibly help you find help.'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                    Theme.of(context).primaryColor,
                                  ),
                                  foregroundColor: MaterialStatePropertyAll(
                                    Theme.of(context).primaryColorLight,
                                  ),
                                  elevation: const MaterialStatePropertyAll(0)),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/test');
                                // store.getQuestions();
                              },
                              child: const Text('START TEST'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child: Text(
                        'Quick Knowledge',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FutureBuilder(
                          future: store.getArticles(),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return Row(
                                children: ((snap.data ?? []) as List)
                                    .map((art) => ArticleCard(
                                          title: art['title'],
                                          body: art['body'],
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
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child: Text(
                        'Where to get help',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                                            MaterialPageRoute(builder: (context) => const CenterMap()),
                                          );
                                        },
                                        title: Text(hc['name']),
                                        subtitle: Text(
                                            '${hc['district']['name']} - ${hc['phone_number']}'),
                                        trailing: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.call,
                                            color:
                                                Theme.of(context).primaryColor,
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
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
