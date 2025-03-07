import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String title;
  final List<String> items;

  const CategoryPage({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> boxColors = [
      const Color(0xFF6D9773), 
      const Color(0xFFBB8A52), 
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFBA00), 
      ),
      body: Container(
        color: Colors.black,
        child: items.isEmpty
            ? const Center(
                child: Text(
                  "No data available.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: boxColors[index % boxColors.length], 
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      items[index],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white, 
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
