import 'package:flutter/material.dart';
import '../../domain/entities/feed_item.dart';

class AnalysisCard extends StatelessWidget {
  final FeedItem item;

  const AnalysisCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Detay sayfasına yönlendirme gelecek
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Kısım: Yazar, Güven Skoru ve Rozet
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          item.authorName.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.authorName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          // Rozetleri yan yana dizme
                          if (item.badges.isNotEmpty)
                            const SizedBox(height: 2),
                          if (item.badges.isNotEmpty)
                            Row(
                              children: item.badges.map((badge) {
                                IconData iconData = Icons.verified; // Default
                                if (badge.contains('Deha')) iconData = Icons.psychology;
                                if (badge.contains('Scout')) iconData = Icons.visibility;
                                
                                return Row(
                                  children: [
                                    Icon(iconData, size: 14, color: Colors.orange.shade700),
                                    const SizedBox(width: 4),
                                    Text(
                                      badge,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.orange.shade700,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                );
                              }).toList(),
                            )
                        ],
                      ),
                    ],
                  ),
                  // Güven Skoru Köşesi
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: item.trustScore >= 75 
                          ? Colors.green.withOpacity(0.15) 
                          : Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.trustScore >= 75 ? Icons.auto_graph : Icons.trending_flat,
                          size: 16,
                          color: item.trustScore >= 75 ? Colors.green.shade700 : Colors.orange.shade800,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.trustScore.toStringAsFixed(1),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: item.trustScore >= 75 ? Colors.green.shade700 : Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              
              // Başlık
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              
              // Etiket (Chip) - Analiz Tipi
              Chip(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                label: Text(
                  item.type.displayName,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                side: BorderSide.none,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
