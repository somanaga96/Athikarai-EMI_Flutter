import 'package:flutter/material.dart';

import '../ui/home_screen.dart';

void main() => runApp(const Header());

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  static const String _title = 'EMI';

  @override
  State<Header> createState() => _HeaderState();
}

bool _iconBool = true;
IconData _iconLight = Icons.wb_sunny;
IconData _iconDark = Icons.dark_mode_rounded;

ThemeData _lightTheme =
    ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light);

ThemeData _darkTheme =
    ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark);

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyStatelessWidget(),
    );
  }
}

class MyStatelessWidget extends StatefulWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  State<MyStatelessWidget> createState() => _MyStatelessWidgetState();
}

class _MyStatelessWidgetState extends State<MyStatelessWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Athikarai EMI")),
        ),
        body: const Input());
  }
}
