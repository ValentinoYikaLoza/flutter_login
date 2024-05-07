import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login/config/constants/storage_keys.dart';
import 'package:login/config/router/app_router.dart';
import 'package:login/features/models/login_response.dart';
import 'package:login/features/providers/auth_provider.dart';
import 'package:login/features/providers/loader_provider.dart';
import 'package:login/features/service/auth_service.dart';
import 'package:login/features/service/storage_service.dart';
import 'package:login/features/service/service_exception.dart';
import 'package:login/features/service/snackbar_service.dart';
import 'package:login/features/widgets/form_wydnex.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref);
});

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this.ref)
      : super(
          LoginState(
            email: FormWydnex<String>(
              value: '',
              validators: [
                const ValidatorWydnex(ValidatorsWydnex.required),
                const ValidatorWydnex(ValidatorsWydnex.email),
              ],
              formatters: [
                LengthLimitingTextInputFormatter(20),
              ],
            ),
            password: FormWydnex<String>(
              value: '',
              validators: [
                const ValidatorWydnex(ValidatorsWydnex.required),
                const ValidatorWydnex(ValidatorsWydnex.maxLength, value: 10),
              ],
              formatters: [
                LengthLimitingTextInputFormatter(10),
              ],
            ),
          ),
        );
  final StateNotifierProviderRef ref;

  initData() async {
    final user =
        await StorageService.get<String>(StorageKeys.user) ??
            '';
    final rememberMe = await StorageService.get<bool>(StorageKeys.rememberMe) ??
        false;

    state = state.copyWith(
      email: rememberMe ? FormWydnex(value: user) : const FormWydnex(value: ''),
      password: const FormWydnex(value: ''),
      rememberMe: rememberMe,
    );
  }

  login() async {
    FocusManager.instance.primaryFocus
        ?.unfocus(); //hacer que el teclado se quite

    final user = FormWydnex(value: state.email.value);
    final password = FormWydnex(value: state.password.value);
    state = state.copyWith(
      email: user,
      password: password,
    );
    if (!state.isFormValid) return;

    ref.read(loaderProvider.notifier).mostrarLoader('Atenticando');

    try {
      final LoginResponse loginResponse = await AuthService.login(
        email: state.email.value,
        password: state.password.value,
      );

      await StorageService.set<String>(
          StorageKeys.token, loginResponse.accessToken);

      setRemember();
      //cada vez que inicia sesion habilita las notificaciones
      //ref.read(notificationProvider.notifier).enableNotifications();
      ref.read(authProvider.notifier).initAutoLogout();

      appRouter.go('/home');
    } on ServiceException catch (e) {
      SnackbarService.showSnackbar(message: e.message);
    }

    ref.read(loaderProvider.notifier).quitarLoader();
  }

  setRemember() async {
    if (state.rememberMe) {
      await StorageService.set<String>(
          StorageKeys.user, state.email.value);
    }
    await StorageService.set<bool>(
        StorageKeys.rememberMe, state.rememberMe);
  }

  changeUser(FormWydnex<String> user) {
    state = state.copyWith(
      email: user,
    );
  }

  changePassword(FormWydnex<String> password) {
    state = state.copyWith(
      password: password,
    );
  }

  toggleRememberMe() {
    state = state.copyWith(
      rememberMe: !state.rememberMe,
    );
  }
}

class LoginState {
  final FormWydnex<String> email;
  final FormWydnex<String> password;
  final bool loading;
  final bool rememberMe;
  bool get isFormValid{
    return email.isValid && password.isValid;
  }

  LoginState({
    required this.email,
    required this.password,
    this.loading = false,
    this.rememberMe = false,
  });

  LoginState copyWith({
    FormWydnex<String>? email,
    FormWydnex<String>? password,
    bool? loading,
    bool? rememberMe,
  }) =>
      LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        loading: loading ?? this.loading,
        rememberMe: rememberMe ?? this.rememberMe,
      );
}
