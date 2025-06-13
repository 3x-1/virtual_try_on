// lib/screens/style_selection_screen.dart

import 'package:flutter/material.dart';

class StyleSelectionScreen extends StatelessWidget {
  final ValueChanged<String> onStyleSelected;

  const StyleSelectionScreen({Key? key, required this.onStyleSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> styles = ['Casual', 'Sport', 'Business', 'Party'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите стиль'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
        child: ListView.builder(
          itemCount: styles.length,
          itemBuilder: (context, index) {
            final style = styles[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(style),
                onTap: () {
                  onStyleSelected(style);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
