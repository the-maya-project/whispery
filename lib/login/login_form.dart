import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whispery/globals/strings.dart';
import 'package:whispery/user_repository.dart';
import 'package:whispery/authentication_bloc/bloc.dart';
import 'package:whispery/login/login.dart' as login;
import 'package:email_validator/email_validator.dart';
import 'package:whispery/validators.dart';
import 'package:whispery/register/bloc/bloc.dart' as register;

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

enum FormType { login, register }

class _LoginFormState extends State<LoginForm> {
  static final _loginFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _validPasswordController =
      TextEditingController();

  // Set inital form type to be login.
  FormType _formType = FormType.login;

  login.LoginBloc _loginBloc;
  register.RegisterBloc _registerBloc;

  // String value for form fields.
  String _email;
  String _password;
  String _validPassword;

  UserRepository get _userRepository => widget._userRepository;

  bool _enabled = true;

  void toggle() {
    setState(() {
      _enabled = !_enabled;
    });
  }

  void submit() {
    FormState form = _loginFormKey.currentState;
    form.save();
    if (form.validate()) {
      switch (_formType) {
        case FormType.login:
          _onLoginSubmitted();
          break;
        case FormType.register:
          _onRegisterSubmitted();
          break;
        default:
          return null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<login.LoginBloc>(context);
    _registerBloc = BlocProvider.of<register.RegisterBloc>(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _validPasswordController.dispose();
    super.dispose();
  }

  /// Switch to Register form.
  void moveToRegister() {
    _loginFormKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  /// Switch to Login form.
  void moveToLogin() {
    _loginFormKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  /// Dispatch login submission.
  void _onLoginSubmitted() {
    _loginBloc.dispatch(
      login.LoginWithCredentialsPressed(
        email: _email,
        password: _password,
      ),
    );
  }

  /// Dispatch register submission.
  void _onRegisterSubmitted() {
    _registerBloc.dispatch(
      register.Submitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  Widget buttons() {
    switch (_formType) {
      case FormType.login:
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: RaisedButton(
                  child: Text("Login"),
                  onPressed: _enabled ? submit : null,
                ),
              ),
              Container(
                child: RaisedButton(
                  child: Text("Sign Up?"),
                  onPressed: _enabled ? moveToRegister : null,
                ),
              ),
            ],
          ),
        );
      case FormType.register:
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: RaisedButton(
                  child: Text("Register"),
                  onPressed: _enabled ? submit : null,
                ),
              ),
              Container(
                child: RaisedButton(
                  child: Text("Login?"),
                  onPressed: _enabled ? moveToLogin : null,
                ),
              ),
            ],
          ),
        );
      default:
        return null;
    }
  }

  Widget fields() {
    switch (_formType) {
      case FormType.login:
        return Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  autocorrect: false,
                  onSaved: (e) => _email = e,
                  validator: (e) {
                    if (e.isEmpty) return Strings.emptyField;
                    if (!EmailValidator.validate(e))
                      return Strings.invalidEmail;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    errorMaxLines: 2,
                  ),
                  autocorrect: false,
                  onSaved: (e) => _password = e,
                  validator: (e) {
                    if (e.isEmpty) return Strings.emptyField;
                    if (e.length < 8) return Strings.invalidPassword;
                  },
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
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  autocorrect: false,
                  onSaved: (e) => _email = e,
                  validator: (e) {
                    if (e.isEmpty) return Strings.emptyField;
                    if (!EmailValidator.validate(e))
                      return Strings.invalidEmail;
                    if (e.length < 8) return Strings.invalidPassword;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    errorMaxLines: 2,
                  ),
                  autocorrect: false,
                  onSaved: (e) => _password = e,
                  validator: (e) {
                    if (e.isEmpty) return Strings.emptyField;
                    if (!Validators.isValidPassword(e))
                      return Strings.invalidPassword;
                    if (_password != _validPassword)
                      return Strings.passwordMismatch;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: _validPasswordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'Reenter Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    errorMaxLines: 2,
                  ),
                  autocorrect: false,
                  onSaved: (e) => _validPassword = e,
                  validator: (e) {
                    if (e.isEmpty) return Strings.emptyField;
                    if (!Validators.isValidPassword(e))
                      return Strings.invalidPassword;
                    if (_password != _validPassword)
                      return Strings.passwordMismatch;
                  },
                ),
              ),
            ],
          ),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListenerTree(
      blocListeners: [
        BlocListener<register.RegisterEvent, register.RegisterState>(
          bloc: _registerBloc,
          listener: (BuildContext context, register.RegisterState state) {
            if (state.isSubmitting) {
              toggle();
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
            if (state.isSuccess) {
              toggle();
              BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
            }
            if (state.isFailure) {
              toggle();
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
          },
        ),
        BlocListener<login.LoginEvent, login.LoginState>(
          bloc: _loginBloc,
          listener: (BuildContext context, login.LoginState state) {
            if (state.isFailure) {
              toggle();
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
              toggle();
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
              toggle();
              BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
            }
          },
        ),
      ],
      child: BlocBuilder(
        bloc: _loginBloc,
        builder: (BuildContext context, login.LoginState state) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _loginFormKey,
              child: ListView(
                children: <Widget>[
                  fields(),
                  buttons(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
