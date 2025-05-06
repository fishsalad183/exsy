import 'package:exsy/assets/constants.dart';
import 'package:exsy/screens/util.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E0E0),
        toolbarHeight: 72,
        automaticallyImplyLeading: false,
        leadingWidth: isSmallerScreen(context) ? 0 : 240,
        leading: isSmallerScreen(context)
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
          _buildNavButton(context, Constants.labelNavBarHome, '/'),
          _buildNavButton(context, Constants.labelNavBarGallery, '/gallery'),
          _buildNavButton(context, Constants.labelNavBarBioContact, '/contact'),
          const SizedBox(width: 8.0),
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
          if (isSmallerScreen(context))
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: isSmallerScreen(context) ? 100 : 160,
        height: 56,
        child: TextButton(
          style: TextButton.styleFrom(
            textStyle: TextStyle(
              fontSize: isSmallerScreen(context) ? 16 : 18,
            ),
            backgroundColor: isSelected ? Colors.black : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          ),
          onPressed: isSelected
              ? null
              : () {
                  Navigator.pushReplacementNamed(context, route);
                },
          child: Text(
            title,
            textAlign: TextAlign.center,
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
