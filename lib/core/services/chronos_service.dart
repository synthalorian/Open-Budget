import '../database/database_service.dart';
import '../domain/entities/transaction.dart';
import '../domain/entities/recurring.dart';
import 'package:uuid/uuid.dart';

class ChronosService {
  static final ChronosService _instance = ChronosService._internal();
  factory ChronosService() => _instance;
  ChronosService._internal();

  final DatabaseService _db = DatabaseService();

  Future<void> processRecurringTransactions() async {
    final now = DateTime.now();
    final today = now.day;
    
    final recurring = _db.recurring.values
      .where((r) => r.isActive && r.dayOfMonth == today)
      .toList();
    
    for (final r in recurring) {
      final shouldProcess = r.lastProcessed == null || 
          (r.lastProcessed!.month != now.month || r.lastProcessed!.year != now.year);
      
      if (!shouldProcess) continue;

      // Create transaction
      final transaction = Transaction(
        id: const Uuid().v4(),
        amount: r.amount,
        categoryId: r.categoryId,
        description: r.description,
        date: now,
        isIncome: false,
        isRecurring: true,
        recurringId: r.id,
        createdAt: now,
      );
      
      await _db.transactions.put(transaction.id, transaction);
      
      // Update last processed
      final updated = r.copyWith(lastProcessed: now);
      await _db.recurring.put(r.id, updated);
    }
  }

  Future<void> addRecurringTransaction(RecurringTransaction recurring) async {
    await _db.recurring.put(recurring.id, recurring);
  }

  Future<void> deleteRecurringTransaction(String id) async {
    await _db.recurring.delete(id);
  }

  Future<void> toggleRecurring(String id, bool isActive) async {
    final recurring = _db.recurring.get(id);
    if (recurring != null) {
      final updated = recurring.copyWith(isActive: isActive);
      await _db.recurring.put(id, updated);
    }
  }
}
