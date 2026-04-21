import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void dispose() {
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
    // BURADA GELECEKTE GERÇEK IMAGE_PICKER KULLANILACAK
    // Örnek kullanım:
    // final picker = ImagePicker();
    // final image = await picker.pickImage(source: ImageSource.gallery);
    // if (image != null) ref.read(floodNotifierProvider.notifier).updateImage(id, image.path);
    
    // ŞİMDİLİK SİMÜLASYON YAPIYORUZ
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sistem galerisi açılıyor (Simülasyon)')),
    );
    // Geçici olarak bir dummy path gönderiyoruz ki UI güncellensin:
    ref.read(floodNotifierProvider.notifier).updateImage(id, 'simulated_dummy_path_for_$id');
  }

  @override
  Widget build(BuildContext context) {
    final floodList = ref.watch(floodNotifierProvider);
    
    // Aktif olmayan controller'ları serbest bırak (silinen maddeler için)
    final currentIds = floodList.map((e) => e.id).toSet();
    _controllers.keys.where((id) => !currentIds.contains(id)).toList().forEach((id) {
       _controllers[id]?.dispose();
       _controllers.remove(id);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Analiz Yaz', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          filledButtonOrTextButton(context, floodList), 
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dinamik Madde Madde Flood Alanı
            const Text(
              'Analiz Detayları (Flood Formatı)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Okunabilirliği artırmak için analizini parçalara bölebilir ve her detaya uygun taktik görselleri ekleyebilirsin.',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 24),

            // TextFields Listesi (Riverpod State üzerinden çalışır)
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

            // Yeni Madde Ekle Butonu
            OutlinedButton.icon(
              onPressed: () => ref.read(floodNotifierProvider.notifier).addFloodItem(),
              icon: const Icon(Icons.add),
              label: const Text('Yeni Madde Ekle', style: TextStyle(fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget filledButtonOrTextButton(BuildContext context, List<FloodItem> list) {
     return Padding(
       padding: const EdgeInsets.only(right: 8.0),
       child: TextButton.icon(
          onPressed: () {
            // Örnek doğrulama veya api'ye gönderme (JSON olarak görebilelim diye logluyoruz)
            for(var item in list) {
              debugPrint("Flood ${item.id}: Text='${item.text}', Image=${item.imagePath}");
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Analiz yapay zeka denetimine gönderiliyor...')),
            );
            Navigator.pop(context);
          },
          label: const Text('Paylaş', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          icon: const Icon(Icons.send_rounded, size: 18),
        ),
     );
  }

  Widget _buildDynamicFloodItem(FloodItem item, int index, int totalCount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sola çizgi ve madde imi (Twitter thread efekti)
        Column(
          children: [
            const SizedBox(height: 20), // Hizalama
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            if (index < totalCount - 1)
              Container(
                width: 2,
                height: item.imagePath != null ? 240 : 130, // Alt item'ın boyutuna göre çizgi uzunluğu simülasyonu
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                   color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                   borderRadius: BorderRadius.circular(2)
                )
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Metin Kutusu, Görsel Ekle Butonu ve Görsel Gösterimi
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _getController(item.id, item.text),
                maxLines: null,
                minLines: 3,
                maxLength: 400, // PRD kuralı
                decoration: InputDecoration(
                  hintText: 'Taktiksel bir detayı açıkla...',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                  ),
                ),
              ),
              
              // O Maddeye Özel Resmimiz Varsa Gösterelim, Yoksa "Görsel Ekle" butonu gösterelim.
              const SizedBox(height: 6),
              if (item.imagePath != null)
                Stack(
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 48, color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                            const SizedBox(height: 4),
                            Text('Taktik Tahtası / Görsel', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary.withOpacity(0.6))),
                          ],
                        ),
                        // İleride File(item.imagePath!) ile gerçek resim gösterilebilir:
                        // Image.file(File(item.imagePath!), fit: BoxFit.cover, width: double.infinity),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 18,
                          icon: Icon(Icons.close, color: Theme.of(context).colorScheme.error),
                          onPressed: () => ref.read(floodNotifierProvider.notifier).updateImage(item.id, null),
                        ),
                      ),
                    )
                  ],
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => _pickImage(item.id),
                    icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
                    label: const Text('Görsel/Taktik Tahtası Ekle'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Silme Butonu (En az 1 tane kalmak kaydıyla)
        if (totalCount > 1)
          IconButton(
            padding: const EdgeInsets.only(top: 12),
            alignment: Alignment.topCenter,
            icon: Icon(Icons.remove_circle_outline, color: Theme.of(context).colorScheme.error.withOpacity(0.8)),
            onPressed: () => ref.read(floodNotifierProvider.notifier).removeFloodItem(item.id),
            tooltip: 'Bu maddeyi sil',
          ),
      ],
    );
  }
}
