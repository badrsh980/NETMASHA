abstract class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email, password;
  AuthLoginEvent({required this.email, required this.password});
}

class AuthLogoutEvent extends AuthEvent {}

class AuthRegisterEvent extends AuthEvent {
  final String email, password, name, phone, confirmPassword;
  AuthRegisterEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    required this.confirmPassword,
  });
}

class OTPEvent extends AuthEvent {
  final String otpCode, email, type;
  OTPEvent({required this.otpCode, required this.email, required this.type});
}
