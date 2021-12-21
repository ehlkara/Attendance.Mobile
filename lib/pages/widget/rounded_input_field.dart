import 'package:flutter/material.dart';
import 'package:education_systems_mobile/pages/widget/text_field_container.dart';
import 'package:education_systems_mobile/pages/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onSaved;
  final ValueChanged<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final focusNode;
  final String text;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.focusNode,
    this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text,style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16
              ),),
            ],
          ),
          TextFormField(
            key: new Key('id'),
            autocorrect: false,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              hintText: hintText,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 3.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 3.0),
              ),
              errorBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: kErrorColor, width: 3.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kErrorColor, width: 3.0),
              ),
            ),
            validator: validator,
            onSaved: onSaved,
            onFieldSubmitted: onFieldSubmitted,
            focusNode: focusNode,
          ),
        ],
      ),
    );
  }
}
