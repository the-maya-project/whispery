import 'package:flutter/material.dart';

class PostField extends StatelessWidget {
  final double _size = 16.0;
  final FormFieldSetter<String> _onSaved;
  final FormFieldValidator<String> _validator;
  final TextEditingController _postController;

  PostField(
      {Key key,
      @required String title,
      @required FormFieldSetter<String> onSaved,
      @required FormFieldValidator<String> validator,
      @required TextEditingController postController })
      : _postController = postController,
        _onSaved = onSaved,
        _validator = validator,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(15.0),
      child: Center(
        child: TextFormField(
          controller: _postController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          autocorrect: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12),
            hintText: 'Whats on fire today?',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.pinkAccent,
                width: 1,
              ),
            ),
          ),
          onSaved: _onSaved,
          validator: _validator,
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.pinkAccent,
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );
  }
}
