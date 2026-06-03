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
  static const double cornerSize = 100;

  final Set<int> activePointers = {};
  final Set<int> activeCornerPointers = {};
  final Set<int> cornerTapCandidates = {};

  int cornerTapCount = 0;
  Timer? touchHoldTimer;
  Timer? cornerTapTimer;
  bool triggered = false;

  bool _isTopLeftCorner(Offset position) {
    return position.dx >= 0 &&
        position.dy >= 0 &&
        position.dx <= cornerSize &&
        position.dy <= cornerSize;
  }

  void trigger() {
    if (triggered) return;

    triggered = true;
    activePointers.clear();
    activeCornerPointers.clear();
    cornerTapCandidates.clear();
    cornerTapCount = 0;

    touchHoldTimer?.cancel();
    cornerTapTimer?.cancel();
    touchHoldTimer = null;
    cornerTapTimer = null;

    widget.onTriggered();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      triggered = false;
    });
  }

  void _startHoldTimerIfNeeded() {
    if (activeCornerPointers.length < requiredPointerCount) return;
    if (touchHoldTimer != null) return;

    touchHoldTimer = Timer(holdDuration, () {
      if (!mounted) return;

      if (activeCornerPointers.length >= requiredPointerCount) {
        trigger();
      }

      touchHoldTimer = null;
    });
  }

  void _cancelHoldTimerIfNeeded() {
    if (activeCornerPointers.length >= requiredPointerCount) return;

    touchHoldTimer?.cancel();
    touchHoldTimer = null;
  }

  void _registerCornerTap() {
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
      onPointerDown: (event) {
        activePointers.add(event.pointer);

        if (_isTopLeftCorner(event.localPosition)) {
          activeCornerPointers.add(event.pointer);
          cornerTapCandidates.add(event.pointer);
        }

        _startHoldTimerIfNeeded();
      },
      onPointerUp: (event) {
        final wasCornerTap = cornerTapCandidates.contains(event.pointer);

        activePointers.remove(event.pointer);
        activeCornerPointers.remove(event.pointer);
        cornerTapCandidates.remove(event.pointer);

        if (wasCornerTap && activePointers.isEmpty && !triggered) {
          _registerCornerTap();
        }

        _cancelHoldTimerIfNeeded();
      },
      onPointerCancel: (event) {
        activePointers.remove(event.pointer);
        activeCornerPointers.remove(event.pointer);
        cornerTapCandidates.remove(event.pointer);

        _cancelHoldTimerIfNeeded();
      },
      child: widget.child,
    );
  }
}