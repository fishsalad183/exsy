import 'package:exsy/assets/constants.dart';
import 'package:exsy/screens/util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

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
          _buildNavButton(context, Constants.labelNavBarGallery, '/artworks'),
          _buildNavButton(context, Constants.labelNavBarBioContact, '/contact'),
          const SizedBox(width: 8.0),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SelectableText(
                  Constants.bio,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _launchInstagram,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.instagram, color: Colors.black, size: 40),
                        SizedBox(width: 8),
                        SelectableText(
                          Constants.labelInstagram,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
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

  Future<void> _launchInstagram() async {
    const nativeUrl = Constants.urlInstagramNative;
    const webUrl = Constants.urlInstagramWeb;
    if (await canLaunchUrlString(nativeUrl)) {
      await launchUrlString(nativeUrl);
    } else if (await canLaunchUrlString(webUrl)) {
      await launchUrlString(webUrl);
    } else {
      print("can't open Instagram");
    }
  }
}
