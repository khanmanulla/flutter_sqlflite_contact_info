extension Validation on String {
  bool isValidName() {
    final namePattern = RegExp(r"^[A-Za-z\s\-]+$");
    return namePattern.hasMatch(this);
  }

  bool isValidMobile() {
    final phoneRegExp = RegExp(r"^[6-9]{1}[0-9]{9}$");
    return phoneRegExp.hasMatch(this) ? true : false;
  }
}
