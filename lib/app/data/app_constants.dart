import 'package:flutter/material.dart';

const String appName = "TODO AI";

const kBorderRadius = 14.0;
const kSpacing = 10.0;
const kPadding = 18.0;
const kHorizantalPadding = 18.0;

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
