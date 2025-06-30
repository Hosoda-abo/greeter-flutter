import 'package:flutter/material.dart';
import 'package:greeter/fetchgreeting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
//ヘッダー
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
  late Future<String> greeting =
      Future(() => "Who are you?"); //初期値として Who are you?を設定

//入力された名前を全部消したら
  void _onNameChanged() {
    setState(() {
      if (_controller.text.isEmpty) {
        greeting = Future(() => "zenbukesitara");
      }
    });
  }

//ボタンを押した時に空白だった時に返す
  void _onSubmitButtonTapped() {
    setState(() {
      if (_controller.text.isEmpty) {
        greeting = Future(() => "kuuhaku");
        return;
      }
      greeting = fetchGreeting(_controller);
    });
  }

//UI的部分
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
                  case ConnectionState.waiting: //APIからの応答を待っている時に表示する
                    return const CircularProgressIndicator();
                  case ConnectionState.done: //APIからの応答が返ってきた
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      //greetingの値がある時
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
