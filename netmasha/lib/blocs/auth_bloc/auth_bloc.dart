import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netmasha/api/auth.dart';
import 'package:netmasha/blocs/auth_bloc/auth_event.dart';
import 'package:netmasha/blocs/auth_bloc/auth_state.dart';
import 'package:netmasha/prefrences/shared_prefrences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final SharedPref _sharedPref;

  AuthBloc() : super(AuthInitial()) {
    _initializeSharedPref();
    on<AuthLoginEvent>(_onAuthLoginEvent);
    on<AuthRegisterEvent>(_onAuthRegisterEvent);
    on<OTPEvent>(_onOTPEvent);
    on<AuthLogoutEvent>(_onAuthLogoutEvent);
  }

  void _initializeSharedPref() async {
    _sharedPref = await SharedPref.getInstance();
  }

  Future<void> _onAuthLoginEvent(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState(isLoading: true));

    if (event.email.isNotEmpty && event.password.isNotEmpty) {
      final response = await Auth().postLogin(
          {"email": event.email.trim(), "password": event.password.trim()});

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final token = responseBody['token'] as String;
        await _sharedPref.setToken(token);
        emit(AuthLoginSuccessState(type: "login", email: event.email.trim()));
      } else {
        emit(AuthLoginErrorState(errorMsg: "Email or Password are incorrect"));
      }
    } else {
      emit(AuthLoginErrorState(errorMsg: 'Please Fill The Required Fields'));
    }
    emit(LoadingState(isLoading: false));
  }

  Future<void> _onAuthRegisterEvent(
      AuthRegisterEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState(isLoading: true));

    if (event.email.isNotEmpty &&
        event.password.isNotEmpty &&
        event.name.isNotEmpty) {
      final response = await Auth().postRegistration({
        "name": event.name,
        "email": event.email,
        "password": event.password,
        "phone": event.phone,
      });

      if (response.statusCode == 200) {
        emit(
            AuthRegisterSuccessState(email: event.email, type: 'registration'));
      } else {
        emit(AuthRegisterErrorState(errorMsg: response.body));
      }
    } else {
      emit(AuthRegisterErrorState(errorMsg: 'Please Fill The Required Fields'));
    }
    emit(LoadingState(isLoading: false));
  }

  Future<void> _onOTPEvent(OTPEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState(isLoading: true));

    if (event.otpCode.length >= 6) {
      final response = await Auth()
          .postVerification({"otp": event.otpCode, "email": event.email});

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final token = responseBody['token'] as String;
        await _sharedPref.setToken(token);
        emit(AuthOTPSuccessState());
      } else {
        emit(AuthOTPErrorState(errorMsg: "Wrong OTP $response"));
      }
    } else {
      emit(AuthOTPErrorState(errorMsg: "Please Enter OTP"));
    }
    emit(LoadingState(isLoading: false));
  }

  Future<void> _onAuthLogoutEvent(
      AuthLogoutEvent event, Emitter<AuthState> emit) async {
    await _sharedPref.cleanToken();
    emit(AuthLoggedOutState());
  }
}
