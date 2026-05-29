import 'dart:async';

import 'package:flutter/material.dart';

class HiddenAdminAccess extends StatefulWidget {
  final Widget child;
  final VoidCallback onTriggered;

  const HiddenAdminAccess({
    super.key,
    required this.child,
    required this.onTriggered,
  });

  @override
  State<HiddenAdminAccess> createState() => _HiddenAdminAccessState();
}

class _HiddenAdminAccessState extends State<HiddenAdminAccess> {
  static const int requiredPointerCount = 4;
  static const int requiredCornerTapCount = 5;
  static const Duration holdDuration = Duration(seconds: 3);
  static const Duration tapResetDuration = Duration(seconds: 2);

  int pointerCount = 0;
  int cornerTapCount = 0;
  Timer? touchHoldTimer;
  Timer? cornerTapTimer;
  bool triggered = false;

  void trigger() {
    if (triggered) return;

    triggered = true;
    pointerCount = 0;
    cornerTapCount = 0;

    touchHoldTimer?.cancel();
    cornerTapTimer?.cancel();

    widget.onTriggered();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      triggered = false;
    });
  }

  void _startHoldTimerIfNeeded() {
    if (pointerCount < requiredPointerCount || touchHoldTimer != null) return;

    touchHoldTimer = Timer(holdDuration, () {
      if (!mounted) return;

      if (pointerCount >= requiredPointerCount) {
        trigger();
      }

      touchHoldTimer = null;
    });
  }

  void _cancelHoldTimerIfNeeded() {
    if (pointerCount >= requiredPointerCount) return;

    touchHoldTimer?.cancel();
    touchHoldTimer = null;
  }

  void _handleCornerTap() {
    cornerTapCount++;

    cornerTapTimer?.cancel();
    cornerTapTimer = Timer(tapResetDuration, () {
      cornerTapCount = 0;
    });

    if (cornerTapCount >= requiredCornerTapCount) {
      trigger();
    }
  }

  @override
  void dispose() {
    touchHoldTimer?.cancel();
    cornerTapTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        pointerCount++;
        _startHoldTimerIfNeeded();
      },
      onPointerUp: (_) {
        pointerCount--;

        if (pointerCount < 0) {
          pointerCount = 0;
        }

        _cancelHoldTimerIfNeeded();
      },
      onPointerCancel: (_) {
        pointerCount = 0;
        touchHoldTimer?.cancel();
        touchHoldTimer = null;
      },
      child: Stack(
        children: [
          widget.child,
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _handleCornerTap,
              child: const SizedBox(
                width: 100,
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}