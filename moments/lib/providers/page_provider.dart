import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageNotifier extends StateNotifier<PageController?> {
  PageNotifier() : super(null);

  void setController(PageController controller) {
    state = controller;
  }
}

final pageProvider =
    StateNotifierProvider<PageNotifier, PageController?>((ref) {
  return PageNotifier();
});
