import 'package:flutter/material.dart';

/// The meaning of a badge, which sets its color.
enum BadgeStatus {
  /// Green: done, active, online.
  success,

  /// Amber: pending, attention.
  warning,

  /// Red: failed, offline, overdue.
  error,

  /// Blue: informational, in progress.
  info,

  /// Grey: draft, inactive.
  neutral,
}

/// How a badge is drawn.
enum BadgeVariant {
  /// Light tinted background with colored text.
  soft,

  /// Colored border with colored text.
  outlined,

  /// Solid background with white text.
  solid,
}

/// The default color for each status.
Color statusColor(BadgeStatus status) => switch (status) {
      BadgeStatus.success => const Color(0xFF12A150),
      BadgeStatus.warning => const Color(0xFFD97706),
      BadgeStatus.error => const Color(0xFFDC2626),
      BadgeStatus.info => const Color(0xFF2563EB),
      BadgeStatus.neutral => const Color(0xFF6B7280),
    };

/// A small rounded label showing a status, like "Active" or "Overdue".
///
/// ```dart
/// StatusBadge('Online', status: BadgeStatus.success, dot: true)
/// ```
class StatusBadge extends StatelessWidget {
  /// Creates a badge.
  const StatusBadge(
    this.label, {
    super.key,
    this.status = BadgeStatus.neutral,
    this.variant = BadgeVariant.soft,
    this.dot = false,
    this.pulse = false,
    this.icon,
    this.color,
    this.dense = false,
  });

  /// The text.
  final String label;

  /// The meaning, which sets the color.
  final BadgeStatus status;

  /// Soft, outlined or solid.
  final BadgeVariant variant;

  /// Whether to show a small dot before the label.
  final bool dot;

  /// Whether the dot gently pulses (for "live" states).
  final bool pulse;

  /// Optional leading icon (replaces the dot).
  final IconData? icon;

  /// Overrides the status color.
  final Color? color;

  /// Smaller padding and text.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final c = color ?? statusColor(status);
    final solid = variant == BadgeVariant.solid;
    final fg = solid ? Colors.white : c;
    final bg = switch (variant) {
      BadgeVariant.soft => c.withAlpha(30),
      BadgeVariant.outlined => Colors.transparent,
      BadgeVariant.solid => c,
    };
    final fontSize = dense ? 11.0 : 12.5;

    Widget? lead;
    if (icon != null) {
      lead = Icon(icon, size: fontSize + 3, color: fg);
    } else if (dot) {
      final d = Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
      );
      lead = pulse ? _Pulse(child: d) : d;
    }

    return Semantics(
      label: '$label, ${status.name}',
      excludeSemantics: true,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 7 : 10,
          vertical: dense ? 2 : 4,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: variant == BadgeVariant.outlined
              ? Border.all(color: c.withAlpha(140))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (lead != null) ...[lead, SizedBox(width: dense ? 4 : 6)],
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pulse extends StatefulWidget {
  const _Pulse({required this.child});

  final Widget child;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: Tween(begin: 0.35, end: 1.0).animate(_c),
        child: widget.child,
      );
}
