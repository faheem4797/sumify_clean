import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sumify_clean/core/common/cubits/app_user_cubit.dart';
import 'package:sumify_clean/core/common/widgets/loader.dart';
import 'package:sumify_clean/core/theme/app_pallete.dart';
import 'package:sumify_clean/core/utils/pick_image.dart';
import 'package:sumify_clean/core/utils/show_snackbar.dart';
import 'package:sumify_clean/features/profile/presentation/blocs/edit_profile_image_bloc/edit_profile_image_bloc.dart';
import 'package:sumify_clean/features/profile/presentation/blocs/logout_bloc/logout_bloc.dart';
import 'package:sumify_clean/routing/app_route_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: (constraints.maxHeight * 0.33).h,
              child: Image.asset(
                'assets/images/profile/bg.png',
                fit: BoxFit.fill,
                width: double.maxFinite,
                // height: 234,
              ),
            ),
          ),
          MultiBlocListener(
            listeners: [
              BlocListener<EditProfileImageBloc, EditProfileImageState>(
                listener: (context, state) {
                  if (state is EditProfileImageFailure) {
                    showSnackBar(context, state.message);
                  } else if (state is EditProfileImageSuccess) {
                    context.read<AppUserCubit>().updateUser(state.appUser);
                  }
                },
              ),
              BlocListener<LogoutBloc, LogoutState>(
                listener: (context, state) {
                  if (state is LogoutFailure) {
                    showSnackBar(context, state.message);
                  } else if (state is LogoutSuccess) {
                    context.read<AppUserCubit>().updateUser(null);
                    context.goNamed(AppRouteConstants.signinRouteName);
                  }
                },
              ),
            ],
            child: BlocBuilder<LogoutBloc, LogoutState>(
              builder: (context, state) {
                return (state is LogoutLoading)
                    ? const Loader()
                    : BlocBuilder<EditProfileImageBloc, EditProfileImageState>(
                        builder: (context, state) {
                          return (state is EditProfileImageLoading)
                              ? const Loader()
                              : Center(
                                  child:
                                      BlocBuilder<AppUserCubit, AppUserState>(
                                    builder: (context, state) {
                                      return (state is AppUserLoading)
                                          ? const Loader()
                                          : (state is AppUserLoggedIn)
                                              ? Column(
                                                  children: [
                                                    SizedBox(
                                                        height: (constraints
                                                                    .maxHeight *
                                                                0.2)
                                                            .h),
                                                    SizedBox(
                                                      height: (constraints
                                                                  .maxHeight *
                                                              0.18)
                                                          .h,
                                                      width: (constraints
                                                                  .maxHeight *
                                                              0.18)
                                                          .w,
                                                      child: Stack(children: [
                                                        DottedBorder(
                                                          borderType:
                                                              BorderType.Circle,
                                                          strokeCap:
                                                              StrokeCap.butt,
                                                          strokeWidth: 3.w,
                                                          dashPattern: const [
                                                            5,
                                                            5
                                                          ],
                                                          color: AppPallete
                                                              .kDarkerTealColor,
                                                          child: CircleAvatar(
                                                            radius: 59.r,
                                                            backgroundColor:
                                                                AppPallete
                                                                    .kWhiteColor,
                                                            foregroundImage: (state
                                                                        .user.pictureFilePathFromFirebase ==
                                                                    '')
                                                                ? const AssetImage(
                                                                        'assets/images/profile/user.png')
                                                                    as ImageProvider
                                                                : CachedNetworkImageProvider(
                                                                    state.user
                                                                        .pictureFilePathFromFirebase!),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 3.w,
                                                                    bottom:
                                                                        4.h),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                final pickedImage =
                                                                    await pickImage();
                                                                if (pickedImage !=
                                                                        null &&
                                                                    context
                                                                        .mounted) {
                                                                  context
                                                                      .read<
                                                                          EditProfileImageBloc>()
                                                                      .add(
                                                                          EditUserProfileImageEvent(
                                                                        userId: state
                                                                            .user
                                                                            .id,
                                                                        pictureFilePathFromFirebase:
                                                                            state.user.pictureFilePathFromFirebase ??
                                                                                '',
                                                                        profileImage:
                                                                            pickedImage.file,
                                                                        fileName:
                                                                            pickedImage.name,
                                                                      ));
                                                                }
                                                              },
                                                              child:
                                                                  CircleAvatar(
                                                                radius: (constraints
                                                                            .maxHeight *
                                                                        0.023)
                                                                    .r,
                                                                backgroundColor:
                                                                    AppPallete
                                                                        .kDarkerTealColor,
                                                                child: Center(
                                                                    child: Icon(
                                                                  Icons.edit,
                                                                  size: (constraints
                                                                              .maxHeight *
                                                                          0.032)
                                                                      .h,
                                                                  color: AppPallete
                                                                      .kWhiteColor,
                                                                )),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Text(
                                                      state.user.name,
                                                      style: TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    Text(
                                                      state.user.email,
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          color: AppPallete
                                                              .kLightGreyColor),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 30.w,
                                                          right: 70.w),
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                              height: (constraints
                                                                          .maxHeight *
                                                                      0.16)
                                                                  .h),
                                                          InkWell(
                                                            onTap: () async {
                                                              // await openDialog(context, userProvider,
                                                              //     articleProvider);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                    width: 5.w),
                                                                const Icon(
                                                                  Icons
                                                                      .person_remove_outlined,
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        25.w),
                                                                Text(
                                                                  'Delete Account',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Divider(
                                                            height: 20.h,
                                                            thickness: 2.w,
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              context
                                                                  .read<
                                                                      LogoutBloc>()
                                                                  .add(
                                                                      UserLogoutEvent());
                                                            },
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                    width: 5.w),
                                                                const Icon(
                                                                  Icons.logout,
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        25.w),
                                                                Text(
                                                                  'Logout',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Divider(
                                                            height: 20,
                                                            thickness: 2,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container();
                                    },
                                  ),
                                );
                        },
                      );
              },
            ),
          )
        ],
      );
    }));
  }
}
