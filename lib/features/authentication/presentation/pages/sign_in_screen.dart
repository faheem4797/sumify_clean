import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sumify_clean/core/common/cubits/app_user_cubit.dart';
import 'package:sumify_clean/core/common/form_inputs/email.dart';
import 'package:sumify_clean/core/common/form_inputs/password.dart';
import 'package:sumify_clean/core/common/widgets/loader.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/theme/app_pallete.dart';
import 'package:sumify_clean/core/utils/show_snackbar.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/widgets/auth_button.dart';
import 'package:sumify_clean/routing/app_route_constants.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showSnackBar(context, state.message);
        } else if (state is AuthSuccess) {
          context.read<AppUserCubit>().updateUser(state.user);
          showSnackBar(context, 'Success');
          context.go(AppRouteConstants.homeRoute);
        }
      },
      builder: (context, state) {
        return state is AuthLoading
            ? const Scaffold(body: Loader())
            : Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: AppPallete.kWhiteColor,
                  image: DecorationImage(
                    image: AssetImage(Constants.splashBackgroundImage),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 120.h),
                          Text(
                            'Sumify',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40.sp)),
                          ),
                          SizedBox(height: 30.h),
                          Text('Login to your Account',
                              style: TextStyle(
                                  color: AppPallete.klightTealColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 30.h),
                          BlocBuilder<SignInBloc, SignInState>(
                            buildWhen: (previous, current) =>
                                previous.email != current.email,
                            builder: (context, state) {
                              return TextField(
                                onChanged: (email) => context
                                    .read<SignInBloc>()
                                    .add(SignInEmailChanged(email: email)),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: Constants.emailFieldLabelText,
                                  hintText: Constants.emailFieldHintText,
                                  errorText: state.email.displayError ==
                                          EmailValidationError.empty
                                      ? Constants.emailFieldEmptyErrorText
                                      : state.email.displayError ==
                                              EmailValidationError.invalid
                                          ? Constants.emailFieldInvalidErrorText
                                          : null,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10.h),
                          BlocBuilder<SignInBloc, SignInState>(
                            buildWhen: (previous, current) =>
                                (previous.password != current.password) ||
                                (previous.passwordObscured !=
                                    current.passwordObscured),
                            builder: (context, state) {
                              return TextField(
                                onChanged: (password) => context
                                    .read<SignInBloc>()
                                    .add(SignInPasswordChanged(
                                        password: password)),
                                keyboardType: TextInputType.name,
                                obscureText: state.passwordObscured,
                                decoration: InputDecoration(
                                  labelText: Constants.passwordFieldLabelText,
                                  hintText: Constants.passwordFieldHintText,
                                  errorText: state.password.displayError ==
                                          PasswordValidationError.empty
                                      ? Constants.passwordFieldEmptyErrorText
                                      : state.password.displayError ==
                                              PasswordValidationError.short
                                          ? Constants
                                              .passwordFieldShortErrorText
                                          : null,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        context.read<SignInBloc>().add(
                                            SignInPasswordObscurePressed());
                                      },
                                      icon: Icon(state.passwordObscured
                                          ? Icons.visibility
                                          : Icons.visibility_off)),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.pushNamed(
                                      AppRouteConstants.forgotPasswordRoute);
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.spaceGrotesk(
                                      textStyle: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppPallete.kDarkTealColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          AuthButton(
                            buttonText: 'SIGN In',
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              context
                                  .read<SignInBloc>()
                                  .add(SignInButtonPressed());
                              final signInState =
                                  context.read<SignInBloc>().state;
                              if (signInState.isValid) {
                                context.read<AuthBloc>().add(AuthLogin(
                                    email: signInState.email.value,
                                    password: signInState.password.value));
                              }
                            },
                          ),
                          SizedBox(height: 30.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                  fontSize: 16.sp,
                                )),
                              ),
                              InkWell(
                                onTap: () {
                                  context
                                      .goNamed(AppRouteConstants.signupRoute);
                                },
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                          color: AppPallete.kDarkTealColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500)),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
