import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/feed_item.dart';
import '../../domain/repositories/feed_repository.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return FeedRepository();
});

final feedProvider = FutureProvider.autoDispose<List<FeedItem>>((ref) async {
  final repository = ref.watch(feedRepositoryProvider);
  return repository.getFeedItems();
});
