#!/usr/bin/env dart

import 'dart:async';
import 'dart:io';
import 'package:where/where.dart';

/// Application entry point.
Future main(List<String> arguments) async {
  try {
    exit(await new Application().run(arguments));
  }

  on FileSystemException {
    exit(1);
  }

  on Exception catch (err) {
    print(err);
    exit(2);
  }
}
