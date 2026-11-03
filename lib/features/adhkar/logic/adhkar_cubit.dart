import 'package:azkar/features/adhkar/data/adhkar_repository.dart';
import 'package:azkar/features/adhkar/models/adhkar_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AdhkarStatus { loading, loaded, error }

class AdhkarState {
  final AdhkarStatus status;
  final List<AdhkarCategory> categories;

  const AdhkarState({
    this.status = AdhkarStatus.loading,
    this.categories = const [],
  });

  List<AdhkarCategory> categoriesOf(AdhkarKind kind) =>
      categories.where((c) => c.kind == kind).toList();

  AdhkarCategory? categoryById(String id) {
    for (final c in categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// كل العناصر المطابقة لنص البحث (للبحث الشامل).
  List<AdhkarItem> searchItems(String q) {
    final t = q.trim();
    if (t.isEmpty) return const [];
    return categories
        .expand((c) => c.items)
        .where((i) =>
            i.text.contains(t) ||
            i.translation.contains(t) ||
            i.source.contains(t))
        .toList();
  }

  AdhkarState copyWith({
    AdhkarStatus? status,
    List<AdhkarCategory>? categories,
  }) {
    return AdhkarState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
    );
  }
}

class AdhkarCubit extends Cubit<AdhkarState> {
  final AdhkarRepository _repository;

  AdhkarCubit({AdhkarRepository repository = const AdhkarRepository()})
      : _repository = repository,
        super(const AdhkarState());

  Future<void> load() async {
    if (state.status == AdhkarStatus.loaded) return;
    try {
      final categories = await _repository.loadCategories();
      emit(state.copyWith(status: AdhkarStatus.loaded, categories: categories));
    } catch (_) {
      emit(state.copyWith(status: AdhkarStatus.error));
    }
  }
}
