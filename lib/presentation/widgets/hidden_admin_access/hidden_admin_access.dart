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
      triggered = false;
    });
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

        if (pointerCount >= 3 && touchHoldTimer == null) {
          touchHoldTimer = Timer(const Duration(seconds: 3), () {
            if (!mounted) return;

            if (pointerCount >= 3) {
              trigger();
            }

            touchHoldTimer = null;
          });
        }
      },
      onPointerUp: (_) {
        pointerCount--;

        if (pointerCount < 0) {
          pointerCount = 0;
        }

        if (pointerCount < 3) {
          touchHoldTimer?.cancel();
          touchHoldTimer = null;
        }
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
            right: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                cornerTapCount++;

                cornerTapTimer?.cancel();
                cornerTapTimer = Timer(const Duration(seconds: 2), () {
                  cornerTapCount = 0;
                });

                if (cornerTapCount >= 5) {
                  trigger();
                }
              },
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