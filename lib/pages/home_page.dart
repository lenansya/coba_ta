import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tugas_akhirr/models/star_model.dart';
import 'package:tugas_akhirr/service/notification_service.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'suggestion_page.dart';
import 'package:tugas_akhirr/pages/detail_page.dart';
import 'package:tugas_akhirr/presenter/star_presenter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String email;

  const HomePage({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _currentTime = '';
  String _selectedTimeZone = 'WIB';
  late Timer _timer;

  final Map<String, Duration> _timeZoneOffsets = {
    'WIB': const Duration(hours: 7),
    'WITA': const Duration(hours: 8),
    'WIT': const Duration(hours: 9),
    'London': const Duration(hours: 0),
    'Paris': const Duration(hours: 1),
    'America': const Duration(hours: -5),
  };

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now().toUtc();
    final offset = _timeZoneOffsets[_selectedTimeZone] ?? Duration.zero;
    final localTime = now.add(offset);

    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(localTime);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      FilmListView(
        onTimeZoneChanged: (String timeZone) {
          setState(() {
            _selectedTimeZone = timeZone;
          });
        },
        currentTimeZone: _selectedTimeZone,
        timeZoneOffsets: _timeZoneOffsets,
      ),
      ProfilePage(),
      const SuggestionPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}!'),
        backgroundColor: const Color(0xFFFFBA00),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Text(
                  _currentTime,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Feedback',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color(0xFFFFBA00),
        onTap: _onItemTapped,
      ),
    );
  }
}

class FilmListView extends StatefulWidget {
  final Function(String) onTimeZoneChanged;
  final String currentTimeZone;
  final Map<String, Duration> timeZoneOffsets;

  const FilmListView({
    super.key,
    required this.onTimeZoneChanged,
    required this.currentTimeZone,
    required this.timeZoneOffsets,
  });

  @override
  State<FilmListView> createState() => _FilmListView();
}

class _FilmListView extends State<FilmListView> implements FilmView {
  late FilmPresenter _presenter;
  bool _isLoading = false;
  List<Film> _filmList = [];
  String? _errorMessage;
  final String _currentEndpoint = 'films/';
  String _selectedCurrency = 'USD';

  final Map<int, double> _productionCosts = {
    1: 11000000,
    2: 15000000,
    3: 18000000,
    4: 11000000,
    5: 15000000,
    6: 18000000,
  };

  final Map<String, double> _currencyRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'IDR': 15000.0,
    'JPY': 110.0,
    'GBP': 0.75,
    'AUD': 1.4,
  };

  final Map<int, String> _filmImages = {
    1: 'assets/a_new_hope.jpg',
    2: 'assets/the_empire.jpg',
    3: 'assets/return.jpg',
    4: 'assets/the_phantom.jpg',
    5: 'assets/attack.jpg',
    6: 'assets/revenge.jpg',
  };

  final Color primary = const Color(0xFFBB8A52);
  final Color backgroundColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _presenter = FilmPresenter(this);
    _fetchData();
    NotificationService().init();
  }

  void _fetchData() {
    setState(() {
      _isLoading = true;
    });
    _presenter.loadFilmData(_currentEndpoint);
  }

  double _convertCurrency(double amount, String targetCurrency) {
    return amount * (_currencyRates[targetCurrency] ?? 1.0);
  }

   void _showCurrencySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: _currencyRates.keys.map((currency) {
            return ListTile(
              title: Text(currency),
              onTap: () {
                setState(() {
                  _selectedCurrency = currency;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showTimeZoneSelector() {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return ListView(
        children: widget.timeZoneOffsets.keys.map((timeZone) {
          return ListTile(
            title: Text(timeZone),
            onTap: () {
              widget.onTimeZoneChanged(timeZone);
              Navigator.pop(context);
            },
          );
        }).toList(),
      );
    },
  );
}

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showFilmList(List<Film> filmList) {
    setState(() {
      _filmList = filmList;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Image.asset(
              'assets/logo.png',
              height: 100, 
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primary),
                    ),
                  )
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Error: $_errorMessage",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filmList.length,
                        itemBuilder: (context, index) {
                          final film = _filmList[index];
                          final productionCost = _productionCosts[film.id] ?? 0.0;
                          final convertedCost = _convertCurrency(productionCost, _selectedCurrency);
                          final filmImage = _filmImages[film.id] ?? 'assets/default.jpg';

                          return Card(
                            color: const Color(0xFFEAD7C0),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      filmImage,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          film.title,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: primary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Production Cost: ${convertedCost.toStringAsFixed(2)} $_selectedCurrency',
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.notifications),
                                    color: Colors.black,
                                    onPressed: () {
                                      NotificationService().showNotification(
                                        "New Information",
                                        "Details about ${film.title} are available!",
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.arrow_forward, color: Colors.black),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailScreen(
                                            id: film.id,
                                            endpoint: 'films/',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        onSelected: (value) {
          if (value == 'currency') {
            _showCurrencySelector();
          } else if (value == 'timezone') {
            _showTimeZoneSelector();
          }
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem(
            value: 'currency',
            child: Row(
              children: [
                Icon(Icons.monetization_on),
                SizedBox(width: 8),
                Text('Convert Currency'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'timezone',
            child: Row(
              children: [
                Icon(Icons.access_time),
                SizedBox(width: 8),
                Text('Convert Time Zone'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
