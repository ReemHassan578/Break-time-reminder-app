import 'package:flutter_riverpod/flutter_riverpod.dart';

class BreakOccurrenceNotifier extends StateNotifier<int> {
  BreakOccurrenceNotifier() : super(5);

  void setBreakOccurrence(int value) {
    
    state = value;
  }
}


final breakOccurrenceProvider = StateNotifierProvider<BreakOccurrenceNotifier, int>(
  (ref) {
    return BreakOccurrenceNotifier();
  },
);
