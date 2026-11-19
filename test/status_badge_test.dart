import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:status_badge_chip/status_badge_chip.dart';

Widget _app(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  test('each status has its own color', () {
    final colors = BadgeStatus.values.map(statusColor).toSet();
    expect(colors, hasLength(BadgeStatus.values.length));
  });

  testWidgets('soft badge uses the status color for text', (tester) async {
    await tester.pumpWidget(
        _app(const StatusBadge('Online', status: BadgeStatus.success)));
    final text = tester.widget<Text>(find.text('Online'));
    expect(text.style!.color, statusColor(BadgeStatus.success));
  });

  testWidgets('solid badge has white text', (tester) async {
    await tester.pumpWidget(_app(const StatusBadge(
      'Failed',
      status: BadgeStatus.error,
      variant: BadgeVariant.solid,
    )));
    expect(tester.widget<Text>(find.text('Failed')).style!.color, Colors.white);
  });

  testWidgets('icon replaces the dot', (tester) async {
    await tester.pumpWidget(
        _app(const StatusBadge('Done', dot: true, icon: Icons.check)));
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('semantics include the status', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
        _app(const StatusBadge('Late', status: BadgeStatus.warning)));
    expect(find.bySemanticsLabel('Late, warning'), findsOneWidget);
    handle.dispose();
  });
}
