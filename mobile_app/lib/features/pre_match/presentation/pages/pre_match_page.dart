import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pre_match_provider.dart';

class PreMatchPage extends ConsumerWidget {
  final String matchId;

  const PreMatchPage({super.key, required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsyncValue = ref.watch(preMatchAnalysisProvider(matchId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maç Öncesi Analiz'),
      ),
      body: analysisAsyncValue.when(
        data: (analysis) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        '\${analysis.homeTeam} vs \${analysis.awayTeam}',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProbColumn('Ev', analysis.homeWinProbability),
                          _buildProbColumn('Brb', analysis.drawProbability),
                          _buildProbColumn('Dep', analysis.awayWinProbability),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Yapay Zeka Taktiksel Önizlemesi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Text(
                analysis.aiTacticalReview,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Hata oluştu: \$error', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildProbColumn(String label, double percentage) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('%\$percentage'),
      ],
    );
  }
}
