import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/feed/presentation/pages/feed_page.dart';

void main() {
  runApp(
    // Riverpod ProviderScope'u tüm uygulamayı sarmalıyor
    const ProviderScope(
      child: FutbolPanoramaApp(),
    ),
  );
}

class FutbolPanoramaApp extends StatelessWidget {
  const FutbolPanoramaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Futbol Panorama',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // Ana akış sayfasını varsayılan giriş yap
      home: const FeedPage(),
    );
  }
}
