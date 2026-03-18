// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurringTransactionAdapter extends TypeAdapter<RecurringTransaction> {
  @override
  final int typeId = 12;

  @override
  RecurringTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurringTransaction(
      id: fields[0] as String,
      amount: fields[1] as double,
      categoryId: fields[2] as String,
      description: fields[3] as String,
      dayOfMonth: fields[4] as int,
      isActive: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      lastProcessed: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RecurringTransaction obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.dayOfMonth)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.lastProcessed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
