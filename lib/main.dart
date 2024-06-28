import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Greeter ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Greeter'),
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
  final TextEditingController _controller = TextEditingController();
  late Future<String> greeting = Future(() => "Who are you?");

  void _updateName(String newValue) {
    setState(() {
      if (newValue.isEmpty) {
        greeting = Future(() => "Who are you?");
      }
    });
  }

  void _submitName(String value) {
    setState(() {
      greeting = fetchGreeting();
    });
  }

  Future<String> fetchGreeting() async {
    final response = await http.get(
      Uri.parse(
        'https://greeter-api-47e2p4x5ta-an.a.run.app/hello?name=${_controller.text}',
      ),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load greeting');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: greeting,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    snapshot.data.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
                onChanged: (newValue) {
                  _updateName(newValue);
                },
                onSubmitted: (value) {
                  _submitName(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
