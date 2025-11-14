import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psyra/core/common_blocs/auth_bloc/auth_bloc.dart';
import 'package:psyra/core/navigation/app_router.dart';
import 'package:psyra/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = AuthBloc()..add(const AuthCheckStatus());

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),
      ],
      child: MaterialApp.router(
        title: 'Psyra',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.theme(ThemeMode.light),
        darkTheme: AppThemes.theme(ThemeMode.dark),
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.createRouter(authBloc),
      ),
    );
  }
}
