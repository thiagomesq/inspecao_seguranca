// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inspecao_seguranca/ui/shared/is_dialog.dart';
import 'package:logging/logging.dart';

class ISFutureExecutor<T> extends StatefulWidget {
  final Future<T> Function(BuildContext) futureBuilder;
  final Widget Function(BuildContext, bool, VoidCallback) builder;
  final String? confirmDialogTitle;
  final String? confirmDialogContent;
  final String? confirmationText;
  final String? cancelText;
  final bool isOverlay;

  final Function(BuildContext, T)? onOk;
  final Function(BuildContext, dynamic)? onError;

  const ISFutureExecutor({
    required this.futureBuilder,
    required this.builder,
    this.onOk,
    this.onError,
    this.confirmDialogContent,
    this.confirmationText,
    this.cancelText,
    super.key,
    this.isOverlay = false,
    this.confirmDialogTitle,
  });

  @override
  State<ISFutureExecutor> createState() => _ISFutureExecutorState();
}

class _ISFutureExecutorState extends State<ISFutureExecutor> {
  var loading = false;
  Completer<void>? completer;

  final logger = Logger('_LCFutureExecutorState');

  late OverlayEntry overlay;

  @override
  void initState() {
    super.initState();

    overlay = createOverlay();
  }

  @override
  void dispose() {
    if (overlay.mounted) {
      overlay.remove();
    }
    overlay.removeListener(() {});
    overlay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorsScheme = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: () async {
        if (loading) {
          ScaffoldMessenger.of(context).showSnackBar(_snackbar(
              'Wait for the operation to finish',
              colorsScheme.onBackground,
              colorsScheme.secondary));
          return false;
        }
        return true;
      },
      child: widget.builder(
          context, widget.isOverlay ? false : loading, () => onPressed()),
    );
  }

  Future<void> onPressed() async {
    if (widget.confirmDialogTitle != null ||
        widget.confirmDialogContent != null) {
      final confirm = (await showConfirm(
            context: context,
            title: widget.confirmDialogTitle,
            content: widget.confirmDialogContent ?? '',
            confirmationText: widget.confirmationText ?? 'Confirm',
            cancelText: widget.cancelText ?? 'Cancel',
          )) ??
          false;

      if (!confirm) {
        return;
      }
    }

    setState(() {
      loading = true;
    });
    try {
      if (widget.isOverlay) {
        //Create an overlay that will execute a future and show a loader while it is running
        Overlay.of(context).insert(overlay);

        await mountOverlay();
      }
      var future = widget.futureBuilder(context);

      final res = await future;

      if (mounted) {
        if (widget.onOk != null) {
          widget.onOk!(context, res);
        }
        setState(() {
          loading = false;
          if (overlay.mounted) {
            overlay.remove();
          }
        });
      }
    } on FirebaseException catch (ex) {
      setState(() {
        loading = false;
        if (overlay.mounted) {
          overlay.remove();
        }
      });

      await showAlert(
        context: context,
        title: 'An error has occurred!',
        textContent: getErrorMessage(ex),
      );

      widget.onError?.call(context, ex);
    } catch (ex, stack) {
      logger.warning(ex.toString(), ex, stack);

      setState(() {
        loading = false;
        if (overlay.mounted) {
          overlay.remove();
        }
      });

      await showAlert(
        context: context,
        title: 'An error has occurred!',
        textContent: ex.toString(),
      );
      widget.onError?.call(context, ex);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> mountOverlay() async {
    completer = Completer<void>();

    overlay.addListener(() {
      if (overlay.mounted && !(completer?.isCompleted ?? false)) {
        completer!.complete();
      }
    });

    return completer!.future;
  }

  SnackBar _snackbar(text, Color color, Color backColor) => SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 6.0,
        backgroundColor: backColor,
        duration: const Duration(seconds: 2),
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );

  OverlayEntry createOverlay() {
    return OverlayEntry(
      builder: (context) {
        return Container(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.50),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
