
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../providers/flood_provider.dart';

class CreateAnalysisPage extends ConsumerStatefulWidget {
  const CreateAnalysisPage({super.key});

  @override
  ConsumerState<CreateAnalysisPage> createState() => _CreateAnalysisPageState();
}

class _CreateAnalysisPageState extends ConsumerState<CreateAnalysisPage> {
  // Controller'ları id'lerine göre tutan harita.
  // Performans ve state yönetimi uyumu için controller'ları arayüz tarafında (State) tutuyoruz.
  final Map<String, TextEditingController> _controllers = {};

  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    // Hafıza sızıntısı olmaması için oluşturulan tüm controller'lar dispose ediliyor
    for (var controller in _controllers.values) {
      if (mounted) controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(String id, String initialText) {
    if (!_controllers.containsKey(id)) {
      final controller = TextEditingController(text: initialText);
      // Klavye yazıldıkça ufak gecikmelerden kaçınmak ve provider'ı eşitlemek için listener
      controller.addListener(() {
        ref.read(floodNotifierProvider.notifier).updateText(id, controller.text);
      });
      _controllers[id] = controller;
    }
    return _controllers[id]!;
  }

  Future<void> _pickImage(String id) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sistem galerisi açılıyor (Simülasyon)')),
    );
    ref.read(floodNotifierProvider.notifier).updateImage(id, 'simulated_dummy_path_for_$id');
  }

  @override
  Widget build(BuildContext context) {
    final floodList = ref.watch(floodNotifierProvider);
    final theme = Theme.of(context);
    
    final currentIds = floodList.map((e) => e.id).toSet();
    _controllers.keys.where((id) => !currentIds.contains(id)).toList().forEach((id) {
       _controllers[id]?.dispose();
       _controllers.remove(id);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analiz Oluştur'),
        actions: [
          filledButtonOrTextButton(context, floodList), 
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Analizine bir başlık ver',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Örn: Bayern Münih Taktik Analizi',
              ),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Analiz Detayları',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Flood Formatı',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary, 
                    fontWeight: FontWeight.w800
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: floodList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = floodList[index];
                return _buildDynamicFloodItem(item, index, floodList.length);
              },
            ),
            
            const SizedBox(height: 24),

            OutlinedButton.icon(
              onPressed: () => ref.read(floodNotifierProvider.notifier).addFloodItem(),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('Yeni Madde Ekle'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.5), width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget filledButtonOrTextButton(BuildContext context, List<FloodItem> list) {
     final theme = Theme.of(context);
     
     return Padding(
       padding: const EdgeInsets.only(right: 16.0),
       child: FilledButton.icon(
          onPressed: () async {
            if (_titleController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Lütfen bir başlık giriniz!')),
              );
              return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Analiz gönderiliyor...')),
            );

            try {
              final repo = AnalysisRepository();
              final currentUserId = Supabase.instance.client.auth.currentUser?.id;

              if (currentUserId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lütfen önce giriş yapın!')),
                );
                return;
              }

              await repo.submitAnalysisAsFlood(
                title: _titleController.text.trim(),
                userId: currentUserId,
                steps: list,
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Analiz başarıyla paylaşıldı!')),
                );
                Navigator.pop(context);
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Hata: $e')),
                );
              }
            }
          },
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.brightness == Brightness.dark ? theme.colorScheme.surface : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          label: const Text('Paylaş'),
          icon: const Icon(Icons.send_rounded, size: 16),
        ),
     );
  }

  Widget _buildDynamicFloodItem(FloodItem item, int index, int totalCount) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Madde ${index + 1}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (totalCount > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent),
                  onPressed: () => ref.read(floodNotifierProvider.notifier).removeFloodItem(item.id),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _getController(item.id, item.text),
            maxLines: null,
            minLines: 3,
            maxLength: 400,
            decoration: InputDecoration(
              hintText: 'Taktiksel detayınızı buraya yazın...',
              fillColor: theme.colorScheme.surface,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.5), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (item.imagePath != null)
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.insert_photo_rounded, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Görsel Eklendi (Simülasyon)',
                          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => ref.read(floodNotifierProvider.notifier).updateImage(item.id, null),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.close_rounded, size: 16),
                    ),
                  ),
                ),
              ],
            )
          else
            TextButton.icon(
              onPressed: () => _pickImage(item.id),
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
              label: const Text('Görsel / Taktik Tahtası Ekle'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
        ],
      ),
    );
  }
}
