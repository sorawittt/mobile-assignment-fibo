import 'package:fibo/ui/fibo/fibo_view.dart';
import 'package:flutter/material.dart';

class FiboApp extends StatelessWidget {
  const FiboApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fibo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FiboView(),
    );
  }
}
