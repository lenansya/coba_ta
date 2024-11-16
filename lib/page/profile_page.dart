import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final List<Map<String, String>> members = [
    {
      'bio': 'Name: Lenansya Ersa Salsabila\nNIM: 124220082\nEmail: lenansya@gmail.com',
      'image': 'assets/images/lenan.jpg',
    },
  ];

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.pinkAccent[100],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double screenWidth = constraints.maxWidth;
          final double screenHeight = constraints.maxHeight;
          final bool isPortrait = screenHeight > screenWidth;

          return Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink[50]!, Colors.pink[100]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: members.map((member) {
                        return Container(
                          width: screenWidth,
                          margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                          ),
                          child: Card(
                            color: Colors.pink[50],
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenWidth * 0.03),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(member['image']!),
                                    radius: isPortrait 
                                        ? screenWidth * 0.15 
                                        : screenHeight * 0.15,
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      member['name']!,
                                      style: TextStyle(
                                        fontSize: isPortrait 
                                            ? screenWidth * 0.06 
                                            : screenHeight * 0.06,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.pink[800],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: SizedBox(
                                      width: screenWidth * 0.8,
                                      child: Text(
                                        member['bio']!,
                                        style: TextStyle(
                                          fontSize: isPortrait 
                                              ? screenWidth * 0.04 
                                              : screenHeight * 0.04,
                                          color: Colors.pink[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}