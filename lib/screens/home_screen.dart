import 'package:exsy/assets/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallerScreen = MediaQuery.of(context).size.width <= 1200;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E0E0),
        toolbarHeight: 72,
        automaticallyImplyLeading: false,
        leadingWidth: isSmallerScreen ? 0 : 240,
        leading: isSmallerScreen
            ? null
            : GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/'),
                child: const MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Constants.labelNameSurname,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        actions: [
          _buildNavButton(context, 'Home', '/'),
          _buildNavButton(context, 'Gallery', '/gallery'),
          _buildNavButton(context, 'Contact', '/contact'),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/home/home_image.jpg',
              fit: BoxFit.cover,
            ),
          ),
          if (isSmallerScreen)
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text(
                    Constants.labelNameSurname,
                    style: TextStyle(
                      fontSize: 32,
                      color: Color.fromARGB(255, 49, 49, 49),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, String route) {
    final bool isSelected = ModalRoute.of(context)?.settings.name == route;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
        width: 100,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: isSelected ? Colors.black : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          onPressed: isSelected
              ? null
              : () {
                  Navigator.pushReplacementNamed(context, route);
                },
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFFE0E0E0) : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
