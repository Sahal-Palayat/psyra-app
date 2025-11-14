import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:psyra/core/common_blocs/auth_bloc/auth_bloc.dart';
import 'package:psyra/core/navigation/navigation_routes.dart';
import 'package:psyra/modules/dashboard/view/pages/dashboard_page.dart';
import 'package:psyra/modules/login/controller/login_bloc/login_bloc.dart';
import 'package:psyra/modules/login/view/pages/login_page.dart';
import 'package:psyra/modules/signup/controller/signup_bloc/signup_bloc.dart';
import 'package:psyra/modules/signup/view/pages/signup_page.dart';

class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    final router = GoRouter(
      initialLocation: NavigationRoutes.login,
      refreshListenable: _AuthNotifier(authBloc),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isLoggedIn = authState is AuthAuthenticated;
        final isGoingToLogin = state.matchedLocation == NavigationRoutes.login;
        final isGoingToSignup = state.matchedLocation == NavigationRoutes.signup;
        final isGoingToDashboard = state.matchedLocation == NavigationRoutes.dashboard;

        // If not logged in and trying to access dashboard, redirect to login
        if (!isLoggedIn && isGoingToDashboard) {
          return NavigationRoutes.login;
        }

        // If logged in and trying to access login/signup, redirect to dashboard
        if (isLoggedIn && (isGoingToLogin || isGoingToSignup)) {
          return NavigationRoutes.dashboard;
        }

        return null; // No redirect needed
      },
      routes: [
        GoRoute(
          path: NavigationRoutes.login,
          builder: (context, state) => BlocProvider(
            create: (context) => LoginBloc(),
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: NavigationRoutes.signup,
          builder: (context, state) => BlocProvider(
            create: (context) => SignupBloc(),
            child: const SignupPage(),
          ),
        ),
        GoRoute(
          path: NavigationRoutes.dashboard,
          builder: (context, state) => const DashboardPage(),
        ),
      ],
    );

    return router;
  }
}

class _AuthNotifier extends ChangeNotifier {
  final AuthBloc _authBloc;

  _AuthNotifier(this._authBloc) {
    _authBloc.stream.listen((_) {
      notifyListeners();
    });
  }
}

