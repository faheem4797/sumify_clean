import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/theme/app_pallete.dart';
import 'package:sumify_clean/routing/app_route_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final CarouselController carouselController = CarouselController();

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppPallete.kWhiteColor,
          image: DecorationImage(
            image: AssetImage(Constants.splashBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(fit: StackFit.expand, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 30.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: AppPallete.kDarkerTealColor, fontSize: 16.sp)),
                ),
                Text(
                  'Sumify',
                  style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 40.sp),
                  ),
                ),
                CarouselSlider(
                  items: Constants.imageList
                      .map(
                        (item) => Image.asset(
                          item['image_path'],
                          //fit: BoxFit.fitWidth,
                          //width: double.infinity,
                          // height: item['id'] == 0 ? 403.h : 324.h,
                          // width: item['id'] == 0 ? 355.w : 314.w,
                        ),
                      )
                      .toList(),
                  carouselController: carouselController,
                  options: CarouselOptions(
                    height: 410.h,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: Constants.imageList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => carouselController.animateToPage(entry.key),
                      child: Container(
                        width: 12.w,
                        height: 12.h,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 4.w),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? AppPallete.kWhiteColor
                                        : AppPallete.kBlackColor)
                                    .withOpacity(
                                        currentIndex == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -75.h,
            right: -75.w,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(45 / 360),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(87.r),
                  ),
                ),
                height: 250.h,
                width: 250.w,
              ),
            ),
          ),
          Positioned(
            bottom: -65.h,
            right: -65.w,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(45 / 360),
              child: GestureDetector(
                onTap: () {
                  currentIndex == 0
                      ? carouselController.animateToPage(1)
                      : print('a');
                  context.pushNamed(AppRouteConstants.signupRoute);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: AppPallete.kDarkTealColor,
                      borderRadius: BorderRadius.all(Radius.circular(80.r))),
                  height: 230.h,
                  width: 230.w,
                  child: Center(
                      child: RotationTransition(
                          turns: const AlwaysStoppedAnimation(-45 / 360),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 45.h, right: 30.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Next  ',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: AppPallete.kWhiteColor,
                                        fontSize: 22.sp),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: AppPallete.kWhiteColor,
                                )
                              ],
                            ),
                          ))),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
