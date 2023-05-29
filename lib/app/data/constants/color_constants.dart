import 'package:flutter/material.dart';

abstract class ConstantsColor {

  static const Color backgroundDarkColor = Color.fromRGBO(17, 8, 35, 1);
  static const Color purpleColor = Color.fromRGBO(147, 117, 185, 1);

  ///purple gradient
  static const Gradient buttonGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color.fromRGBO(33, 35, 59, 1), Color.fromRGBO(33, 20, 52, 1)]
  );

  ///purple gradient
  static const Gradient pinkGradient = LinearGradient(
      colors: [
        Color.fromRGBO(128, 34, 208, 1),
        Color.fromRGBO(200, 32, 203, 0.82),
        Color.fromRGBO(242, 142, 206, 1),
        Color.fromRGBO(241, 130, 144, 1),
      ]
  );



}