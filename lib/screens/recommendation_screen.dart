// lib/screens/recommendation_screen.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_try_on/main.dart'; // Импортируем AppState через пакет
import '../services/segmind_api.dart';

class RecommendationScreen extends StatefulWidget {
  final AppState state;

  const RecommendationScreen({Key? key, required this.state}) : super(key: key);

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  Uint8List? _tryOnResult;
  String? _logs;

  // Укажите здесь свой Segmind API-ключ
  final String segmindApiKey = 'YOUR_SEGMIND_API_KEY';

  // Список одежды: название + URL картинки в Cloudinary
  final List<Map<String, String>> clothes = [
    {
      'name': 'Зелёная футболка',
      'url': 'https://res.cloudinary.com/dm0mxuyzo/image/upload/v1748322942/shirt1_gqzgve.png'
    },
    // Можно добавить больше пунктов
  ];

  String? _selectedClothingUrl;

  @override
  void initState() {
    super.initState();
    _selectedClothingUrl = clothes.first['url']; // по умолчанию
  }

  Future<void> _runTryOn() async {
    final userFile = widget.state.userPhoto;
    final clothingUrl = _selectedClothingUrl;
    if (userFile == null || clothingUrl == null) {
      setState(() {
        _logs = 'Фото или одежда не выбраны';
      });
      return;
    }

    setState(() {
      _logs = 'Загрузка изображения одежды...';
      _tryOnResult = null;
    });

    // 1. Скачать PNG с Cloudinary
    final clothingResponse = await http.get(Uri.parse(clothingUrl));
    if (clothingResponse.statusCode != 200) {
      setState(() {
        _logs = 'Ошибка загрузки одежды с Cloudinary';
      });
      return;
    }
    final clothingBase64 = base64Encode(clothingResponse.bodyBytes);

    // 2. Прочитать фото пользователя
    final userBytes = await userFile.readAsBytes();
    final userBase64 = base64Encode(userBytes);

    setState(() {
      _logs = 'Отправка данных в Segmind TryOnDiffusion...';
    });

    // 3. Вызов Segmind API
    final result = await callTryOnDiffusion(
      userBase64: userBase64,
      clothingBase64: clothingBase64,
      apiKey: segmindApiKey,
    );

    if (result != null) {
      setState(() {
        _tryOnResult = result;
        _logs = 'Готово!';
      });
    } else {
      setState(() {
        _logs = 'Ошибка от сервера Segmind';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результаты примерки'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Изменить стиль',
            onPressed: () {
              // Два pop — возвращаемся на StyleSelectionScreen
              Navigator.pop(context); // RecommendationScreen → PhotoScreen
              Navigator.pop(context); // PhotoScreen → StyleSelectionScreen
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              'Выбран стиль: ${widget.state.selectedStyle ?? 'Не выбран'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Список одежды
            Text('Выберите одежду для примерки:', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: clothes.length,
                itemBuilder: (context, index) {
                  final item = clothes[index];
                  final isSelected = item['url'] == _selectedClothingUrl;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedClothingUrl = item['url'];
                        _tryOnResult = null;
                        _logs = null;
                      });
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey,
                          width: isSelected ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Image.network(item['url']!, height: 60),
                          const SizedBox(height: 5),
                          Text(
                            item['name']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _runTryOn,
              child: const Text('Запустить примерку'),
            ),
            const SizedBox(height: 16),

            // Результат примерки
            if (_tryOnResult != null)
              Expanded(child: Image.memory(_tryOnResult!))
            else if (_logs != null)
              Text(_logs!),
          ],
        ),
      ),
    );
  }
}



