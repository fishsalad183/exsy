import 'package:exsy/assets/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E0E0),
        toolbarHeight: 72,
        automaticallyImplyLeading: false,
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SelectableText(
                    Constants.labelNameSurname,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 44,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 56.0, vertical: 24.0),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/gallery');
                    },
                    child: const Text(
                      Constants.labelExploreArtworks,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.helmetSafety, color: Colors.orange, size: 32),
                        SizedBox(width: 8),
                        Text(
                          'Website under construction...',
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                          // softWrap: true,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
    );
  }
}
