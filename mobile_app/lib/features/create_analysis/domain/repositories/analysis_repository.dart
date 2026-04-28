import 'package:supabase_flutter/supabase_flutter.dart';
import '../../presentation/providers/flood_provider.dart'; // FloodItem sınıfımız

class AnalysisRepository {
  final SupabaseClient _supabase;

  AnalysisRepository({SupabaseClient? supabase}) 
      : _supabase = supabase ?? Supabase.instance.client;

  /// Yeni analiz ve ona bağlı tüm adımları (flood'u) veritabanına kaydeder
  Future<void> submitAnalysisAsFlood({
    required String title,
    required String userId,
    required List<FloodItem> steps,
    String type = 'pre-match',
  }) async {
    try {
      // FloodItem'ları tek bir metne (Markdown benzeri) dönüştürüyoruz
      String finalContent = '';
      for (var step in steps) {
        if (step.text.trim().isNotEmpty) {
          finalContent += '${step.text}\n\n';
        }
        if (step.imagePath != null) {
          // İleride burası Storage'a yüklendikten sonra gelen URL ile değiştirilebilir
          finalContent += '![Görsel](${step.imagePath})\n\n';
        }
      }

      // 'analyses' tablosuna tek satır ekliyoruz
      await _supabase.from('analyses').insert({
        'title': title,
        'author_id': userId,
        'type': type,
        'content': finalContent.trim(),
        'created_at': DateTime.now().toIso8601String(),
      });

    } on PostgrestException catch (e) {
      throw Exception('Veritabanı hatası: ${e.message}');
    } catch (e) {
      throw Exception('Analiz gönderilirken beklenmeyen bir hata oluştu: $e');
    }
  }
}
