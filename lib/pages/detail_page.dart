import 'package:flutter/material.dart';
import 'package:tugas_akhirr/pages/category_page.dart';
import 'package:tugas_akhirr/presenter/star_detail_presenter.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.id, required this.endpoint});
  final int id;
  final String endpoint;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> implements FilmDetailView {
  late FilmDetailPresenter _presenter;
  bool _isLoading = true;
  Map<String, dynamic>? _detailData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _presenter = FilmDetailPresenter(this);
    _presenter.loadDetailData(widget.endpoint, widget.id);
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showDetailData(Map<String, dynamic> detailData) {
    setState(() {
      _isLoading = false;

      // Membatasi data characters dan species di UI
      detailData['characters'] = (detailData['characters'] as List).take(10).toList();
      detailData['species'] = (detailData['species'] as List).take(10).toList();
      _detailData = detailData;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Detail"),
        backgroundColor: const Color(0xFFFFBA00), 
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Text(
                    "Error: $_errorMessage",
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _detailData != null
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title: ${_detailData!['title']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFBA00), 
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Director: ${_detailData!['director']}', style: const TextStyle(color: Colors.white)),
                          Text('Producer: ${_detailData!['producer']}', style: const TextStyle(color: Colors.white)),
                          Text('Release Date: ${_detailData!['releaseDate']}', style: const TextStyle(color: Colors.white)),
                          const SizedBox(height: 16),
                          const Text(
                            'Opening Crawl:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFBA00), 
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _detailData!['openingCrawl'],
                            textAlign: TextAlign.justify, 
                            style: const TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          const Divider(height: 32),
                          _buildNavigationButton(context, 'Characters', _detailData!['characters']),
                          const SizedBox(height: 12),
                          _buildNavigationButton(context, 'Planets', _detailData!['planets']),
                          const SizedBox(height: 12),
                          _buildNavigationButton(context, 'Species', _detailData!['species']),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text("No data available."),
                    ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, String title, List<String> items) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: const Color(0xFFFFBA00),
        shadowColor: Colors.black26,
        elevation: 4,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(
              title: title,
              items: items,
            ),
          ),
        );
      },
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
