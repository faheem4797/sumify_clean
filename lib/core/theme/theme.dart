import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sumify_clean/core/theme/app_pallete.dart';

class AppTheme {
  static _border(
          [Color color = AppPallete.kTransparentColor, double width = 1]) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: width,
        ),
        borderRadius: BorderRadius.circular(10.r),
      );
  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.kWhiteColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppPallete.kDarkTealColor,
    ),
    textTheme: GoogleFonts.nunitoTextTheme(),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.kWhiteColor,
    ),
    // textSelectionTheme: const TextSelectionThemeData(
    //   cursorColor: AppPallete.gradient1,
    //   selectionHandleColor: AppPallete.gradient1,
    // ),
    // chipTheme: ChipThemeData(
    //   showCheckmark: false,
    //   selectedColor: AppPallete.gradient1,
    //   backgroundColor: AppPallete.lightGreyColor,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(5.0),
    //     side: const BorderSide(color: AppPallete.borderColor, width: 0.3),
    //   ),
    // ),

    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: AppPallete.kWhiteColor,
      // contentPadding: const EdgeInsets.all(24),
      border: _border(),
      enabledBorder: _border(
        AppPallete.kDarkTealColor,
      ),
      focusedBorder: _border(AppPallete.kDarkTealColor, 2),
      errorBorder: _border(AppPallete.kErrorColor),
      hintStyle: const TextStyle(color: AppPallete.kGreyColor),
      suffixIconColor: AppPallete.kGreyColor,
    ),
  );
}
