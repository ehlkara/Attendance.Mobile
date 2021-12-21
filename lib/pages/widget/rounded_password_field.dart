import 'package:flutter/material.dart';
import 'package:education_systems_mobile/pages/widget/text_field_container.dart';
import 'package:education_systems_mobile/pages/constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onSaved;
  final ValueChanged<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final focusNode;
  final hintText;
  final String text;


  const RoundedPasswordField({
    Key key,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.focusNode,
    this.hintText,
    this.text
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {

    return TextFieldContainer(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.text,style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16
              ),),
            ],
          ),
          TextFormField(
            key: new Key('password'),
            obscureText: _obscureText,
            autocorrect: false,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              hintText: widget.hintText,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 3.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 3.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kErrorColor, width: 3.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kErrorColor, width: 3.0),
              ),
            ),
            validator: widget.validator,
            onSaved: widget.onSaved,
            onFieldSubmitted: widget.onFieldSubmitted,
            focusNode: widget.focusNode,
          ),
        ],
      ),
    );
  }
}
