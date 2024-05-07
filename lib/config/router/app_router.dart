import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login/features/screens/home_screen.dart';
import 'package:login/features/screens/login_screen.dart';
import 'package:login/features/service/auth_service.dart';

Future<String?> externalRedirect(
    BuildContext context, GoRouterState state) async {
  final (token, _) = await AuthService.verifyToken();
  if (token) {
    return '/home';
  }
  return null;
}

Future<String?> internalRedirect(
    BuildContext context, GoRouterState state) async {
  final (token, _) = await AuthService.verifyToken();
  if (!token) {
    return '/';
  }
  return null;
}

Widget transition({
  required BuildContext context,
  required Animation animation,
  required Widget child,
}) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);

  var fadeTween = Tween(begin: 0.7, end: 1.0);
  var fadeAnimation = animation.drive(fadeTween);

  return FadeTransition(
    opacity: fadeAnimation,
    child: SlideTransition(position: offsetAnimation, child: child),
  );
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) async {
          return '/login';
        },
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return transition(
                  animation: animation, context: context, child: child);
            },
          );
        },
        redirect: externalRedirect,
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return transition(
                  animation: animation, context: context, child: child);
            },
          );
        },
        redirect: internalRedirect,
      ),
    ]);
