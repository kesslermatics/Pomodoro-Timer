import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

typedef CallbackSetting = void Function(String, int);

class ProductivityButton extends StatelessWidget {
  const ProductivityButton(
      {required this.color,
      required this.text,
      this.size = 0,
      required this.onPressed});

  final Color color;
  final String text;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: this.onPressed,
      color: this.color,
      minWidth: this.size,
      child: Text(
        this.text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton(
      {required this.color,
      required this.text,
      required this.value,
      required this.setting,
      required this.callbackSetting});

  final Color color;
  final String text;
  final int value;
  final String setting;
  final CallbackSetting callbackSetting;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        this.text,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => this.callbackSetting(this.setting, this.value),
      color: this.color,
    );
  }
}
