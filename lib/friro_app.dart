import 'package:flutter/material.dart';

/// Simple demo app to showcase a minimal virtual fitting flow.
class FriroApp extends StatelessWidget {
  const FriroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friro',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleMedium: TextStyle(fontSize: 18, color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Friro',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset('assets/clothes/shirt1.png', height: 200),
              const SizedBox(height: 20),
              Text(
                'AI-Powered Virtual Fitting',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TryOnScreen()),
                ),
                child: const Text('Get Started'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TryOnScreen extends StatelessWidget {
  const TryOnScreen({super.key});

  final List<Map<String, String>> clothing = const [
    {'brand': 'Mango', 'item': 'Sweatshirt', 'size': 'M'},
    {'brand': 'Levi\'s', 'item': 'Jeans', 'size': '28'},
    {'brand': 'H&M', 'item': 'Jacket', 'size': 'M'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Friro', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/clothes/shirt1.png', height: 250),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Try On'),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                itemCount: clothing.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = clothing[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.checkroom),
                      title: Text(item['brand'] ?? ''),
                      subtitle: Text('${item['item']}  \u2022  Size: ${item['size']}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

