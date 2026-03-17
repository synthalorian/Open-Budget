import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/entities/category.dart';
import '../../../shared/providers/database_provider.dart';
import 'package:uuid/uuid.dart';

final categoriesProvider = Provider<List<Category>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.categories.values.toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
});

final categoryNotifierProvider = StateNotifierProvider<CategoryNotifier, AsyncValue<void>>((ref) {
  return CategoryNotifier(ref);
});

class CategoryNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  CategoryNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> createCategory({
    required String name,
    required String iconName,
    required int color,
    CategoryType type = CategoryType.expense,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final db = ref.read(databaseProvider);
      final category = Category(
        id: 'user_${const Uuid().v4()}',
        name: name,
        iconName: iconName,
        color: color,
        type: type,
        isSystem: false,
        sortOrder: db.categories.length,
      );
      await db.categories.put(category.id, category);
      ref.invalidate(categoriesProvider);
    });
  }

  Future<void> updateCategory(Category category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final db = ref.read(databaseProvider);
      await db.categories.put(category.id, category);
      ref.invalidate(categoriesProvider);
    });
  }

  Future<void> deleteCategory(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final db = ref.read(databaseProvider);
      await db.categories.delete(id);
      ref.invalidate(categoriesProvider);
    });
  }
}
