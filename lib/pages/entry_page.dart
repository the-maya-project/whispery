import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whispery/components/long_button.dart';
import 'package:whispery/components/entry_field.dart';
import 'package:whispery/globals/strings.dart';

import 'package:whispery/helpers/user_repository.dart';
import 'package:whispery/helpers/validators.dart';
import 'package:whispery/blocs/register_bloc/bloc.dart';
import 'package:whispery/blocs/login_bloc/bloc.dart';
import 'package:whispery/blocs/authentication_bloc/bloc.dart';

enum FormType { login, register }

class EntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserRepository _userRepository =
        RepositoryProvider.of<UserRepository>(context);

    return MultiBlocProvider(
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
      child: Builder(),
    );
  }
}

class Builder extends StatefulWidget {
  Builder({Key key}) : super(key: key);

  State<Builder> createState() => __BuilderState();
}

class __BuilderState extends State<Builder> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _validPasswordController =
      TextEditingController();

  static final _loginFormKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  bool _enabled = true;

  Widget build(BuildContext context) {
    final LoginBloc _loginBloc = BlocProvider.of<LoginBloc>(context);
    final RegisterBloc _registerBloc = BlocProvider.of<RegisterBloc>(context);

    void _toggle() {
      setState(() {
        _enabled = !_enabled;
      });
    }

    /// Switch to Register form.
    void _moveToRegister() {
      _loginFormKey.currentState.reset();
      setState(() {
        _formType = FormType.register;
      });
    }

    /// Switch to Login form.
    void _moveToLogin() {
      _loginFormKey.currentState.reset();
      setState(() {
        _formType = FormType.login;
      });
    }

    void submit() {
      FormState form = _loginFormKey.currentState;
      form.save();
      if (form.validate()) {
        switch (_formType) {
          case FormType.login:
            _loginBloc.dispatch(
              LoginWithCredentialsPressed(
                email: _emailController.text,
                password: _passwordController.text,
              ),
            );
            break;
          case FormType.register:
            _registerBloc.dispatch(
              Submitted(
                email: _emailController.text,
                password: _passwordController.text,
              ),
            );
            break;
          default:
            return null;
        }
      }
    }

    Widget _buttons() {
      switch (_formType) {
        case FormType.login:
          return Container(
            child: Column(
              children: <Widget>[
                LongButton(
                  text: "Login",
                  onPressed: _enabled ? submit : null,
                ),
                LongButton(
                  text: "Sign Up?",
                  onPressed: _enabled ? _moveToRegister : null,
                )
              ],
            ),
          );
        case FormType.register:
          return Container(
            child: Column(
              children: <Widget>[
                LongButton(
                  text: "Register",
                  onPressed: _enabled ? submit : null,
                ),
                LongButton(
                  text: "Login?",
                  onPressed: _enabled ? _moveToLogin : null,
                )
              ],
            ),
          );
        default:
          return null;
      }
    }

    String _emailValidator(String value) {
      if (value.isEmpty) return Strings.emptyField;
      if (!EmailValidator.validate(value)) return Strings.invalidEmail;
    }

    String _passwordValidator(String value) {
      if (value.isEmpty) return Strings.emptyField;
      if (value.length < 8) return Strings.invalidPassword;
    }

    String _validPasswordValidator(String value) {
      if (value.isEmpty) return Strings.emptyField;
      if (!Validators.isValidPassword(value)) return Strings.invalidPassword;
      if (_validPasswordController.text != _passwordController.text)
        return Strings.passwordMismatch;
    }

    Widget _fields() {
      switch (_formType) {
        case FormType.login:
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: EmailField(
                    controller: _emailController,
                    validator: _emailValidator,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: PasswordField(
                    controller: _passwordController,
                    validator: _passwordValidator,
                  ),
                ),
              ],
            ),
          );
        case FormType.register:
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: EmailField(
                    controller: _emailController,
                    validator: _emailValidator,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: PasswordField(
                    controller: _passwordController,
                    validator: _validPasswordValidator,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ValidPasswordField(
                    controller: _validPasswordController,
                    validator: _validPasswordValidator,
                  ),
                ),
              ],
            ),
          );
        default:
          return null;
      }
    }

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<RegisterEvent, RegisterState>(
            bloc: _registerBloc,
            listener: (BuildContext context, RegisterState state) {
              _toggle();
              if (state.isSubmitting) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Registering...'),
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  );
              }
              if (state.isFailure) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Registration Failure'),
                          Icon(Icons.error),
                        ],
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
              if (state.isSuccess) {
                BlocProvider.of<AuthenticationBloc>(context)
                    .dispatch(LoggedIn());
              }
            },
          ),
          BlocListener<LoginEvent, LoginState>(
            bloc: _loginBloc,
            listener: (BuildContext context, LoginState state) {
              _toggle();
              if (state.isFailure) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Login Failure'), Icon(Icons.error)],
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
              if (state.isSubmitting) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Logging In...'),
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  );
              }
              if (state.isSuccess) {
                BlocProvider.of<AuthenticationBloc>(context)
                    .dispatch(LoggedIn());
              }
            },
          ),
        ],
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _loginFormKey,
            child: ListView(
              children: <Widget>[
                _fields(),
                _buttons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _validPasswordController.dispose();
    super.dispose();
  }
}
