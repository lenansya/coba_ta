import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class FilmDetailView {
  void showLoading();
  void hideLoading();
  void showDetailData(Map<String, dynamic> detailData);
  void showError(String message);
}

class FilmDetailPresenter {
  final FilmDetailView view;
  FilmDetailPresenter(this.view);

  Future<List<String>> _fetchListDetails(List<dynamic> urls) async {
  List<String> details = [];
  for (var url in urls) {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        details.add(jsonResponse['result']['properties']['name'] ?? 'Unknown');
      }
    } catch (e) {
      details.add('Error fetching details');
    }
  }
  return details;
}

void loadDetailData(String endpoint, int id) async {
  try {
    final url = 'https://www.swapi.tech/api/$endpoint$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final result = jsonResponse['result'];
      final properties = result['properties'];

      List<String> characters = await _fetchListDetails(properties['characters'] ?? []);
      List<String> planets = await _fetchListDetails(properties['planets'] ?? []);
      List<String> species = await _fetchListDetails(properties['species'] ?? []);

      view.showDetailData({
        'title': properties['title'],
        'director': properties['director'],
        'producer': properties['producer'],
        'releaseDate': properties['release_date'],
        'openingCrawl': properties['opening_crawl'],
        'characters': characters,
        'planets': planets,
        'species': species,
      });
    } else {
      view.showError('Failed to load detail data.');
    }
  } catch (e) {
    view.showError(e.toString());
  }
}
}