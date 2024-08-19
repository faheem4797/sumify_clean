import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sumify_clean/core/common/form_inputs/email.dart';
import 'package:sumify_clean/core/common/form_inputs/full_name.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/theme/app_pallete.dart';
import 'package:sumify_clean/core/utils/show_snackbar.dart';
import 'package:sumify_clean/features/contact_us/presentation/blocs/contact_us_bloc/contact_us_bloc.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ContactUsBloc, ContactUsState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            showSnackBar(context, state.errorMessage ?? 'Failed to send email');
          } else if (state.status.isSuccess) {
            _firstNameController.clear();
            _lastNameController.clear();
            _emailController.clear();
            _messageController.clear();
            showSnackBar(context, 'Email Sent Successfully');
          }
        },
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: constraints.maxHeight * 0.3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/contact/bg.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                      child: Text(
                    'Contact Us',
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
                  )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.h, right: 10.w, left: 10.w),
                  child: Container(
                    //height: 200,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppPallete.kWhiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppPallete.kGreyColor.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'About Us',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color:
                                        AppPallete.kBlackColor.withOpacity(0.5),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: Text(
                              'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. ',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: AppPallete.kBlackColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          Divider(
                            color: AppPallete.kBlackColor.withOpacity(0.3),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    "Let’s Answer your Queries",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                BlocBuilder<ContactUsBloc, ContactUsState>(
                                  buildWhen: (previous, current) =>
                                      previous.firstName != current.firstName,
                                  builder: (context, state) {
                                    return TextField(
                                      controller: _firstNameController,
                                      onChanged: (firstName) => context
                                          .read<ContactUsBloc>()
                                          .add(ContactUsFirstNameChanged(
                                              firstName: firstName)),
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        labelText:
                                            Constants.firstNameFieldLabelText,
                                        hintText:
                                            Constants.firstNameFieldHintText,
                                        errorText: state
                                                    .firstName.displayError ==
                                                FullNameValidationError.empty
                                            ? Constants.firstNameFieldErrorText
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 15.h),
                                BlocBuilder<ContactUsBloc, ContactUsState>(
                                  buildWhen: (previous, current) =>
                                      previous.lastName != current.lastName,
                                  builder: (context, state) {
                                    return TextField(
                                      controller: _lastNameController,
                                      onChanged: (lastName) => context
                                          .read<ContactUsBloc>()
                                          .add(ContactUsLastNameChanged(
                                              lastName: lastName)),
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        labelText:
                                            Constants.lastNameFieldLabelText,
                                        hintText:
                                            Constants.lastNameFieldHintText,
                                        errorText: state
                                                    .lastName.displayError ==
                                                FullNameValidationError.empty
                                            ? Constants.lastNameFieldErrorText
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 15.h),
                                BlocBuilder<ContactUsBloc, ContactUsState>(
                                  buildWhen: (previous, current) =>
                                      previous.email != current.email,
                                  builder: (context, state) {
                                    return TextField(
                                      controller: _emailController,
                                      onChanged: (email) => context
                                          .read<ContactUsBloc>()
                                          .add(ContactUsEmailChanged(
                                              email: email)),
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelText:
                                            Constants.emailFieldLabelText,
                                        hintText: Constants.emailFieldHintText,
                                        errorText: state.email.displayError ==
                                                EmailValidationError.empty
                                            ? Constants.emailFieldEmptyErrorText
                                            : state.email.displayError ==
                                                    EmailValidationError.invalid
                                                ? Constants
                                                    .emailFieldInvalidErrorText
                                                : null,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 15.h),
                                BlocBuilder<ContactUsBloc, ContactUsState>(
                                  buildWhen: (previous, current) =>
                                      previous.message != current.message,
                                  builder: (context, state) {
                                    return TextField(
                                      controller: _messageController,
                                      onChanged: (message) => context
                                          .read<ContactUsBloc>()
                                          .add(ContactUsMessageChanged(
                                              message: message)),
                                      keyboardType: TextInputType.name,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        alignLabelWithHint: true,
                                        labelText:
                                            Constants.messageFieldLabelText,
                                        hintText:
                                            Constants.messageFieldHintText,
                                        errorText: state.message.displayError ==
                                                FullNameValidationError.empty
                                            ? Constants.messageFieldErrorText
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 15.h),
                                const SizedBox(height: 15),
                                SizedBox(
                                  height: 50.h,
                                  width: 150.w,
                                  child: BlocBuilder<ContactUsBloc,
                                      ContactUsState>(
                                    builder: (context, state) {
                                      return ElevatedButton(
                                          onPressed: state.status.isInProgress
                                              ? null
                                              : () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  context.read<ContactUsBloc>().add(
                                                      ContactUsSubmitButtonPressed());
                                                },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.r),
                                            ),
                                            backgroundColor:
                                                AppPallete.kOrangeColor,
                                          ),
                                          child: state.status.isInProgress
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          // color: AppPallete
                                                          //     .kWhiteColor
                                                          ),
                                                )
                                              : Text(
                                                  'Submit',
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppPallete.kWhiteColor,
                                                  ),
                                                ));
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
