import 'package:flutter/material.dart';
import 'package:vocabulary_app/service/word_service.dart';
import 'package:vocabulary_app/widgets/word_container.dart';

import 'model/Word.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Word'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WordService wordService;
  late Future<Word?> word;

  @override
  void initState() {
    super.initState();
    wordService = WordService();
    word = wordService.fetchData("vocabulary");
  }

  Future<void> fetchDue(String wrd) async {
    Future<Word?> temp = wordService.fetchData(wrd);
    setState(() {
      word = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(),
        elevation: 10,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.wordpress),
            SizedBox(
              width: 10,
            ),
            Text("AF Vocabulary")
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.search),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      hintText: "Search for desired word",
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        fetchDue(text);
                      } else {
                        fetchDue("vocabulary");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: word,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                      SizedBox(
                        height: 200,
                      ),
                      Text(
                        "Unfortunately, there is no such word in our database 😑",
                        style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),
                      ),
                                        ],
                                      ),
                    ));
              } else if (snapshot.hasData) {
                return WordContainer(
                  word: snapshot.data!.word,
                  text: snapshot.data!.text,
                  partOf: snapshot.data!.partOf,
                  definition: snapshot.data!.definitions,
                  audio: snapshot.data!.audio,
                );
              } else {
                return Center(
                  child: Text("No data available"),
                );
              }
            },
          ),
        ]),
      ),
    );
  }
}
