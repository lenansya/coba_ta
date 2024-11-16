class Film {
  final int id;
  final String title;
  final String openingCrawl;
  final String director;
  final String producer;
  final String releaseDate;
  final List<String> characters;
  final List<String> planets;
  final List<String> starships;
  final List<String> vehicles;
  final List<String> species;

  Film({
    required this.id,
    required this.title,
    required this.openingCrawl,
    required this.director,
    required this.producer,
    required this.releaseDate,
    required this.characters,
    required this.planets,
    required this.starships,
    required this.vehicles,
    required this.species,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: int.tryParse(json['uid']) ?? 0,
      title: json['properties']['title'] ?? 'Unknown Title',
      openingCrawl: json['properties']['opening_crawl'] ?? 'No Opening Crawl Available',
      director: json['properties']['director'] ?? 'Unknown Director',
      producer: json['properties']['producer'] ?? 'Unknown Producer',
      releaseDate: json['properties']['release_date'] ?? 'Unknown Release Date',
      characters: List<String>.from(json['properties']['characters'] ?? []),
      planets: List<String>.from(json['properties']['planets'] ?? []),
      starships: List<String>.from(json['properties']['starships'] ?? []),
      vehicles: List<String>.from(json['properties']['vehicles'] ?? []),
      species: List<String>.from(json['properties']['species'] ?? []),
    );
  }
}