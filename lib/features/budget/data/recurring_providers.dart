import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/entities/recurring.dart';
import '../../../shared/providers/database_provider.dart';

final recurringTransactionsProvider = Provider<List<RecurringTransaction>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.recurring.values.toList()
    ..sort((a, b) => a.dayOfMonth.compareTo(b.dayOfMonth));
});

final recurringNotifierProvider = StateNotifierProvider<RecurringNotifier, AsyncValue<void>>((ref) {
  return RecurringNotifier(ref);
});

class RecurringNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  RecurringNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> addRecurring(RecurringTransaction recurring) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final db = ref.read(databaseProvider);
      await db.recurring.put(recurring.id, recurring);
      ref.invalidate(recurringTransactionsProvider);
    });
  }

  Future<void> deleteRecurring(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final db = ref.read(databaseProvider);
      await db.recurring.delete(id);
      ref.invalidate(recurringTransactionsProvider);
    });
  }

  Future<void> toggleActive(String id, bool isActive) async {
    final db = ref.read(databaseProvider);
    final existing = db.recurring.get(id);
    if (existing != null) {
      final updated = existing.copyWith(isActive: isActive);
      await db.recurring.put(id, updated);
      ref.invalidate(recurringTransactionsProvider);
    }
  }
}
