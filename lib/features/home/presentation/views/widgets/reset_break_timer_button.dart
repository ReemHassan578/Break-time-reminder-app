import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../manager/timer_provider.dart';

class ResetBreakTimerButton extends ConsumerWidget {
  const ResetBreakTimerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  ElevatedButton(
                    onPressed: () {
                     ref.read(timerProvider.notifier).resetBreakTime();
                    },
                    child: Text('reset'));
  }
}