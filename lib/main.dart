import 'package:bsru_firestoree/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  void _addCountry() async {
    await FirebaseFirestore.instance.collection('country').add({
      "name": "กรีซ",
      "enName": "Greece",
      "alpha2": "GR",
      "image": 'https://flagcdn.com/w320/gr.png',
    });
  }

  void _addMultiCountry() async {
    var country = [
      {
        "name": "กรีซ",
        "enName": "Greece",
        "alpha2": "GR",
        "alpha3": "GRC",
        "numeric": "300",
        "iso3166_2": "ISO 3166-2:GR",
      },
      {
        "name": "กรีนแลนด์",
        "enName": "Greenland",
        "alpha2": "GL",
        "alpha3": "GRL",
        "numeric": "304",
        "iso3166_2": "ISO 3166-2:GL",
      },
      {
        "name": "กวม",
        "enName": "Guam",
        "alpha2": "GU",
        "alpha3": "GUM",
        "numeric": "316",
        "iso3166_2": "ISO 3166-2:GU",
      },
      {
        "name": "กัมพูชา",
        "enName": "Cambodia",
        "alpha2": "KH",
        "alpha3": "KHM",
        "numeric": "116",
        "iso3166_2": "ISO 3166-2:KH",
      },
      {
        "name": "กัวเดอลุป",
        "enName": "Guadeloupe",
        "alpha2": "GP",
        "alpha3": "GLP",
        "numeric": "312",
        "iso3166_2": "ISO 3166-2:GP",
      },
    ];

    for (int i = 0; i < country.length; i++) {
      await FirebaseFirestore.instance.collection('country').add({
        "name": country[i]['name'],
        "enName": country[i]['enName'],
        "alpha2": country[i]['alpha2'],
        "image":
            'https://flagcdn.com/w320/${(country[i]['alpha2'] ?? '').toLowerCase()}.png',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('country').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Image.network(
                        (snapshot.data?.docs ?? [])[index]['image'],
                      ),
                      Text(
                        (snapshot.data?.docs ?? [])[index]['name'],
                        style: TextStyle(fontSize: 48),
                      ),
                      Text(
                        (snapshot.data?.docs ?? [])[index]['enName'],
                        style: TextStyle(fontSize: 48),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 8);
              },
              itemCount: (snapshot.data?.docs ?? []).length,
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMultiCountry,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
