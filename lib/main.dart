import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whispery/pages/entry_page.dart';

import 'package:whispery/pages/error_page.dart';
import 'package:whispery/pages/landing_page.dart';
import 'package:whispery/pages/splash_page.dart';
import 'package:whispery/helpers/user_repository.dart';
import 'package:whispery/helpers/simple_bloc_delegate.dart';
import 'package:whispery/blocs/sharedpreferences_bloc/bloc.dart';
import 'package:whispery/blocs/authentication_bloc/bloc.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(
    RepositoryProvider(
      builder: (BuildContext context) {
        final UserRepository _userRepository = UserRepository();
        return _userRepository;
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            builder: (BuildContext context) {
              final AuthenticationBloc _authenticationBloc = AuthenticationBloc(
                  userRepository:
                      RepositoryProvider.of<UserRepository>(context))
                ..dispatch(AppStarted());
              return _authenticationBloc;
            },
          ),
          BlocProvider<SharedPreferencesBloc>(
            builder: (BuildContext context) {
              final SharedPreferencesBloc _sharedPreferencesBloc =
                  SharedPreferencesBloc()..dispatch(InitializeEvent());
              return _sharedPreferencesBloc;
            },
          ),
        ],
        child: Builder(),
      ),
    ),
  );
}

class Builder extends StatelessWidget {
  /// Build method for authentication.
  /// If [Uninitailized], navigate to [SplashScreen] while awaiting [AuthenticationBloc] response.
  /// If [Unauthenticated], navigate to [LoginScreen] for first time user setup.
  /// If [Authenticated], navigate to [FeedPage] after credentials have been authorized.
  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc _authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    return MaterialApp(
      theme: ThemeData(fontFamily: 'Barlow'),
      home: BlocBuilder(
        bloc: _authenticationBloc,
        builder: (BuildContext context, AuthenticationState state) {
          if (state is Uninitialized) {
            return SplashPage();
          } else if (state is Unauthenticated) {
            return EntryPage();
          } else if (state is Authenticated) {
            return LandingPage();
          } else {
            return ErrorPage();
          }
        },
      ),
    );
  }
}
