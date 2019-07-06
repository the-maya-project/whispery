import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:whispery/authentication_bloc/bloc.dart';
import 'package:whispery/globals/config.dart';
import 'package:whispery/pages/landing_page.dart';
import 'package:whispery/pages/splash_page.dart';
import 'package:whispery/login/login.dart';
import 'package:whispery/helpers/user_repository.dart';
import 'package:whispery/helpers/simple_bloc_delegate.dart';
import 'package:whispery/sharedpreferences_bloc/bloc.dart';
import 'package:whispery/sharedpreferences_bloc/sharedpreferences_bloc.dart';

/// Main driver method.
void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Barlow'),
      home: BlocProviderTree(
        blocProviders: [
          BlocProvider<AuthenticationBloc>(
            builder: (BuildContext context) {
              AuthenticationBloc _authenticationBloc =
                  AuthenticationBloc(userRepository: _userRepository);
              _authenticationBloc.dispatch(AppStarted());
              return _authenticationBloc;
            },
          ),
          BlocProvider<SharedPreferencesBloc>(
            builder: (BuildContext context) {
              SharedPreferencesBloc _sharedPreferencesBloc =
                  SharedPreferencesBloc();
              _sharedPreferencesBloc.dispatch(GetRadius());
              return _sharedPreferencesBloc;
            },
          ),
        ],
        child: Builder(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}

class Builder extends StatelessWidget {
  final UserRepository _userRepository;

  Builder({Key key, @required UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  /// Build method for authentication.
  /// If [Uninitailized], navigate to [SplashScreen] while awaiting [AuthenticationBloc] response.
  /// If [Unauthenticated], navigate to [LoginScreen] for first time user setup.
  /// If [Authenticated], navigate to [FeedPage] after credentials have been authorized.
  @override
  Widget build(BuildContext context) {
    final SharedPreferencesBloc _sharedPreferencesBloc =
        BlocProvider.of<SharedPreferencesBloc>(context);
    final AuthenticationBloc _authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    return BlocListener(
      bloc: _sharedPreferencesBloc,
      listener: (BuildContext context, SharedPreferencesState state) {
        if (state is SharedPreferencesRadiusError) {
          _sharedPreferencesBloc
              .dispatch(SetRadius(radius: Config.DEFAULT_RADIUS));
        }
      },
      child: BlocBuilder(
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
    );
  }
}
