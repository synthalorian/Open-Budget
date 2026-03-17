import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
enum CategoryType {
  @HiveField(0)
  expense,
  @HiveField(1)
  income,
  @HiveField(2)
  both,
}

@HiveType(typeId: 2)
class Category extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String iconName;
  
  @HiveField(3)
  final int color;
  
  @HiveField(4)
  final CategoryType type;
  
  @HiveField(5)
  final double budgetLimit;
  
  @HiveField(6)
  final bool isSystem;
  
  @HiveField(7)
  final int sortOrder;
  
  @HiveField(8)
  final String? parentId;

  const Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.color,
    this.type = CategoryType.expense,
    this.budgetLimit = 0,
    this.isSystem = false,
    this.sortOrder = 0,
    this.parentId,
  });

  Category copyWith({
    String? id,
    String? name,
    String? iconName,
    int? color,
    CategoryType? type,
    double? budgetLimit,
    bool? isSystem,
    int? sortOrder,
    String? parentId,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
      type: type ?? this.type,
      budgetLimit: budgetLimit ?? this.budgetLimit,
      isSystem: isSystem ?? this.isSystem,
      sortOrder: sortOrder ?? this.sortOrder,
      parentId: parentId ?? this.parentId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'color': color,
      'type': type.name,
      'budgetLimit': budgetLimit,
      'isSystem': isSystem,
      'sortOrder': sortOrder,
      'parentId': parentId,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      iconName: json['iconName'],
      color: json['color'],
      type: CategoryType.values.byName(json['type']),
      budgetLimit: json['budgetLimit'],
      isSystem: json['isSystem'],
      sortOrder: json['sortOrder'],
      parentId: json['parentId'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        iconName,
        color,
        type,
        budgetLimit,
        isSystem,
        sortOrder,
        parentId,
      ];
}
