import 'package:flutter/material.dart';
import 'my_home_page.dart';
import 'send_email.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => MyHomePage(
              title: 'Inicio - Leng. de Prog. IV',
              storage: EstudiantesStorage(),
            ),
        '/SendEmail': (context) => SendEmail(
              title: 'Enviar Email - Leng. de Prog. IV',
              storage: EstudiantesStorage2(),
            ),
      },
    );
  }
}
