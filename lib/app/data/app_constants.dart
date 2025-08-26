import 'package:flutter/material.dart';

const String appName = "TODO AI";

const double kBorderRadius = 8.0;
const double kSpacing = 10.0;
const double kPadding = 18.0;
const double kHorizantalPadding = 18.0;

double kBottomPadding(BuildContext context) {
  return MediaQuery.of(context).padding.bottom;
}

double kTopPadding(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}

double kRightPadding(BuildContext context) {
  return MediaQuery.of(context).padding.right;
}

double kLeftPadding(BuildContext context) {
  return MediaQuery.of(context).padding.left;
}
