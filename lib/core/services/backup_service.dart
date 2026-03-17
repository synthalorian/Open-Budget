import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../database/database_service.dart';
import 'encryption_service.dart';
import '../domain/entities/transaction.dart';
import '../domain/entities/budget.dart';
import '../domain/entities/category.dart';
import '../domain/entities/goal.dart';

class BackupService {
  static final BackupService _instance = BackupService._internal();
  factory BackupService() => _instance;
  BackupService._internal();

  final _db = DatabaseService();
  final _encryption = EncryptionService();

  Future<File> createEncryptedBackup() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupData = <String, dynamic>{
      'transactions': _db.transactions.values.map((e) => e.toJson()).toList(),
      'budgets': _db.budgets.values.map((e) => e.toJson()).toList(),
      'categories': _db.categories.values.map((e) => e.toJson()).toList(),
      'goals': _db.goals.values.map((e) => e.toJson()).toList(),
      'timestamp': DateTime.now().toIso8601String(),
      'version': '0.1.0',
    };

    final jsonString = jsonEncode(backupData);
    final encryptedString = _encryption.encryptData(jsonString);
    
    final file = File('${directory.path}/mainframe_uplink.bin');
    return await file.writeAsString(encryptedString);
  }

  Future<void> restoreFromBackup(File file) async {
    final encryptedString = await file.readAsString();
    final jsonString = _encryption.decryptData(encryptedString);
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    await _db.clearAllData();

    // Transactions
    final transactions = (data['transactions'] as List)
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList();
    for (final t in transactions) {
      await _db.transactions.put(t.id, t);
    }

    // Budgets
    final budgets = (data['budgets'] as List)
        .map((e) => Budget.fromJson(e as Map<String, dynamic>))
        .toList();
    for (final b in budgets) {
      await _db.budgets.put(b.id, b);
    }

    // Categories
    final categories = (data['categories'] as List)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
    for (final c in categories) {
      await _db.categories.put(c.id, c);
    }

    // Goals
    final goals = (data['goals'] as List)
        .map((e) => Goal.fromJson(e as Map<String, dynamic>))
        .toList();
    for (final g in goals) {
      await _db.goals.put(g.id, g);
    }
  }
}
