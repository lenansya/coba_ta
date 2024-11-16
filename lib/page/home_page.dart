// import 'package:flutter/material.dart';
// import 'package:tugas_akhirr/models/product_model.dart';
// import 'login_page.dart';
// import 'profile_page.dart';
// import 'suggestion_page.dart';
// import 'currency_converter_page.dart';
// import 'time_converter_page.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class HomePage extends StatefulWidget {
//   final String username;
//   final String email;

//   const HomePage({
//     super.key,
//     required this.username,
//     required this.email,
//   });

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late Future<List<Product>> _futureProducts;
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _futureProducts = fetchProducts();
//   }

//   Future<List<Product>> fetchProducts() async {
//     final response = await http.get(Uri.parse('http://localhost:8080/api/products'));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map((json) => Product.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> _pages = <Widget>[
//       _buildHomePageContent(),       
//       ProfilePage(),                 
//       SuggestionPage(),              
//       CurrencyConverterPage(),       
//       TimeConverterPage(),           
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome, ${widget.username}!'),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const LoginPage(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.message),
//             label: 'Saran',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.attach_money),
//             label: 'Mata Uang',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.access_time),
//             label: 'Waktu',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         onTap: _onItemTapped,
//       ),
//     );
//   }

//   // Fungsi untuk menampilkan konten halaman Home
//   Widget _buildHomePageContent() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 16),
//             const SizedBox(height: 8),
//             Expanded(
//               child: FutureBuilder<List<Product>>(
//                 future: _futureProducts,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const CircularProgressIndicator();
//                   } else if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Text('No products available.');
//                   } else {
//                     return ListView.builder(
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (context, index) {
//                         final product = snapshot.data![index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: ListTile(
//                             title: Text(product.name),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Brand: ${product.brand}'),
//                                 Text('Ingredients: ${product.ingredient_list}'),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tugas_akhirr/models/star_model.dart';
import 'package:tugas_akhirr/page/detail_page.dart';
import 'package:tugas_akhirr/presenter/star_presenter.dart';

class FilmListView extends StatefulWidget {
  const FilmListView({super.key});

  @override
  State<FilmListView> createState() => _FilmListView();
}

class _FilmListView extends State<FilmListView> implements FilmView {
  late FilmPresenter _presenter;
  bool _isLoading = false;
  List<Film> _filmList = [];
  String? _errorMessage;
  String _currentEndpoint = '';

  // Define color palette
  final Color primaryBlue = const Color(0xFF1E88E5);
  final Color secondaryBlue = const Color(0xFF64B5F6);
  final Color darkBlue = const Color(0xFF0D47A1);
  final Color lightBlue = const Color(0xFFBBDEFB);
  final Color backgroundColor = const Color(0xFFE3F2FD);

  @override
  void initState() {
    super.initState();
    _presenter = FilmPresenter(this);
    _presenter.loadFilmData(_currentEndpoint);
  }

  void _fetchData(String endpoint) {
    setState(() {
      _currentEndpoint = endpoint;
      _presenter.loadFilmData(endpoint);
    });
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        title: const Text(
          "Star Wars",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
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
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      id: film.id,
                                      endpoint: _currentEndpoint,
                                    ),
                                  ),
                                );
                              },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    film.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: darkBlue,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}