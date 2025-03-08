import 'package:exsy/assets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:exsy/screens/home_screen.dart';
import 'package:exsy/screens/gallery_screen.dart';
import 'package:exsy/screens/contact_screen.dart';

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget? child,
  ) {
    return child!;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFE0E0E0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE0E0E0),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: kIsWeb
              ? {
                  for (final platform in TargetPlatform.values) platform: const NoTransitionsBuilder(),
                }
              : const {
                  TargetPlatform.android: ZoomPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/gallery': (context) => const GalleryScreen(),
        '/contact': (context) => const ContactScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.startsWith('/gallery?album=')) {
          final uri = Uri.parse(settings.name!);
          final album = uri.queryParameters['album'];
          return MaterialPageRoute(
            builder: (context) => GalleryScreen(selectedAlbum: album),
          );
        }
        return null;
      },
    );
  }
}
