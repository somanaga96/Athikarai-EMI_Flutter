import 'package:flutter/material.dart';
import 'component/appbar/header.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/': (context) => const Header(),
      },
    ));
