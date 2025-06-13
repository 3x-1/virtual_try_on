// lib/screens/photo_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoScreen extends StatefulWidget {
  final ValueChanged<File> onPhotoTaken;

  const PhotoScreen({Key? key, required this.onPhotoTaken}) : super(key: key);

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  File? _tempImage;
  String? _error;

  Future<void> _pickOrTakePhoto(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked != null) {
        final file = File(picked.path);
        setState(() {
          _tempImage = file;
          _error = null;
        });
        widget.onPhotoTaken(file);
      }
    } catch (e) {
      setState(() {
        _error = 'Ошибка при выборе фото';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Загрузите своё фото'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Изменить стиль',
            onPressed: () {
              Navigator.pop(context); // вернуться к выбору стиля
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
        child: Column(
          children: [
            if (_error != null) ...[
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Сделать фото'),
              onPressed: () => _pickOrTakePhoto(ImageSource.camera),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo),
              label: const Text('Выбрать из галереи'),
              onPressed: () => _pickOrTakePhoto(ImageSource.gallery),
            ),
            const SizedBox(height: 24),
            if (_tempImage != null)
              Expanded(child: Image.file(_tempImage!))
            else
              const Expanded(child: Center(child: Text('Фото не выбрано'))),
          ],
        ),
      ),
    );
  }
}
