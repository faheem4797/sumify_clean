import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sumify_clean/core/common/cubits/app_user_cubit.dart';
import 'package:sumify_clean/core/common/form_inputs/confirm_password.dart';
import 'package:sumify_clean/core/common/form_inputs/email.dart';
import 'package:sumify_clean/core/common/form_inputs/password.dart';
import 'package:sumify_clean/core/common/widgets/loader.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/theme/app_pallete.dart';
import 'package:sumify_clean/core/utils/show_snackbar.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/widgets/auth_button.dart';
import 'package:sumify_clean/routing/app_route_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Future<void> _launchURL() async {
    final uri = Uri.parse(Constants.privacyPolicyURL);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showSnackBar(context, state.message);
        } else if (state is AuthSuccess) {
          context.read<AppUserCubit>().updateUser(state.user);
          showSnackBar(context, 'Success');
          //TODO: ADD THIS IN ROUTER FILE

          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => const HomeScreen()),
          //     (route) => false);
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
                    image: AssetImage(Constants.loginBackgroundImage),
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
                          Text(
                            'Create your Account',
                            style: TextStyle(
                                color: AppPallete.klightTealColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 30.h),
                          BlocBuilder<SignUpBloc, SignUpState>(
                            buildWhen: (previous, current) =>
                                previous.fullName != current.fullName,
                            builder: (context, state) {
                              return TextField(
                                onChanged: (fullName) => context
                                    .read<SignUpBloc>()
                                    .add(SignUpFullNameChanged(
                                        fullName: fullName)),
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelText: Constants.nameFieldLabelText,
                                  hintText: Constants.nameFieldHintText,
                                  errorText: state.fullName.displayError != null
                                      ? Constants.nameFieldErrorText
                                      : null,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10.h),
                          BlocBuilder<SignUpBloc, SignUpState>(
                            buildWhen: (previous, current) =>
                                previous.email != current.email,
                            builder: (context, state) {
                              return TextField(
                                onChanged: (email) => context
                                    .read<SignUpBloc>()
                                    .add(SignUpEmailChanged(email: email)),
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
                          BlocBuilder<SignUpBloc, SignUpState>(
                            buildWhen: (previous, current) =>
                                (previous.password != current.password) ||
                                (previous.passwordObscured !=
                                    current.passwordObscured),
                            builder: (context, state) {
                              return TextField(
                                onChanged: (password) => context
                                    .read<SignUpBloc>()
                                    .add(SignUpPasswordChanged(
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
                                        context.read<SignUpBloc>().add(
                                            SignUpPasswordObscurePressed());
                                      },
                                      icon: Icon(state.passwordObscured
                                          ? Icons.visibility
                                          : Icons.visibility_off)),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10.h),
                          BlocBuilder<SignUpBloc, SignUpState>(
                            buildWhen: (previous, current) =>
                                (previous.confirmPassword !=
                                    current.confirmPassword) ||
                                (previous.confirmPasswordObscured !=
                                    current.confirmPasswordObscured),
                            builder: (context, state) {
                              return TextField(
                                onChanged: (confirmPassword) => context
                                    .read<SignUpBloc>()
                                    .add(SignUpConfirmPasswordChanged(
                                        confirmPassword: confirmPassword)),
                                keyboardType: TextInputType.name,
                                obscureText: state.confirmPasswordObscured,
                                decoration: InputDecoration(
                                  labelText:
                                      Constants.confirmPasswordFieldLabelText,
                                  hintText:
                                      Constants.confirmPasswordFieldHintText,
                                  errorText: state
                                              .confirmPassword.displayError ==
                                          ConfirmPasswordValidationError.invalid
                                      ? Constants
                                          .confirmPasswordFieldInvalidErrorText
                                      : state.confirmPassword.displayError ==
                                              ConfirmPasswordValidationError
                                                  .empty
                                          ? Constants
                                              .confirmPasswordFieldEmptyErrorText
                                          : null,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        context.read<SignUpBloc>().add(
                                            SignUpConfirmPasswordObscurePressed());
                                      },
                                      icon: Icon(state.confirmPasswordObscured
                                          ? Icons.visibility
                                          : Icons.visibility_off)),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 30.h),
                          Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        'By clicking SIGN UP, you agree to and have read our ',
                                    style: GoogleFonts.outfit(
                                        textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    )),
                                  ),
                                  TextSpan(
                                      style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                        color: AppPallete.kDarkTealColor,
                                        fontSize: 15,
                                      )),
                                      text: 'Privacy Policy',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          await _launchURL();
                                        }),
                                  const TextSpan(
                                      text: '.',
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          AuthButton(
                            buttonText: 'SIGN UP',
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              context
                                  .read<SignUpBloc>()
                                  .add(SignUpButtonPressed());
                              final signUpState =
                                  context.read<SignUpBloc>().state;
                              if (signUpState.isValid) {
                                context.read<AuthBloc>().add(AuthSignUp(
                                    name: signUpState.fullName.value,
                                    email: signUpState.email.value,
                                    password: signUpState.password.value));
                              }
                            },
                          ),
                          SizedBox(height: 30.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                  fontSize: 16.sp,
                                )),
                              ),
                              InkWell(
                                onTap: () {
                                  print('object');

                                  context.replaceNamed(
                                      AppRouteConstants.signinRoute);
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: AppPallete.kDarkTealColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
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
