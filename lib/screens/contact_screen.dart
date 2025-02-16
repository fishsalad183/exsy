import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E0E0), // Darker light gray
        toolbarHeight: 80, // Slightly larger vertically
        actions: [
          _buildNavButton(context, 'Home', '/'),
          _buildNavButton(context, 'Gallery', '/gallery'),
          _buildNavButton(context, 'Contact', '/contact'),
          const SizedBox(width: 32), // More space from the right edge
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 48.0), // More spacing from the left edge
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jelena Milatović',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 16),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _launchInstagram,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.instagram, color: Colors.black, size: 40),
                      const SizedBox(width: 8), // Spacing between icon and text
                      const Text(
                        '@buntovac_',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, String route) {
    final bool isSelected = ModalRoute.of(context)?.settings.name == route;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0), // More space between buttons
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

  void _launchInstagram() async {
    const nativeUrl = "instagram://user?username=buntovac_";
    const webUrl = "https://www.instagram.com/buntovac_/";
    if (await canLaunch(nativeUrl)) {
      await launch(nativeUrl);
    } else if (await canLaunch(webUrl)) {
      await launch(webUrl);
    } else {
      print("can't open Instagram");
    }
  }
}
