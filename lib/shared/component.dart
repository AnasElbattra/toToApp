import 'package:flutter/material.dart';

 Widget  defaultFormField ({
  Function? onSubmit,
  Function? onChanged,
  Function? onTap,
  required TextEditingController controller,
  required TextInputType type,
  required Function validate,
  required String label,
  required IconData prefixIcon,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: (s) => onSubmit!(s),
      onChanged: (value) {
        onChanged!(value);
      },
      validator: (value) {
        validate(value);
      },
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder()),
      onTap: ()=>onTap!,

    );
