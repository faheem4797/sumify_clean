import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sumify_clean/core/theme/app_pallete.dart';
import 'package:sumify_clean/core/utils/show_snackbar.dart';
import 'package:sumify_clean/features/article/presentation/blocs/article_bloc/article_bloc.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            color: AppPallete.klightTealColor,
            height: double.maxFinite,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: AppPallete.kWhiteColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(40.r)),
            ),
            height: (MediaQuery.of(context).size.height / 2).h - 40.h,
            width: double.maxFinite,
          ),
        ),
        BlocConsumer<ArticleBloc, ArticleState>(
          listener: (context, state) {
            if (state.reportStatus == ReportSaveStatus.failure) {
              showSnackBar(context, state.reportErrorMessage!);
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppPallete.kWhiteColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(22.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: AppPallete.kShadowColor,
                            spreadRadius: 5.r,
                            blurRadius: 10.r),
                      ],
                    ),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      strokeCap: StrokeCap.butt,
                      radius: Radius.circular(22.r),
                      strokeWidth: 4.w,
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                      borderPadding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                      dashPattern: [8.w, 16.w],
                      color: AppPallete.klightTealColor,
                      child: Container(
                        height: 500.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(22.r),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Report Text',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: AppPallete.kGreyColor,
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                height: 400.h,
                                child: ListView(
                                    padding: EdgeInsets.zero,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: SelectableText(
                                          state.article.report,
                                          style: GoogleFonts.nunito(
                                              textStyle: TextStyle(
                                            fontSize: 18.sp,
                                          )),
                                        ),
                                      ),
                                    ]),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25.h),
                SizedBox(
                  height: 50.h,
                  width: 150.w,
                  child: ElevatedButton(
                      onPressed:
                          // state.article.report == '' ||
                          state.reportStatus == ReportSaveStatus.loading
                              ? null
                              : () async {
                                  context
                                      .read<ArticleBloc>()
                                      .add(SaveAsPdfButtonPressed());
                                }
                      //  () async {
                      //         setState(() {
                      //           isSaving = true;
                      //         });
                      //         String s = articleProvider.article.title!;
                      //         String regex =
                      //             r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]+';
                      //         String formattedTitle =
                      //             s.replaceAll(RegExp(regex, unicode: true), '');
                      //         final message = await PdfApi.saveAsPdf(
                      //             articleProvider.article.report!, formattedTitle);
                      //         setState(() {
                      //           isSaving = false;
                      //         });
                      //         if (message.contains('Success')) {
                      //           if (!context.mounted) return;
                      //           ScaffoldMessenger.of(context).showSnackBar(
                      //             const SnackBar(
                      //               content: Text('Report Saved Successfully.'),
                      //             ),
                      //           );
                      //         } else {
                      //           if (!context.mounted) return;
                      //           ScaffoldMessenger.of(context).showSnackBar(
                      //             SnackBar(
                      //               content: Text(message),
                      //             ),
                      //           );
                      //         }
                      //  },
                      ,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        backgroundColor: AppPallete.kOrangeColor,
                      ),
                      child: state.reportStatus == ReportSaveStatus.loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: AppPallete.kWhiteColor),
                            )
                          : Text(
                              'Save As PDF',
                              style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppPallete.kWhiteColor,
                              )),
                            )),
                )
              ],
            );
          },
        ),
      ]),
    );
  }
}
