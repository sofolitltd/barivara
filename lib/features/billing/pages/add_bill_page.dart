import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:barivara/features/billing/models/invoice.dart';
import '/features/renters/repositories/renter_repository.dart';
import '/shared/widgets/responsive_layout.dart';
import '/shared/providers/home_providers.dart';
import '/features/auth/providers/auth_providers.dart';
import '/shared/services/sms_service.dart';
import 'package:share_plus/share_plus.dart';

class AddBillPage extends ConsumerStatefulWidget {
  final String propertyId;
  final String unitId;
  final String? initialInvoiceId;
  final Invoice? initialInvoice;

  const AddBillPage({
    super.key,
    required this.propertyId,
    required this.unitId,
    this.initialInvoiceId,
    this.initialInvoice,
  });

  @override
  ConsumerState<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends ConsumerState<AddBillPage> {
  final _formKey = GlobalKey<FormState>();
  final _baseRentController = TextEditingController();

  final List<UtilityEntry> _utilities = [];
  bool _initializedFromUnit = false;

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  bool _isSubmitting = false;
  bool _sendSms = false;

  final _utilityTypes = [
    'Electricity',
    'Gas',
    'Water',
    'Internet',
    'Security',
    'Parking',
    'Service',
    'Other',
  ];

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  int get _total {
    int total = _parse(_baseRentController.text);
    for (var u in _utilities) {
      total += _parse(u.valueController.text);
    }
    return total;
  }

  int _parse(String v) => int.tryParse(v) ?? 0;

  @override
  void dispose() {
    _baseRentController.dispose();
    for (var u in _utilities) {
      u.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final renterRepo = ref.read(renterRepositoryProvider);
      final monthYear = '${_months[_selectedMonth - 1]} $_selectedYear';

      final utilitiesMap = <String, int>{};
      for (var u in _utilities) {
        final name = u.isCustom
            ? u.customController.text.trim()
            : u.name;
        if (name.isNotEmpty) {
          utilitiesMap[name] = _parse(u.valueController.text);
        }
      }

      final isNewInvoice =
          widget.initialInvoice == null && widget.initialInvoiceId == null;

      final invoice = Invoice(
        id: widget.initialInvoice?.id ?? widget.initialInvoiceId ?? '',
        propertyId: widget.propertyId,
        unitId: widget.unitId,
        monthYear: monthYear,
        baseRent: _parse(_baseRentController.text),
        utilities: utilitiesMap,
        otherCharges: 0,
        totalAmount: _total,
        status: widget.initialInvoice?.status ?? 'unpaid',
        payments: isNewInvoice || widget.initialInvoice?.status == 'unpaid'
            ? []
            : widget.initialInvoice?.payments ?? [],
        renterName: widget.initialInvoice?.renterName,
        renterId: widget.initialInvoice?.renterId,
        createdAt: widget.initialInvoice?.createdAt,
        paidAt: widget.initialInvoice?.paidAt,
      );

      Invoice savedInvoice;
      if (widget.initialInvoice != null || widget.initialInvoiceId != null) {
        await renterRepo.updateInvoice(invoice);
        savedInvoice = invoice;
      } else {
        savedInvoice = await renterRepo.addInvoice(widget.propertyId, widget.unitId, invoice);
      }

      String? smsError;
      if (_sendSms && savedInvoice.renterId != null) {
        debugPrint('[SMS] sending reminder: renterId=${savedInvoice.renterId}, invoiceId=${savedInvoice.id}');
        smsError = await SmsService.sendReminder(savedInvoice.renterId!, savedInvoice.id);
        debugPrint('[SMS] result: $smsError');
      } else {
        debugPrint('[SMS] skipped: _sendSms=$_sendSms, renterId=${savedInvoice.renterId}');
      }

      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        context.pop();
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: Row(
              children: [
                Expanded(
                  child: Text(
                    smsError != null
                        ? 'Bill saved, but SMS failed: $smsError'
                        : 'Bill generated successfully!',
                  ),
                ),
                GestureDetector(
                  onTap: () => messenger.hideCurrentSnackBar(),
                  child: const Icon(Icons.close, size: 20, color: Colors.white70),
                ),
              ],
            ),
            backgroundColor: smsError != null ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Share',
              textColor: Colors.white,
              onPressed: () => _shareInvoice(savedInvoice),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 5),
            content: Text('Error: $e'),
            action: SnackBarAction(
              label: '✕',
              textColor: Colors.white,
              onPressed: () => messenger.hideCurrentSnackBar(),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _shareInvoice(Invoice invoice) {
    SharePlus.instance.share(ShareParams(text: invoice.toShareMessage()));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final unitsAsync = ref.watch(unitsStreamProvider(widget.propertyId));

    return unitsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (units) {
        final unit = units.firstWhere((f) => f.id == widget.unitId);

        if (!_initializedFromUnit) {
          // If we have an ID but no object (web refresh), we should show a loading state 
          // or fetch it. For now, let's assume the build method handles the async check
          // if we refactor it slightly, but to keep it simple and compatible with 
          // current stateful logic, we'll use the watch on the provider.
          
          final Invoice? inv = widget.initialInvoice ?? 
              (widget.initialInvoiceId != null ? ref.watch(invoiceFutureProvider(widget.initialInvoiceId!)).value : null);

          if (inv != null) {
            _baseRentController.text = inv.baseRent.toString();

            // Extract month and year from monthYear string (e.g. "January 2024")
            final parts = inv.monthYear.split(' ');
            if (parts.length == 2) {
              final mIndex = _months.indexOf(parts[0]);
              if (mIndex != -1) _selectedMonth = mIndex + 1;
              _selectedYear = int.tryParse(parts[1]) ?? _selectedYear;
            }

            _utilities.clear();
            for (var entry in inv.utilities.entries) {
              final isCustom = !_utilityTypes.contains(entry.key);
              _utilities.add(
                UtilityEntry(
                  name: isCustom ? '' : entry.key,
                  value: entry.value.toString(),
                  isCustom: isCustom,
                ),
              );
              if (isCustom) {
                _utilities.last.customController.text = entry.key;
              }
            }
          } else {
            final targetDate = DateTime(_selectedYear, _selectedMonth);
            _baseRentController.text = unit
                .getActiveRent(targetDate)
                .toString();

            for (var entry in unit.defaultUtilities.entries) {
              final isCustom = !_utilityTypes.contains(entry.key);
              _utilities.add(
                UtilityEntry(
                  name: isCustom ? '' : entry.key,
                  value: entry.value.toString(),
                  isCustom: isCustom,
                ),
              );
              if (isCustom) {
                _utilities.last.customController.text = entry.key;
              }
            }
          }
          _initializedFromUnit = true;
        }

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: MaxWidthContainer(
              child: AppBar(
                title: Text(
                  (widget.initialInvoice != null || widget.initialInvoiceId != null) ? 'Edit Bill' : 'Generate Bill',
                ),
              ),
            ),
          ),
          body: MaxWidthContainer(
            maxWidth: 800,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly Invoice',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Generate a bill for your tenant.',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // --- BILLING PERIOD ---
                      _sectionLabel('Billing Period'),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildDropdown(
                              label: 'Month',
                              value: _selectedMonth,
                              items: List.generate(
                                12,
                                (i) => DropdownMenuItem(
                                  value: i + 1,
                                  child: Text(_months[i]),
                                ),
                              ),
                              onChanged: (v) {
                                setState(() {
                                  _selectedMonth = v!;
                                  final targetDate = DateTime(
                                    _selectedYear,
                                    _selectedMonth,
                                  );
                                  _baseRentController.text = unit
                                      .getActiveRent(targetDate)
                                      .toString();
                                });
                              },
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown(
                              label: 'Year',
                              value: _selectedYear,
                              items: List.generate(10, (i) {
                                final y = DateTime.now().year - 5 + i;
                                return DropdownMenuItem(
                                  value: y,
                                  child: Text('$y'),
                                );
                              }),
                              onChanged: (v) {
                                setState(() {
                                  _selectedYear = v!;
                                  final targetDate = DateTime(
                                    _selectedYear,
                                    _selectedMonth,
                                  );
                                  _baseRentController.text = unit
                                      .getActiveRent(targetDate)
                                      .toString();
                                });
                              },
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // --- CHARGES ---
                      _sectionLabel('Charges'),
                      _buildField(
                        label: 'Base Rent (৳)',
                        controller: _baseRentController,
                        prefixIcon: const Icon(Icons.home_outlined, size: 20),
                        hint: 'e.g. 15000',
                        validator: (v) {
                          if (v!.isEmpty) return 'Required';
                          if (int.tryParse(v) == null) return 'Numbers only';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ..._utilities.asMap().entries.map((entry) {
                        final index = entry.key;
                        final utility = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                flex: 2,
                                child: utility.isCustom
                                    ? _buildField(
                                        label: index == 0
                                            ? 'Utility Name'
                                            : '',
                                        controller: utility.customController,
                                        prefixIcon: const Icon(
                                          Icons.receipt_long,
                                          size: 20,
                                        ),
                                        hint: 'Enter utility name',
                                      )
                                    : _buildDropdown(
                                        label: index == 0
                                            ? 'Utility Name'
                                            : '',
                                        value: utility.name.isEmpty
                                            ? null
                                            : utility.name,
                                        items: _utilityTypes
                                            .map(
                                              (t) => DropdownMenuItem(
                                                value: t,
                                                child: Text(t),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (v) {
                                          if (v == 'Other') {
                                            setState(() {
                                              utility.name = '';
                                              utility.isCustom = true;
                                            });
                                          } else if (v != null) {
                                            setState(
                                              () => utility.name = v,
                                            );
                                          }
                                        },
                                        isDark: isDark,
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: _buildField(
                                  label: index == 0 ? 'Amount (৳)' : '',
                                  controller: utility.valueController,
                                  hint: '0',
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(() {
                                  utility.dispose();
                                  _utilities.removeAt(index);
                                }),
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                padding: const EdgeInsets.only(bottom: 12),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () => setState(
                          () => _utilities.add(UtilityEntry(name: '')),
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Utility Charge'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),



                      // --- TOTAL SUMMARY ---
                      _buildTotalSummary(isDark),
                      const SizedBox(height: 32),

                      _buildSmsCheckbox(isDark),
                      const SizedBox(height: 32),

                      Center(
                        child: SizedBox(
                          width: ResponsiveLayout.isDesktop(context)
                              ? 300
                              : double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isSubmitting
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Generate Invoice',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSmsCheckbox(bool isDark) {
    final currentUser = ref.watch(currentUserProvider);
    final isPro = currentUser.asData?.value?.plan == 'pro';

    if (!isPro) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.sms, color: _sendSms ? const Color(0xFF6366F1) : Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Send SMS Reminder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(
                  'Notify renter via SMS about this bill',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Switch(
            value: _sendSms,
            activeThumbColor: const Color(0xFF6366F1),
            onChanged: (v) => setState(() => _sendSms = v),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSummary(bool isDark) {
    final controllers = [
      _baseRentController,
      ..._utilities.map((u) => u.valueController),
    ];
    return AnimatedBuilder(
      animation: Listenable.merge(controllers),
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF6366F1).withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                '৳ $_total',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF6366F1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6366F1),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    Widget? prefixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          validator: validator,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class UtilityEntry {
  String name;
  bool isCustom;
  final TextEditingController valueController;
  final TextEditingController customController;

  UtilityEntry({required this.name, String value = '0', this.isCustom = false})
    : valueController = TextEditingController(text: value),
      customController = TextEditingController(text: isCustom ? name : '');

  void dispose() {
    valueController.dispose();
    customController.dispose();
  }
}
