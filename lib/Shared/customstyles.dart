import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  hintText: 'Email',
  fillColor: Colors.white,
  filled: true,
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: Color(0xff4c2882),
          width: 2
      )
  ),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: Colors.white,
          width: 2
      )
  ),
);
