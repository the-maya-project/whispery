import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whispery/helpers/user_repository.dart';
import 'package:whispery/login/login.dart';
import 'package:whispery/register/bloc/bloc.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc;
  RegisterBloc _registerBloc;

  UserRepository get _userRepository => widget._userRepository;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocProviderTree(
        blocProviders: [
          BlocProvider<LoginBloc>(
            builder: (BuildContext context) {
              _loginBloc = LoginBloc(
                userRepository: _userRepository,
              );
              return _loginBloc;
            },
          ),
          BlocProvider<RegisterBloc>(
            builder: (BuildContext context) {
              _registerBloc = RegisterBloc(
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

  @override
  void dispose() {
    _loginBloc.dispose();
    _registerBloc.dispose();
    super.dispose();
  }
}
