import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController _controller;
  final Function(String) _validator;

  EmailField(
      {Key key,
      @required TextEditingController controller,
      @required Function(String) validator})
      : _controller = controller,
        _validator = validator,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: _validator,
      decoration: InputDecoration(
        hintText: "Email",
        contentPadding: EdgeInsets.all(10.0),
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  final TextEditingController _controller;
  final Function(String) _validator;

  PasswordField(
      {Key key,
      @required TextEditingController controller,
      @required Function(String) validator})
      : _controller = controller,
        _validator = validator,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.text,
      obscureText: true,
      autocorrect: false,
      validator: _validator,
      decoration: InputDecoration(
        hintText: "Password",
        contentPadding: EdgeInsets.all(10.0),
      ),
    );
  }
}

class ValidPasswordField extends StatelessWidget {
  final TextEditingController _controller;
  final Function(String) _validator;

  ValidPasswordField(
      {Key key,
      @required TextEditingController controller,
      @required Function(String) validator})
      : _controller = controller,
        _validator = validator,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.text,
      obscureText: true,
      autocorrect: false,
      validator: _validator,
      decoration: InputDecoration(
        hintText: "Re-enter Password",
        contentPadding: EdgeInsets.all(10.0),
      ),
    );
  }
}
