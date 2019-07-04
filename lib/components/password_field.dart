import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final VoidCallback _onSaved;
  final TextEditingController _passwordController;

  PasswordField(
      {Key key, @required VoidCallback onSaved, @required TextEditingController passwordController})
      : _onSaved = onSaved,
        _passwordController = passwordController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      autocorrect: false,
      controller: _passwordController,
      validator: (e) {},
      onSaved: (e) => _onSaved,
      decoration: InputDecoration(
        hintText: "password",
        contentPadding: EdgeInsets.all(10.0),
      ),
    );
  }
}
