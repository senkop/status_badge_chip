import 'package:flutter/material.dart';
import 'package:status_badge_chip/status_badge_chip.dart';

void main() => runApp(const MaterialApp(home: DemoPage()));

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('status_badge_chip')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          for (final variant in BadgeVariant.values) ...[
            Text(variant.name),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              StatusBadge('Online',
                  status: BadgeStatus.success,
                  variant: variant,
                  dot: true,
                  pulse: true),
              StatusBadge('Pending',
                  status: BadgeStatus.warning, variant: variant),
              StatusBadge('Offline',
                  status: BadgeStatus.error, variant: variant, dot: true),
              StatusBadge('In transit',
                  status: BadgeStatus.info,
                  variant: variant,
                  icon: Icons.local_shipping),
              StatusBadge('Draft', variant: variant),
            ]),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}
