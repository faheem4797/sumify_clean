class Constants {
  static const noConnectionErrorMessage = 'Not connected to a network!';
  static const privacyPolicyURL =
      'https://github.com/visuamos/sumify-policy/blob/main/privacy-policy.md';
  static const List imageList = [
    {"id": 1, "image_path": 'assets/images/splash/group.png'},
    {"id": 2, "image_path": 'assets/images/splash/splash_icon2.png'},
  ];
  static const loginBackgroundImage = "assets/images/login/bg.png";
  static const splashBackgroundImage = "assets/images/splash/splash_bg.png";
  //Name Field
  static const nameFieldLabelText = 'Full Name';
  static const nameFieldHintText = 'Enter your name';
  static const nameFieldErrorText = 'Please enter your name';
  //Email Field
  static const emailFieldLabelText = 'Email Address';
  static const emailFieldHintText = 'Enter your email';
  static const emailFieldEmptyErrorText = 'Please enter an email';
  static const emailFieldInvalidErrorText = 'Please enter a valid email';
  //Password Field
  static const passwordFieldLabelText = 'Password';
  static const passwordFieldHintText = 'Enter your password';
  static const passwordFieldEmptyErrorText = 'Please enter a password';
  static const passwordFieldShortErrorText =
      'Password must be atleast 8 characters long';
  //Confirm Password Field
  static const confirmPasswordFieldLabelText = 'Confirm Password';
  static const confirmPasswordFieldHintText = 'Confirm your password';
  static const confirmPasswordFieldEmptyErrorText = 'Please enter a password';
  static const confirmPasswordFieldInvalidErrorText = 'Passwords did not match';
}
