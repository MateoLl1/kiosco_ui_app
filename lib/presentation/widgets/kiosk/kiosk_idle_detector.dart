import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/config/config.dart';

class KioskIdleDetector extends StatefulWidget {
  final Widget child;
  final Duration timeout;
  final bool paused;

  const KioskIdleDetector({
    super.key,
    required this.child,
    this.timeout = AppDurations.kioskIdle,
    this.paused = false,
  });

  @override
  State<KioskIdleDetector> createState() => _KioskIdleDetectorState();
}

class _KioskIdleDetectorState extends State<KioskIdleDetector> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void didUpdateWidget(KioskIdleDetector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.paused != oldWidget.paused) {
      if (widget.paused) {
        _timer?.cancel();
      } else {
        _resetTimer();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    if (!Env.retornoAutomatico || widget.paused) return;
    _timer?.cancel();
    _timer = Timer(widget.timeout, _onIdle);
  }

  void _onIdle() {
    if (!mounted) return;
    context.go('/seleccionar-metodo');
  }

  @override
  Widget build(BuildContext context) {
    if (!Env.retornoAutomatico) return widget.child;

    return Listener(
      onPointerDown: (_) => _resetTimer(),
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}
