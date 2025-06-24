import 'dart:convert';
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

  void _onNameChanged() {
    setState(() {
      if (_controller.text.isEmpty) {
        greeting = Future(() => "Who are you?");
      }
    });
  }

  void _onSubmitButtonTapped() {
    setState(() {
      if (_controller.text.isEmpty) {
        greeting = Future(() => "Who are you?");
        return;
      }
      greeting = fetchGreeting();
    });
  }

  Future<String> fetchGreeting() async {
    final response = await http.get(
      Uri.parse(
        'https://greeter-api.vercel.app/hello?name=${_controller.text}',
      ),
    );

    if (response.statusCode == 200) {
      final greeting = Greeting.fromJson(jsonDecode(response.body));
      return greeting.message;
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
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text('Who are you?');
                  case ConnectionState.active:
                    return const Text('Who are you?');
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      return Text(
                        snapshot.data.toString(),
                        style: Theme.of(context).textTheme.headlineMedium,
                      );
                    } else {
                      return const Text('Who are you?');
                    }
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
                onChanged: (_) => _onNameChanged(),
                onSubmitted: (_) => _onSubmitButtonTapped(),
                textCapitalization: TextCapitalization.words,
              ),
            ),
            ElevatedButton(
              onPressed: () => _onSubmitButtonTapped(),
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}

final class Greeting {
  final String message;

  const Greeting({
    required this.message,
  });

  factory Greeting.fromJson(Map<String, dynamic> json) {
    return Greeting(
      message: json['message'] as String,
    );
  }
}
