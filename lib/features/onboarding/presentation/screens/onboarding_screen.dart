import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/animated_lottie_image_box.dart';
import '../widgets/get_started_filled_button.dart';
import '../widgets/text_quotes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20.h,
          children: [
            AnimatedLottieImageBox(),
            TextQuotes(),
            GetStartedFilledButton(),
          ],
        ),
      ),
    );
  }
}

