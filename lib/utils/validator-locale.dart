import 'package:form_validator/form_validator.dart';

class MyValidationLocale extends FormValidatorLocale {
  @override
  String name() => "custom";

  @override
  String required() => "Field is required";

  @override
  String email(String v) {
    throw UnimplementedError();
  }

  @override
  String ip(String v) {
    // TODO: implement ip
    throw UnimplementedError();
  }

  @override
  String ipv6(String v) {
    // TODO: implement ipv6
    throw UnimplementedError();
  }

  @override
  String maxLength(String v, int n) {
    // TODO: implement maxLength
    throw UnimplementedError();
  }

  @override
  String minLength(String v, int n) {
    // TODO: implement minLength
    throw UnimplementedError();
  }

  @override
  String phoneNumber(String v) {
    // TODO: implement phoneNumber
    throw UnimplementedError();
  }

  @override
  String url(String v) {
    // TODO: implement url
    throw UnimplementedError();
  }
}
