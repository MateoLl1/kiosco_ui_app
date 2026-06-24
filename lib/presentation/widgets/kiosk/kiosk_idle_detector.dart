import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/config/config.dart';

class KioskIdleDetector extends StatefulWidget {
  final Widget child;
  final Duration timeout;

  const KioskIdleDetector({
    super.key,
    required this.child,
    this.timeout = AppDurations.kioskIdle,
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
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    if (!Env.retornoAutomatico) return;
    _timer?.cancel();
    _timer = Timer(widget.timeout, _onIdle);
  }

  void _onIdle() {
    if (!mounted) return;
    context.go('/ingresar-ruc');
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
