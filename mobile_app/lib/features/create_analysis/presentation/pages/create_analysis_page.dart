import 'dart:io';
import 'package:flutter/material.dart';

class CreateAnalysisPage extends StatefulWidget {
  const CreateAnalysisPage({super.key});

  @override
  State<CreateAnalysisPage> createState() => _CreateAnalysisPageState();
}

class _CreateAnalysisPageState extends State<CreateAnalysisPage> {
  // Analiz metinlerinin tutulacağı Controller listemiz
  final List<TextEditingController> _textControllers = [TextEditingController()];
  
  // Seçilen resmin dosya yolunu tutacak geçici state
  String? _selectedImagePath;

  @override
  void dispose() {
    // Hafıza sızıntılarını önlemek için controller'ları temizliyoruz
    for (var controller in _textControllers) {
      if (mounted) controller.dispose();
    }
    super.dispose();
  }

  void _addNewTextField() {
    setState(() {
      _textControllers.add(TextEditingController());
    });
  }

  void _removeTextField(int index) {
    if (_textControllers.length > 1) {
      setState(() {
        _textControllers[index].dispose();
        _textControllers.removeAt(index);
      });
    }
  }

  Future<void> _pickImage() async {
    // Burada ileride image_picker kütüphanesi kullanılacaktır
    // Örnek: final picker = ImagePicker(); final image = await picker.pickImage(source: ImageSource.gallery);
    // Şimdilik UI simülasyonu yapıyoruz.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sistem galerisi açılıyor (ImagePicker entegrasyonu simule edildi)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Analiz Yaz', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          TextButton(
            onPressed: () {
              // Yayınlama mantığı eklenecek
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Analiz yapay zeka denetimine gönderiliyor...')),
              );
              Navigator.pop(context);
            },
            child: const Text('Paylaş', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Resim Yükleme Alanı
            const Text(
              'Taktik Tahtası / Görsel (Opsiyonel)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kameradan veya Galeriden Seç',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Dinamik Madde Madde Flood Alanı
            const Text(
              'Analiz Detayları (Flood Formatı)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Okunabilirliği artırmak için lütfen analizini parçalara böl.',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // TextFields Listesi
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _textControllers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildDynamicTextField(index);
              },
            ),
            
            const SizedBox(height: 16),

            // Yeni Madde Ekle Butonu
            OutlinedButton.icon(
              onPressed: _addNewTextField,
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

  Widget _buildDynamicTextField(int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sola çizgi ve madde imi (Twitter thread efekti)
        Column(
          children: [
            const SizedBox(height: 16), // Padding for alignment
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            if (index < _textControllers.length - 1)
              Container(
                width: 2,
                height: 80, // Approximate height line
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Metin Kutusu
        Expanded(
          child: TextFormField(
            controller: _textControllers[index],
            maxLines: null,
            minLines: 3,
            maxLength: 400, // PRD kuralı: UI sınırlandırması
            decoration: InputDecoration(
              hintText: 'Taktiksel bir detayı açıkla...',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
            ),
          ),
        ),
        // Silme Butonu (En az 1 tane kalmak kaydıyla)
        if (_textControllers.length > 1)
          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: Theme.of(context).colorScheme.error),
            onPressed: () => _removeTextField(index),
            tooltip: 'Bu maddeyi sil',
          ),
      ],
    );
  }
}
