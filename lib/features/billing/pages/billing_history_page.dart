import 'package:flutter/material.dart';

import '../../../shared/widgets/responsive_layout.dart' show MaxWidthContainer;

class BillingHistoryPage extends StatelessWidget {
  final String propertyId;
  final String unitId;

  const BillingHistoryPage({
    super.key,
    required this.propertyId,
    required this.unitId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MaxWidthContainer(
          child: AppBar(title: const Text('Billing History')),
        ),
      ),
      body: const Center(child: Text('Billing History Coming Soon')),
    );
  }
}
