import 'package:flutter_test/flutter_test.dart';
import 'package:open_budget/core/domain/entities/recurring.dart';

void main() {
  group('RecurringTransaction', () {
    test('creates with required fields', () {
      final r = RecurringTransaction(
        id: 'r1',
        amount: 100.0,
        categoryId: 'food',
        description: 'Monthly Groceries',
        dayOfMonth: 1,
        createdAt: DateTime(2026, 1, 1),
      );
      expect(r.amount, 100.0);
      expect(r.description, 'Monthly Groceries');
      expect(r.dayOfMonth, 1);
      expect(r.isActive, true);
    });

    test('copyWith works', () {
      final r = RecurringTransaction(
        id: 'r1',
        amount: 100.0,
        categoryId: 'food',
        description: 'Groceries',
        dayOfMonth: 1,
        createdAt: DateTime(2026, 1, 1),
      );
      final updated = r.copyWith(
        amount: 150.0,
        dayOfMonth: 15,
        isActive: false,
      );
      expect(updated.amount, 150.0);
      expect(updated.dayOfMonth, 15);
      expect(updated.isActive, false);
      expect(updated.id, 'r1');
    });

    test('Equatable comparison works', () {
      final now = DateTime(2026, 1, 1);
      final a = RecurringTransaction(
        id: 'r1', amount: 100, categoryId: 'food',
        description: 'Test', dayOfMonth: 1, createdAt: now,
      );
      final b = RecurringTransaction(
        id: 'r1', amount: 100, categoryId: 'food',
        description: 'Test', dayOfMonth: 1, createdAt: now,
      );
      expect(a, equals(b));
    });
  });
}
