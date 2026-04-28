import 'package:flutter/material.dart';
import '../../domain/entities/feed_item.dart';

class AnalysisCard extends StatelessWidget {
  final FeedItem item;

  const AnalysisCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.brightness == Brightness.dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        boxShadow: [
          if (theme.colorScheme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Detay sayfasına yönlendirme gelecek
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                          radius: 20,
                          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                          child: Text(
                            item.authorName.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.authorName,
                              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
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
                                      Icon(iconData, size: 12, color: Colors.amber.shade600),
                                      const SizedBox(width: 4),
                                      Text(
                                        badge,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: Colors.amber.shade600,
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
                            ? theme.colorScheme.primary.withValues(alpha: 0.1) 
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: item.trustScore >= 75 
                            ? theme.colorScheme.primary.withValues(alpha: 0.3) 
                            : Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.trustScore >= 75 ? Icons.trending_up : Icons.trending_flat,
                            size: 14,
                            color: item.trustScore >= 75 ? theme.colorScheme.primary : Colors.orange.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.trustScore.toStringAsFixed(1),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: item.trustScore >= 75 ? theme.colorScheme.primary : Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                
                // Başlık
                Text(
                  item.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Etiket (Chip) - Analiz Tipi
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.type.displayName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
