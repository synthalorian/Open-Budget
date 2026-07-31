import 'package:flutter_test/flutter_test.dart';
import 'package:open_budget/core/domain/entities/budget.dart';

void main() {
  group('Budget', () {
    test('creates with required fields', () {
      final now = DateTime(2026, 1, 1);
      final b = Budget(
        id: 'b1',
        name: 'Monthly Food',
        amount: 500,
        period: BudgetPeriod.monthly,
        type: BudgetType.category,
        categoryId: 'food',
        startDate: now,
        createdAt: now,
      );
      expect(b.name, 'Monthly Food');
      expect(b.amount, 500);
      expect(b.period, BudgetPeriod.monthly);
      expect(b.type, BudgetType.category);
      expect(b.isActive, true);
    });

    test('BudgetPeriod enum has 4 values', () {
      expect(BudgetPeriod.values.length, 4);
      expect(BudgetPeriod.values, contains(BudgetPeriod.monthly));
      expect(BudgetPeriod.values, contains(BudgetPeriod.weekly));
      expect(BudgetPeriod.values, contains(BudgetPeriod.yearly));
      expect(BudgetPeriod.values, contains(BudgetPeriod.custom));
    });

    test('BudgetType enum has 3 values', () {
      expect(BudgetType.values.length, 3);
      expect(BudgetType.values, contains(BudgetType.category));
      expect(BudgetType.values, contains(BudgetType.total));
      expect(BudgetType.values, contains(BudgetType.savings));
    });

    test('copyWith works', () {
      final now = DateTime(2026, 1, 1);
      final b = Budget(
        id: 'b1',
        name: 'Original',
        amount: 500,
        period: BudgetPeriod.monthly,
        type: BudgetType.category,
        startDate: now,
        createdAt: now,
      );
      final updated = b.copyWith(amount: 600, name: 'Updated');
      expect(updated.amount, 600);
      expect(updated.name, 'Updated');
      expect(updated.id, 'b1');
    });

    test('JSON round-trip', () {
      final now = DateTime(2026, 1, 1);
      final b = Budget(
        id: 'b1',
        name: 'Test Budget',
        amount: 1000,
        period: BudgetPeriod.monthly,
        type: BudgetType.total,
        startDate: now,
        isActive: true,
        createdAt: now,
      );
      final json = b.toJson();
      final restored = Budget.fromJson(json);
      expect(restored.name, b.name);
      expect(restored.amount, b.amount);
      expect(restored.period, b.period);
      expect(restored.type, b.type);
      expect(restored.isActive, b.isActive);
    });

    test('JSON round-trip with categoryIds', () {
      final now = DateTime(2026, 1, 1);
      final b = Budget(
        id: 'b2',
        name: 'Multi-Category',
        amount: 2000,
        period: BudgetPeriod.monthly,
        type: BudgetType.total,
        startDate: now,
        categoryIds: const ['food', 'transport', 'entertainment'],
        createdAt: now,
      );
      final json = b.toJson();
      final restored = Budget.fromJson(json);
      expect(restored.categoryIds.length, 3);
      expect(restored.categoryIds, contains('food'));
    });

    test('Equatable comparison works', () {
      final now = DateTime(2026, 1, 1);
      final a = Budget(
        id: 'b1', name: 'Budget', amount: 500,
        period: BudgetPeriod.monthly, type: BudgetType.category,
        startDate: now, createdAt: now,
      );
      final b = Budget(
        id: 'b1', name: 'Budget', amount: 500,
        period: BudgetPeriod.monthly, type: BudgetType.category,
        startDate: now, createdAt: now,
      );
      expect(a, equals(b));
    });
  });
}
