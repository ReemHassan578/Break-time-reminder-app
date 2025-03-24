import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../manager/timer_provider.dart';

class SetBreakTimeButton extends ConsumerWidget {
  const SetBreakTimeButton({super.key,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  ElevatedButton(
                    onPressed: () {
                     ref.read(timerProvider.notifier).setBreakTime();
                    },
                    child: Text('set break time'));
  }
}