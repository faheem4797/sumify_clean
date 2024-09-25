import 'package:sumify_clean/features/contact_us/domain/entities/contact_us.dart';

class ContactUsModel extends ContactUs {
  const ContactUsModel(
      {required super.firstName,
      required super.lastName,
      required super.email,
      required super.message});
}
