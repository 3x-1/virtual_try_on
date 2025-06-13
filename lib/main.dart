import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/style_selection_screen.dart';
import 'screens/photo_screen.dart';
import 'screens/recommendation_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Класс, который хранит состояние приложения
class AppState {
  String? selectedStyle;
  File? userPhoto;
  Uint8List? resultImage;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppState state = AppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Try-On App',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Оборачиваем WelcomeScreen в Builder,
      // чтобы onNext вызывался уже с "правильным" context
      home: Builder(
        builder: (innerContext) => WelcomeScreen(
          onNext: () => _goToAuth(innerContext),
        ),
      ),
    );
  }

  void _goToAuth(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AuthScreen(
          onAuthenticated: () => _goToStyleSelection(context),
        ),
      ),
    );
  }

  void _goToStyleSelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StyleSelectionScreen(
          onStyleSelected: (style) {
            state.selectedStyle = style;
            _goToPhotoScreen(context);
          },
        ),
      ),
    );
  }

  void _goToPhotoScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoScreen(
          onPhotoTaken: (file) {
            state.userPhoto = file;
            _goToRecommendation(context);
          },
        ),
      ),
    );
  }

  void _goToRecommendation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecommendationScreen(state: state),
      ),
    );
  }
}

