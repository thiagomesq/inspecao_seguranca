import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/ui/shared/controller_base/controller_base.dart';
import 'package:logging/logging.dart';

class _ControllerProvider extends InheritedWidget {
  final dynamic controller;

  const _ControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class ControllerScope<T extends ControllerBase> extends StatefulWidget {
  final T Function(BuildContext context) create;
  final Widget Function(BuildContext context, T controller) builder;
  final Function(BuildContext, T)? onAppResume;

  const ControllerScope({
    super.key,
    required this.create,
    required this.builder,
    this.onAppResume,
  });

  static T of<T extends Object>(BuildContext context) {
    final provider =
        context.getElementForInheritedWidgetOfExactType<_ControllerProvider>();

    if (provider == null) {
      throw Exception('No controller found');
    }

    return (provider.widget as _ControllerProvider).controller;
  }

  @override
  ControllerScopeState<T> createState() => ControllerScopeState<T>();
}

class ControllerScopeState<T extends ControllerBase>
    extends State<ControllerScope<T>> with WidgetsBindingObserver {
  late T controller;

  final logger = Logger('_ControllerScopeState');

  @override
  void initState() {
    super.initState();

    controller = widget.create(context);

    if (widget.onAppResume != null) {
      WidgetsBinding.instance.addObserver(this);
    }

    logger
        .info('${T.toString()} - Create controller => ${controller.hashCode}');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      logger.info('${T.toString()} - App Resume => ${controller.hashCode}');
      widget.onAppResume?.call(context, controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ControllerProvider(
      controller: controller,
      child: Builder(
        builder: (context) {
          return widget.builder(context, controller);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    logger
        .info('${T.toString()} - Dispose Controller => ${controller.hashCode}');

    WidgetsBinding.instance.removeObserver(this);
    controller.onDispose();
  }
}
