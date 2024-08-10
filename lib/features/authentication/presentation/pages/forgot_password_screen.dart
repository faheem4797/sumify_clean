import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sumify_clean/core/common/form_inputs/email.dart';
import 'package:sumify_clean/core/common/widgets/loader.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/theme/app_pallete.dart';
import 'package:sumify_clean/core/utils/show_snackbar.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/widgets/auth_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(color: AppPallete.kWhiteColor),
        ),
        centerTitle: true,
        backgroundColor: AppPallete.klightTealColor,
      ),
      backgroundColor: Colors.transparent,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
          } else if (state is AuthInitial && state.message != null) {
            showSnackBar(context, state.message!);
            Future.delayed(const Duration(seconds: 2), () {
              context.pop();
            });
          }
        },
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: AppPallete.kWhiteColor,
              image: DecorationImage(
                image: AssetImage(Constants.splashBackgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: state is AuthLoading
                ? const Loader()
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 230.h),
                          BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                            buildWhen: (previous, current) =>
                                previous.email != current.email,
                            builder: (context, state) {
                              return TextField(
                                onChanged: (email) => context
                                    .read<ForgotPasswordBloc>()
                                    .add(ForgotPasswordEmailChanged(
                                        email: email)),
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
                          SizedBox(height: 25.h),
                          AuthButton(
                              buttonText: 'Reset Password',
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                context
                                    .read<ForgotPasswordBloc>()
                                    .add(ForgotPasswordButtonPressed());
                                final forgotPasswordState =
                                    context.read<ForgotPasswordBloc>().state;
                                if (forgotPasswordState.isValid) {
                                  context
                                      .read<AuthBloc>()
                                      .add(AuthForgotPassword(
                                        email: forgotPasswordState.email.value,
                                      ));
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
