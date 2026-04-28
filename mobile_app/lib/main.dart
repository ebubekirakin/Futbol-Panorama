import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';

import 'features/feed/presentation/pages/feed_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

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
      // Kullanıcı zaten giriş yapmışsa Ana Akış'a, yapmamışsa Giriş Sayfasına yönlendir
      home: Supabase.instance.client.auth.currentSession != null 
          ? const FeedPage() 
          : const LoginPage(),
    );
  }
}
