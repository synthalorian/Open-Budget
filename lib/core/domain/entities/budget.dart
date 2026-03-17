import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'budget.g.dart';

@HiveType(typeId: 3)
enum BudgetPeriod {
  @HiveField(0)
  weekly,
  @HiveField(1)
  monthly,
  @HiveField(2)
  yearly,
  @HiveField(3)
  custom,
}

@HiveType(typeId: 4)
enum BudgetType {
  @HiveField(0)
  category, // Per-category envelope
  @HiveField(1)
  total, // Overall budget
  @HiveField(2)
  savings, // Savings goal
}

@HiveType(typeId: 5)
class Budget extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final double amount;
  
  @HiveField(3)
  final BudgetPeriod period;
  
  @HiveField(4)
  final BudgetType type;
  
  @HiveField(5)
  final String? categoryId;
  
  @HiveField(6)
  final bool carryOverUnused;
  
  @HiveField(7)
  final DateTime startDate;
  
  @HiveField(8)
  final int? customPeriodDays;
  
  @HiveField(9)
  final List<String> categoryIds;
  
  @HiveField(10)
  final bool isActive;
  
  @HiveField(11)
  final DateTime createdAt;

  const Budget({
    required this.id,
    required this.name,
    required this.amount,
    required this.period,
    required this.type,
    this.categoryId,
    this.carryOverUnused = true,
    required this.startDate,
    this.customPeriodDays,
    this.categoryIds = const [],
    this.isActive = true,
    required this.createdAt,
  });

  Budget copyWith({
    String? id,
    String? name,
    double? amount,
    BudgetPeriod? period,
    BudgetType? type,
    String? categoryId,
    bool? carryOverUnused,
    DateTime? startDate,
    int? customPeriodDays,
    List<String>? categoryIds,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Budget(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      period: period ?? this.period,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      carryOverUnused: carryOverUnused ?? this.carryOverUnused,
      startDate: startDate ?? this.startDate,
      customPeriodDays: customPeriodDays ?? this.customPeriodDays,
      categoryIds: categoryIds ?? this.categoryIds,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'period': period.name,
      'type': type.name,
      'categoryId': categoryId,
      'carryOverUnused': carryOverUnused,
      'startDate': startDate.toIso8601String(),
      'customPeriodDays': customPeriodDays,
      'categoryIds': categoryIds,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      period: BudgetPeriod.values.byName(json['period']),
      type: BudgetType.values.byName(json['type']),
      categoryId: json['categoryId'],
      carryOverUnused: json['carryOverUnused'],
      startDate: DateTime.parse(json['startDate']),
      customPeriodDays: json['customPeriodDays'],
      categoryIds: List<String>.from(json['categoryIds'] ?? []),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        amount,
        period,
        type,
        categoryId,
        carryOverUnused,
        startDate,
        customPeriodDays,
        categoryIds,
        isActive,
        createdAt,
      ];
}
