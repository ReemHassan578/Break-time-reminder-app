import 'package:google_fonts/google_fonts.dart';

import '../theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextStyles {
  static TextStyle font20BlackRegularPlayFairFont = GoogleFonts.playfairDisplay(
    fontSize: 20.sp,
    color: Colors.black,
    fontWeight: FontWeight.normal,
  );
  static TextStyle font25BlackBoldPacificoFont = GoogleFonts.pacifico(
    fontSize: 25.sp,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );


  static TextStyle font14WhiteBold = TextStyle(
    fontSize: 14.sp,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );  
}
