import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whispery/helpers/user_repository.dart';
import 'package:whispery/login/login.dart';
import 'package:whispery/register/bloc/bloc.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            builder: (BuildContext context) {
              LoginBloc _loginBloc = LoginBloc(
                userRepository: _userRepository,
              );
              return _loginBloc;
            },
          ),
          BlocProvider<RegisterBloc>(
            builder: (BuildContext context) {
              RegisterBloc _registerBloc = RegisterBloc(
                userRepository: _userRepository,
              );
              return _registerBloc;
            },
          ),
        ],
        child: LoginForm(userRepository: _userRepository),
      ),
    );
  }
}
