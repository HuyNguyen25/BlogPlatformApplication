import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final loadingScreen = Container(
  color: Colors.black,
  child: Center(
    child: SpinKitSpinningLines(
      color: Colors.white,
      size: 50,
    )
  )
);