import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/feed_item.dart';

class FeedRepository {
  final SupabaseClient _supabase;

  FeedRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<List<FeedItem>> getFeedItems() async {
    try {
      // Supabase'den verileri users tablosuyla joinleyerek çekiyoruz
      final response = await _supabase.from('analyses').select('''
        id,
        title,
        type,
        ai_score,
        community_score,
        created_at,
        users (
          name,
          trust_score,
          badges
        )
      ''').order('created_at', ascending: false);

      final List<FeedItem> items = [];
      for (var row in response) {
        final userData = row['users'] as Map<String, dynamic>?;
        
        // Enum eşleştirmesi
        AnalysisType type = AnalysisType.preMatch;
        if (row['type'] == 'post-match') {
          type = AnalysisType.postMatch;
        } else if (row['type'] == 'player') {
          type = AnalysisType.player;
        }

        // List<String> cast
        List<String> badges = [];
        if (userData != null && userData['badges'] != null) {
          badges = List<String>.from(userData['badges']);
        }

        items.add(FeedItem(
          id: row['id'].toString(),
          authorName: userData?['name'] ?? 'İsimsiz Analist',
          title: row['title'] ?? 'Başlıksız Analiz',
          trustScore: double.tryParse(userData?['trust_score']?.toString() ?? '50.0') ?? 50.0,
          badges: badges,
          type: type,
        ));
      }
      return items;
    } on PostgrestException catch (e) {
      throw Exception('Veritabanı hatası: ${e.message}');
    } catch (e) {
      throw Exception('Veriler çekilirken beklenmeyen bir hata oluştu: $e');
    }
  }
}
