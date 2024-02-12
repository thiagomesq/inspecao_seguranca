import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

abstract class ControllerBase implements Disposable {
  @protected
  final List<ReactionDisposer> disposers = [];

  @protected
  final List<StreamSubscription<dynamic>> subscriptions = [];

  @override
  void onDispose() {
    for (final d in disposers) {
      d();
    }

    for (final s in subscriptions) {
      s.cancel();
    }
  }
}
