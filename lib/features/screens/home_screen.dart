import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login/features/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Validación'),
        ),
        body: const HomeView());
  }
}

class HomeView extends ConsumerWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/imgs/image.png'),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: (){
              ref.read(authProvider.notifier).logOut();
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.cyan,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 20),
                  Text('Salir'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
