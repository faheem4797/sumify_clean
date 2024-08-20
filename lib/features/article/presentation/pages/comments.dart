import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sumify_clean/core/theme/app_pallete.dart';
import 'package:sumify_clean/features/article/presentation/blocs/article_bloc/article_bloc.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(color: AppPallete.klightTealColor),
        Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.9,
            child: Container(
//                        height: MediaQuery.of(context).size.height - 120.h,

              decoration: BoxDecoration(
                color: AppPallete.kWhiteColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50.r),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    'Comments',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppPallete.kBlackColor.withOpacity(0.5)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.w, left: 10.w),
                      child: Center(
                        child: Container(
                          height: (MediaQuery.of(context).size.height.h < 700)
                              ? (MediaQuery.of(context).size.height - 350)
                              : (MediaQuery.of(context).size.height.h < 750)
                                  ? (MediaQuery.of(context).size.height - 300)
                                  : (MediaQuery.of(context).size.height.h < 800)
                                      ? (MediaQuery.of(context).size.height -
                                          250)
                                      : (MediaQuery.of(context).size.height.h <
                                              850)
                                          ? (MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              200)
                                          : (MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              150),
                          decoration: BoxDecoration(
                            color: AppPallete.kWhiteColor,
                            //border: ,
                            boxShadow: [
                              BoxShadow(
                                color: AppPallete.kGreyColor.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          //height: double.maxFinite,
                          child: BlocBuilder<ArticleBloc, ArticleState>(
                            builder: (context, state) {
                              return Center(
                                  child: (state.article.comments.isNotEmpty)
                                      ? ListView.builder(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          itemCount:
                                              state.article.comments.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.h,
                                                  horizontal: 25.w),
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: AppPallete
                                                        .kWhiteColor
                                                        .withOpacity(0.6),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20.r)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: AppPallete
                                                              .kGreyColor
                                                              .withOpacity(0.7),
                                                          spreadRadius: 3,
                                                          blurRadius: 4,
                                                          offset: const Offset(
                                                            0,
                                                            3,
                                                          )),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 15.r,
                                                        backgroundColor:
                                                            AppPallete
                                                                .kWhiteColor,
                                                        foregroundImage:
                                                            const AssetImage(
                                                                    'assets/images/profile/user.png')
                                                                as ImageProvider,
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      Expanded(
                                                          child: SelectableText(
                                                              state.article
                                                                      .comments[
                                                                  index])),
                                                    ],
                                                  )),
                                            );
                                          })
                                      : const Center());
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
