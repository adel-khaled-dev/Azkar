import 'package:azkar/features/adhkar/models/adhkar_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// حالة عدّاد التسبيح داخل صفحة تفاصيل الذكر.
class DhikrCounterState {
  final List<AdhkarItem> items;
  final int currentIndex;
  final List<int> counts;

  const DhikrCounterState({
    this.items = const [],
    this.currentIndex = 0,
    this.counts = const [],
  });

  AdhkarItem? get current => items.isEmpty ? null : items[currentIndex];
  int get total => items.length;
  int get currentCount => current == null ? 0 : counts[currentIndex];

  bool get isCurrentDone =>
      current != null && currentCount >= current!.count;

  int get completedCount {
    var done = 0;
    for (var i = 0; i < items.length; i++) {
      if (counts[i] >= items[i].count) done++;
    }
    return done;
  }

  /// تقدم إجمالي مرجّح (0..1).
  double get progress {
    if (items.isEmpty) return 0;
    var sum = 0.0;
    for (var i = 0; i < items.length; i++) {
      final max = items[i].count;
      final c = counts[i];
      sum += max <= 0 ? 0 : (c / max).clamp(0.0, 1.0);
    }
    return sum / items.length;
  }

  DhikrCounterState copyWith({
    List<AdhkarItem>? items,
    int? currentIndex,
    List<int>? counts,
  }) {
    return DhikrCounterState(
      items: items ?? this.items,
      currentIndex: currentIndex ?? this.currentIndex,
      counts: counts ?? this.counts,
    );
  }
}

/// يدير منطق التنقّل والعدّ داخل قائمة أذكار.
class DhikrCounterCubit extends Cubit<DhikrCounterState> {
  DhikrCounterCubit() : super(const DhikrCounterState());

  void start(List<AdhkarItem> items, {int initialIndex = 0}) {
    final index = items.isEmpty
        ? 0
        : initialIndex.clamp(0, items.length - 1);
    emit(DhikrCounterState(
      items: items,
      currentIndex: index,
      counts: List<int>.filled(items.length, 0),
    ));
  }

  void increment() {
    if (state.current == null || state.isCurrentDone) return;
    final counts = List<int>.from(state.counts);
    counts[state.currentIndex]++;
    emit(state.copyWith(counts: counts));
  }

  void resetCurrent() {
    final counts = List<int>.from(state.counts);
    counts[state.currentIndex] = 0;
    emit(state.copyWith(counts: counts));
  }

  void goTo(int index) {
    if (index < 0 || index >= state.total) return;
    emit(state.copyWith(currentIndex: index));
  }

  void next() {
    if (state.currentIndex < state.total - 1) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  void previous() {
    if (state.currentIndex > 0) {
      emit(state.copyWith(currentIndex: state.currentIndex - 1));
    }
  }
}
