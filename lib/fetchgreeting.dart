//ボタンを押した時に入力された名前をAPIに送信して返ってきた値を表示する
import 'dart:convert';

import 'package:greeter/greeting.dart';
import 'package:http/http.dart' as http;

Future<String> fetchGreeting(dynamic controller) async {
  final response = await http.get(
    Uri.parse(
      'https://greeter-api.vercel.app/hello?name=${controller.text}',
    ),
  );

  if (response.statusCode == 200) {
    //リクエストが成功し、サーバーが要求された情報を正常に送信した場合
    final greeting = Greeting.fromJson(jsonDecode(response.body)); //JSONをデコードする
    return greeting.message; //デコードされた値を返す
  } else {
    throw Exception('Failed to load greeting');
  }
}
