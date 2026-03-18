import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'recurring.g.dart';

@HiveType(typeId: 12)
class RecurringTransaction extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String categoryId;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final int dayOfMonth; // 1-31

  @HiveField(5)
  final bool isActive;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime? lastProcessed;

  const RecurringTransaction({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.description,
    required this.dayOfMonth,
    this.isActive = true,
    required this.createdAt,
    this.lastProcessed,
  });

  RecurringTransaction copyWith({
    String? id,
    double? amount,
    String? categoryId,
    String? description,
    int? dayOfMonth,
    bool? isActive,
    DateTime? lastProcessed
  }) {
    return RecurringTransaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      isActive: isActive ?? this.isActive,
      createdAt: this.createdAt,
      lastProcessed: lastProcessed ?? this.lastProcessed,
    );
  }

  @override
  List<Object?> get props => [
    id,
    amount,
    categoryId,
    description,
    dayOfMonth,
    isActive,
    createdAt,
    lastProcessed,
  ];
}
