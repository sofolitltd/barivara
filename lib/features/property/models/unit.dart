import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit.freezed.dart';
part 'unit.g.dart';



@freezed
abstract class RentConfig with _$RentConfig {
  const factory RentConfig({
    required int amount,
    required DateTime startDate,
    String? reason,
  }) = _RentConfig;

  factory RentConfig.fromJson(Map<String, dynamic> json) => _$RentConfigFromJson(json);
}

@freezed
abstract class DepositConfig with _$DepositConfig {
  const factory DepositConfig({
    required int amount,
    required DateTime startDate,
    String? reason,
  }) = _DepositConfig;

  factory DepositConfig.fromJson(Map<String, dynamic> json) => _$DepositConfigFromJson(json);
}

@freezed
abstract class Unit with _$Unit {
  const factory Unit({
    required String id,
    required String propertyId,
    required String unitNumber,
    required int baseRent,
    @Default(false) bool isOccupied,
    @Default({}) Map<String, int> defaultUtilities,
    @Default([]) List<RentConfig> rentHistory,
    @Default([]) List<DepositConfig> depositHistory,
    int? floorLevel,
    String? unitSize,
    String? unitType,
    int? securityDeposit,
    @Default('vacant') String status,
    @Default({}) Map<String, String> meters,
    String? imageUrl,
    String? videoUrl,
  }) = _Unit;

  const Unit._();

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  factory Unit.fromDocument(Map<String, dynamic> docData, String docId) {
    return Unit.fromJson(docData).copyWith(id: docId);
  }

  int get totalRent {
    int total = baseRent;
    defaultUtilities.forEach((_, value) => total += value);
    return total;
  }

  int getActiveRent(DateTime forDate) {
    if (rentHistory.isEmpty) return baseRent;
    
    final sortedHistory = [...rentHistory]..sort((a, b) => b.startDate.compareTo(a.startDate));
    for (final config in sortedHistory) {
      if (config.startDate.isBefore(forDate) || config.startDate.isAtSameMomentAs(forDate)) {
        return config.amount;
      }
    }
    return baseRent;
  }
}
