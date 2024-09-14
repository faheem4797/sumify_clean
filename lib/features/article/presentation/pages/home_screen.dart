import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sumify_clean/core/theme/app_pallete.dart';
import 'package:sumify_clean/core/utils/show_snackbar.dart';
import 'package:sumify_clean/features/article/presentation/blocs/article_bloc/article_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: AppPallete.klightTealColor,
        child: SingleChildScrollView(
          child: BlocConsumer<ArticleBloc, ArticleState>(
            listener: (context, state) {
              if (state.status == ArticleStatus.failure) {
                showSnackBar(context, state.errorMessage!);
              }
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.only(top: 85.h),
                child: Container(
                  color: AppPallete.klightTealColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                                  color:
                                      AppPallete.kBlackColor.withOpacity(0.4),
                                  spreadRadius: 5.r,
                                  blurRadius: 10.r),
                            ],
                          ),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            strokeCap: StrokeCap.butt,
                            radius: Radius.circular(22.r),
                            strokeWidth: 4.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 3.h),
                            borderPadding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 2.h),
                            dashPattern: [10.w, 16.w],
                            color: AppPallete.klightTealColor,
                            child: Container(
                              height: ((mediaHeight / 3) - 30).h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(22.r),
                                  ),
                                  image: state.articleText == ''
                                      ? const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/article/paste_article_new.png'),
                                          fit: BoxFit.fill,
                                        )
                                      : null),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: (value) {
                                    context.read<ArticleBloc>().add(
                                        ArticleTextChanged(articleText: value));
                                  },
                                  contextMenuBuilder:
                                      (context, editableTextState) {
                                    return AdaptiveTextSelectionToolbar
                                        .editable(
                                      anchors:
                                          editableTextState.contextMenuAnchors,
                                      clipboardStatus:
                                          ClipboardStatus.pasteable,
                                      // to apply the normal behavior when click on copy (copy in clipboard close toolbar)
                                      // use an empty function `() {}` to hide this option from the toolbar
                                      onCopy: () =>
                                          editableTextState.copySelection(
                                              SelectionChangedCause.toolbar),
                                      // to apply the normal behavior when click on cut
                                      onCut: () =>
                                          editableTextState.cutSelection(
                                              SelectionChangedCause.toolbar),
                                      onPaste: () {
                                        // HERE will be called when the paste button is clicked in the toolbar
                                        // apply your own logic here

                                        // to apply the normal behavior when click on paste (add in input and close toolbar)
                                        editableTextState.pasteText(
                                            SelectionChangedCause.tap);
                                      },
                                      // to apply the normal behavior when click on select all
                                      onSelectAll: () =>
                                          editableTextState.selectAll(
                                              SelectionChangedCause.toolbar),
                                      onLookUp: () {},
                                      onSearchWeb: () {},
                                      onShare: () {},
                                      onLiveTextInput: () {},
                                    );
                                  },
                                  // contextMenuBuilder
                                  toolbarOptions: const ToolbarOptions(
                                      copy: false,
                                      paste: false,
                                      cut: false,
                                      selectAll: true),
                                  style: GoogleFonts.spaceGrotesk(),
                                  maxLines: 12, //11,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppPallete.kTransparentColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppPallete.kTransparentColor,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppPallete.kTransparentColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      SizedBox(
                        height: 50.h,
                        width: 150.w,
                        child: ElevatedButton(
                            onPressed: (state.articleText == '' ||
                                    state.articleText ==
                                        state.article.article ||
                                    state.status == ArticleStatus.loading)
                                ? null
                                : () async {
                                    FocusScope.of(context).unfocus();
                                    context
                                        .read<ArticleBloc>()
                                        .add(SetArticleButtonPressed());
                                  },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              backgroundColor: AppPallete.kOrangeColor,
                            ),
                            child: state.status == ArticleStatus.loading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: AppPallete.kWhiteColor,
                                  ))
                                : Text(
                                    'Set Article',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppPallete.kWhiteColor,
                                    ),
                                  )),
                      ),
                      SizedBox(height: 15.h),
                      Container(
                        decoration: BoxDecoration(
                          color: AppPallete.kWhiteColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.r)),
                        ),
                        height: ((mediaHeight / 2) - 70).h,
                        width: double.maxFinite,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '   Title',
                                      style: GoogleFonts.spaceGrotesk(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 7.h),
                                  Container(
                                    height: 50.h,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                        color: AppPallete.kLighterTealColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppPallete.kBlackColor
                                                .withOpacity(0.4),
                                            blurRadius: 3.0,
                                            spreadRadius: 2.0,
                                            offset: const Offset(-2.0, 2.0),
                                          )
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.r))),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.w),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: SelectableText(
                                            state.article.title,
                                            style: GoogleFonts.spaceGrotesk(),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '   Summary',
                                      style: GoogleFonts.spaceGrotesk(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 7.h),
                                  Container(
                                    height: 135.h,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                        color: AppPallete.kLighterTealColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppPallete.kBlackColor
                                                .withOpacity(0.4),
                                            blurRadius: 3.0,
                                            spreadRadius: 2.0,
                                            offset: const Offset(-2.0, 2.0),
                                          )
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.r))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        child: SelectableText(
                                          state.article.summary,
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.spaceGrotesk(),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
