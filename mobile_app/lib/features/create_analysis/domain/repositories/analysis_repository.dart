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
  }) async {
    try {
      // 1. Önce ana 'analyses' kaydını oluşturuyoruz ve ID'sini geri alıyoruz (.select().single())
      final analysisRow = await _supabase.from('analyses').insert({
        'title': title,
        'user_id': userId,
        'created_at': DateTime.now().toIso8601String(),
        // varsa eklemek isteyebileceğin team_id, match_id vb. ilişkiler
      }).select('id').single();

      final String newAnalysisId = analysisRow['id'].toString();

      // 2. Analiz adımlarını (FloodItem) Supabase'in beklediği List<Map> yapısına dönüştürüyoruz
      final List<Map<String, dynamic>> stepRecords = [];
      
      for (int i = 0; i < steps.length; i++) {
        final step = steps[i];
        
        // Sadece içi boş olmayan (veya sadece boşluk içermeyen) adımları kaydetmek iyi bir pratiktir
        if (step.text.trim().isNotEmpty || step.imagePath != null) {
          stepRecords.add({
            'analysis_id': newAnalysisId,
            'step_order': i,          // Hangi sırada gösterileceği çok önemli
            'content': step.text,
            'image_url': step.imagePath, // Upload işlemi öncesinde yapılmışsa URL'si, yapılmamışsa Path vb.
          });
        }
      }

      // 3. Çoklu Ekleme (Bulk Insert) İşlemi
      // stepRecords listesini direkt verdiğimizde Supabase bunu tek bir çoklu POST/INSERT işleminde postgREST ile gönderir
      if (stepRecords.isNotEmpty) {
         await _supabase.from('analysis_steps').insert(stepRecords);
      }

    } on PostgrestException catch (e) {
      // Supabase veritabanı hataları (örneğin foreign key uyumsuzluğu, yetkisizlik)
      throw Exception('Veritabanı hatası: ${e.message}');
    } catch (e) {
      // Diğer genel hatalar
      throw Exception('Analiz gönderilirken beklenmeyen bir hata oluştu: $e');
    }
  }
}
