import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ArticlePage(
                  title: title,
                  body: body,
                )));
      },
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
            height: 160,
            width: 160,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            )),
      ),
    );
  }
}

class ArticlePage extends StatelessWidget {
  const ArticlePage({Key? key, required this.title, required this.body})
      : super(key: key);

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(body),
          ),
        ),
      ),
    );
  }
}
