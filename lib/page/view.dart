// import 'package:flutter/material.dart';
// import 'package:tugas_akhirr/models/product_model.dart';
// import 'package:tugas_akhirr/presenter/product_presenter.dart';

// class ProductListScreen extends StatefulWidget {
//   const ProductListScreen({super.key});

//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }

// class _ProductListScreenState extends State<ProductListScreen> implements ProductView {
//   late ProductPresenter _presenter;
//   bool _isLoading = false;
//   List<Product> _productList = [];
//   String? _errorMessage;
//   String _currentEndpoint = 'products';

//   // Define color palette
//   final Color primaryBlue = const Color(0xFF1E88E5);
//   final Color secondaryBlue = const Color(0xFF64B5F6);
//   final Color darkBlue = const Color(0xFF0D47A1);
//   final Color lightBlue = const Color(0xFFBBDEFB);
//   final Color backgroundColor = const Color(0xFFE3F2FD);

//   @override
//   void initState() {
//     super.initState();
//     _presenter = ProductPresenter(this);
//     _presenter.loadProductData(_currentEndpoint);
//   }

//   void _fetchData(String endpoint) {
//     setState(() {
//       _currentEndpoint = endpoint;
//       _presenter.loadProductData(endpoint);
//     });
//   }

//   @override
//   void hideLoading() {
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   void showProductList(List<Product> productList) {
//     setState(() {
//       _productList = productList;
//     });
//   }

//   @override
//   void showError(String message) {
//     setState(() {
//       _errorMessage = message;
//     });
//   }

//   @override
//   void showLoading() {
//     setState(() {
//       _isLoading = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: primaryBlue,
//         title: const Text(
//           "Product List",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             decoration: BoxDecoration(
//               color: primaryBlue,
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//             ),
//             child: Center(
//               child: ElevatedButton(
//                 onPressed: () => _fetchData('products'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: darkBlue,
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 child: const Text(
//                   "Load Products",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _isLoading
//                 ? Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
//                     ),
//                   )
//                 : _errorMessage != null
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(
//                               Icons.error_outline,
//                               color: Colors.red,
//                               size: 48,
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               "Error: $_errorMessage",
//                               style: const TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         padding: const EdgeInsets.all(16),
//                         itemCount: _productList.length,
//                         itemBuilder: (context, index) {
//                           final product = _productList[index];
//                           return Card(
//                             elevation: 4,
//                             margin: const EdgeInsets.only(bottom: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: InkWell(
//                               // onTap: () {
//                               //   Navigator.push(
//                               //     context,
//                               //     MaterialPageRoute(
//                               //       builder: (context) => ProductDetailScreen(
//                               //         id: product.id,
//                               //         endpoint: _currentEndpoint,
//                               //       ),
//                               //     ),
//                               //   );
//                               // },
//                               child: Container(
//                                 padding: const EdgeInsets.all(12),
//                                 child: Row(
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(10),
//                                       child: SizedBox(
//                                         width: 80,
//                                         height: 80,
//                                         child: product.thumbnailImage.isNotEmpty
//                                             ? Image.network(
//                                                 product.thumbnailImage,
//                                                 fit: BoxFit.cover,
//                                               )
//                                             : Image.network(
//                                                 'https://placehold.co/600x400',
//                                                 fit: BoxFit.cover,
//                                               ),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 16),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             product.productName,
//                                             style: TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.bold,
//                                               color: darkBlue,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 4),
//                                           Text(
//                                             product.productDescription,
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.grey[600],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Icon(
//                                       Icons.arrow_forward_ios,
//                                       color: secondaryBlue,
//                                       size: 20,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }
