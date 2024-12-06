import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Fish/FishLinking.dart'; // Update the file path
import 'Fish/fish_home_screen.dart'; // Update the file path

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => FishController(), // Updated controller name
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Fish App', // Updated app title
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomeScreen(), // Updated home screen
        ));
  }
}
