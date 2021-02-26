import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  hintText: 'Email',
  fillColor: Colors.white,
  filled: true,
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: Color(0xffa442ff0),
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
