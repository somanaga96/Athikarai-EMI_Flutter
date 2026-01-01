import 'package:flutter/material.dart';
import 'screens/emi_home.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
  runApp(const EmiApp());
}

class EmiApp extends StatelessWidget {
  const EmiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const EmiHome(),
    );
  }
}
