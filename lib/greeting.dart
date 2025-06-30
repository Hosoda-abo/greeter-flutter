final class Greeting {
  final String message;

  const Greeting({
    required this.message,
  });

  factory Greeting.fromJson(Map<String, dynamic> json) {
    return Greeting(
      message: json['message'] as String, //デコードされたのをGreetingに入れる
    );
  }
}
