import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloodItem {
  final String id;
  final String text;
  final String? imagePath;

  FloodItem({
    required this.id,
    this.text = '',
    this.imagePath,
  });

  FloodItem copyWith({
    String? id,
    String? text,
    String? imagePath,
    bool clearImage = false, // Görseli silmek için kullanıyoruz
  }) {
    return FloodItem(
      id: id ?? this.id,
      text: text ?? this.text,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
    );
  }
}

class FloodNotifier extends AutoDisposeNotifier<List<FloodItem>> {
  @override
  List<FloodItem> build() {
    // İlk açıldığında 1 adet boş flood item olsun
    return [FloodItem(id: UniqueKey().toString())];
  }

  void addFloodItem() {
    state = [...state, FloodItem(id: UniqueKey().toString())];
  }

  void removeFloodItem(String id) {
    if (state.length <= 1) return; // En az 1 tane kalmalı
    state = state.where((item) => item.id != id).toList();
  }

  void updateText(String id, String text) {
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(text: text);
      }
      return item;
    }).toList();
  }

  void updateImage(String id, String? imagePath) {
    state = state.map((item) {
      if (item.id == id) {
        if (imagePath == null) {
          return item.copyWith(clearImage: true);
        }
        return item.copyWith(imagePath: imagePath);
      }
      return item;
    }).toList();
  }
}

// Riverpod Provider tanımımız
final floodNotifierProvider =
    AutoDisposeNotifierProvider<FloodNotifier, List<FloodItem>>(() {
  return FloodNotifier();
});
