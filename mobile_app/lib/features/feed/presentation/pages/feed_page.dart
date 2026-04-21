import 'package:flutter/material.dart';
import '../../domain/entities/feed_item.dart';
import '../widgets/analysis_card.dart';
import '../../../../features/create_analysis/presentation/pages/create_analysis_page.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Arayüzü test etmek için mock veriler
    final List<FeedItem> dummyFeed = [
      FeedItem(
        id: '1',
        authorName: 'Ahmet Yılmaz',
        title: 'Galatasaray - Fenerbahçe Derbisi: Ön Alan Baskısının Kilit Rolü',
        trustScore: 92.5,
        badges: ['Taktik Dehası'],
        type: AnalysisType.preMatch,
      ),
      FeedItem(
        id: '2',
        authorName: 'Caner Kaya',
        title: 'Arda Güler\'in Real Madrid\'deki Yeni Rolü: Sahte 9 mu, 10 Numara mı?',
        trustScore: 98.0,
        badges: ['Scout', 'Uzman'],
        type: AnalysisType.player,
      ),
      FeedItem(
        id: '3',
        authorName: 'Burak Demir',
        title: 'Beşiktaş - Konyaspor Maç Sonu Analizi: Savunma Zafiyetleri',
        trustScore: 78.4,
        badges: ['Analist'],
        type: AnalysisType.postMatch,
      ),
      FeedItem(
        id: '4',
        authorName: 'FutbolSever99',
        title: 'Süper lig bu sene çok çekişmeli geçer',
        trustScore: 45.0,
        badges: [],
        type: AnalysisType.preMatch,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Akış', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          )
        ],
      ),
      // Arka plan rengini hafif gri yaparak kartların daha çok öne çıkmasını sağlıyoruz
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: dummyFeed.length,
        itemBuilder: (context, index) {
          final item = dummyFeed[index];
          return AnalysisCard(item: item);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateAnalysisPage(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Yeni Analiz', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
