import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login/features/providers/login_provider.dart';
import 'package:login/features/widgets/checkbox.dart';
import 'package:login/features/widgets/custom_filled_button.dart';
import 'package:login/features/widgets/input_wydnex.dart';
import 'package:login/features/widgets/password_input.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginView()
    );
  }
}

class LoginView extends ConsumerStatefulWidget {
  const LoginView({
    super.key,
  });

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends ConsumerState<LoginView> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(loginProvider.notifier).initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Image.asset('assets/imgs/image.png', fit: BoxFit.cover)
          ),

          const SizedBox(height: 30),

          InputWydnex(
            label: 'Usuario',
            value: loginState.email,
            keyboardType: TextInputType.name,
            onChanged: (value) {
              ref.read(loginProvider.notifier).changeUser(value);
            },
          ),

          const SizedBox(height: 30),

          PasswordInput(
            label: 'Contraseña',
            value: loginState.password,
            onChanged: (value) {
              ref.read(loginProvider.notifier).changePassword(value);
            },
          ),
          
          const SizedBox(height: 10),

          CustomCheckbox(
            value: loginState.rememberMe,
            onChanged: (value) {
              ref.read(loginProvider.notifier).toggleRememberMe();
            },
            label: 'Recuerdame',
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              buttonColor: Colors.blue,
              textColor: Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: const Text('Ingresar'),
              onPressed: (){
                ref.read(loginProvider.notifier).login();
              }
            )
          ),
        ],
      ),
    );
  }
}