import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/constants/app_constants.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required int amount,
    required DateTime paidAt,
    String? note,
    @Default([]) List<String> paidItems,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
}

@freezed
abstract class Invoice with _$Invoice {
  const factory Invoice({
    required String id,
    required String propertyId,
    required String unitId,
    required String monthYear,
    required int baseRent,
    @Default({}) Map<String, int> utilities,
    required int otherCharges,
    required int totalAmount,
    required String status,
    @Default([]) List<Payment> payments,
    String? renterName,
    String? renterId,
    DateTime? createdAt,
    DateTime? paidAt,
  }) = _Invoice;

  const Invoice._();

  DateTime? get dueDate {
    final parts = monthYear.split(' ');
    if (parts.length != 2) return null;
    final monthIdx = _monthNames.indexOf(parts[0]);
    if (monthIdx == -1) return null;
    final year = int.tryParse(parts[1]);
    if (year == null) return null;
    final dueMonth = monthIdx + 1 == 12 ? 1 : monthIdx + 2;
    final dueYear = monthIdx + 1 == 12 ? year + 1 : year;
    return DateTime(dueYear, dueMonth, 7);
  }

  String get displayStatus {
    if (paidAmount >= totalAmount) return 'paid';
    final dd = dueDate;
    if (dd != null && DateTime.now().isAfter(dd)) return 'due';
    return 'unpaid';
  }

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  factory Invoice.fromDocument(Map<String, dynamic> docData, String docId) {
    final data = Map<String, dynamic>.from(docData);
    data['id'] = docId;
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp)
          .toDate()
          .toIso8601String();
    }
    if (data['paidAt'] is Timestamp) {
      data['paidAt'] = (data['paidAt'] as Timestamp).toDate().toIso8601String();
    }
    return Invoice.fromJson(data);
  }

  int get paidAmount =>
      payments.fold(0, (total, p) => total + p.amount);

  int get remainingBalance =>
      totalAmount - paidAmount;

  List<String> get chargeNames {
    final names = <String>['Base Rent'];
    names.addAll(utilities.keys);
    if (otherCharges > 0) names.add('Other Charges');
    return names;
  }

  int chargeAmount(String name) {
    if (name == 'Base Rent') return baseRent;
    if (name == 'Other Charges') return otherCharges;
    return utilities[name] ?? 0;
  }

  bool isItemPaid(String name) {
    if (payments.isEmpty) return false;
    return payments.any(
      (p) => p.paidItems.contains(name) || p.paidItems.isEmpty,
    );
  }

  List<String> get unpaidItemNames =>
      chargeNames.where((n) => !isItemPaid(n)).toList();

  int get unpaidTotal =>
      unpaidItemNames.fold(0, (total, n) => total + chargeAmount(n));

  String toShareMessage() {
    final utilityText = utilities.entries
        .map((e) => '${e.key}: ৳${e.value}')
        .join(', ');

    return '''
Hello ${renterName ?? 'Tenant'},
Your invoice for $monthYear is ready.

Total Amount: ৳$totalAmount
Base Rent: ৳$baseRent
Utilities: $utilityText
Other Charges: ৳$otherCharges

Status: ${status.toUpperCase()}
Generated on: ${createdAt?.day ?? DateTime.now().day}/${createdAt?.month ?? DateTime.now().month}/${createdAt?.year ?? DateTime.now().year}

View/Download Invoice: ${AppConstants.invoiceLinkBase}/$id
''';
  }
}
