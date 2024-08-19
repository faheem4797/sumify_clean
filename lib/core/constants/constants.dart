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

  //First Name Field
  static const firstNameFieldLabelText = 'First Name';
  static const firstNameFieldHintText = 'Enter your first name';
  static const firstNameFieldErrorText = 'Please enter your first name';
  //Last Name Field
  static const lastNameFieldLabelText = 'Last Name';
  static const lastNameFieldHintText = 'Enter your last name';
  static const lastNameFieldErrorText = 'Please enter your last name';
  //Message Field
  static const messageFieldLabelText = 'Message';
  static const messageFieldHintText = 'Leave a message for us';
  static const messageFieldErrorText = 'Please enter your message';

  // Define the title prompt
  static const titlePrompt =
      'Generate a compelling and relevant title for the following text. Aim for uniqueness and relevance to attract attention and encourage engagement.';

  // Define the report prompt
  static const reportPrompt =
      'Generate a concise, professional report summarizing the provided text. Ensure it includes key insights, analysis, recommendations, and a conclusion.';

  // Define the summarize prompt
  static const summarizePrompt =
      'Please summarize the text below in a quick and easy-to-understand manner.';

  // Define the comments promopt
  static const commentsPrompt =
      'Generate thoughtful and relevant comments to post in response to the following article or social media post. Your comments should be logical and directly related to the subject matter of the article or post. Please provide at least three comments that would be suitable for posting in the comments section. Keep your comments concise and natural-sounding. Write comments in a list in numerical order and do not use any digits within the comments.';
}
