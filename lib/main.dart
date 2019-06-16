import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:whispery/authentication_bloc/bloc.dart';
import 'package:whispery/pages/landing_page.dart';
import 'package:whispery/pages/splash_page.dart';
import 'package:whispery/user_repository.dart';
import 'package:whispery/login/login.dart';
import 'package:whispery/helpers/simple_bloc_delegate.dart';

/// Main driver method.
void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App());
}

/// Initial App state.
class App extends StatefulWidget {
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// Initalize [UserRepository] and [AuthenticationBloc] for credential checks.
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  /// Dispatch event to [AuthenticationBloc] to start authentication process.
  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    _authenticationBloc.dispatch(AppStarted());
  }

  /// Build method for authentication.
  /// If [Uninitailized], navigate to [SplashScreen] while awaiting [AuthenticationBloc] response.
  /// If [Unauthenticated], navigate to [LoginScreen] for first time user setup.
  /// If [Authenticated], navigate to [FeedPage] after credentials have been authorized.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _authenticationBloc,
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Barlow'),
        home: BlocBuilder(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is Uninitialized) {
              return SplashPage();
            }
            if (state is Unauthenticated) {
              return LoginScreen(userRepository: _userRepository);
            }
            if (state is Authenticated) {
              return LandingPage();
            }
          },
        ),
      ),
    );
  }

  /// Dispose all BLoCs from the widget tree on exit to release resources.
  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }
}
