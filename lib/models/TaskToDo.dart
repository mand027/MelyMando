import 'package:flutter/material.dart';

class Task {
  String id;
  String description;
  bool isDone;

  Task({
    this.id,
    this.description,
    this.isDone = false,
  });
}