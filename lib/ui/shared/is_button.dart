//A button that can be a text button or an icon button or an elevation button.
import 'package:flutter/material.dart';

class ISButton extends StatefulWidget {
  final Widget? icon;
  final double? height;
  final double? width;
  final Widget child;
  final bool isOutlined;
  final bool isTextButton;
  final bool isIconButton;
  final bool isValid;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  const ISButton({
    super.key,
    required this.child,
    this.icon,
    this.isOutlined = false,
    this.isTextButton = false,
    this.isIconButton = false,
    this.isValid = true,
    this.height,
    this.width,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<ISButton> createState() => _ISButtonState();
}

class _ISButtonState extends State<ISButton> {
  @override
  Widget build(BuildContext context) {
    return widget.isTextButton
        ? TextButton(
            onPressed: widget.isValid ? widget.onPressed : null,
            child: widget.isLoading
                ? const CircularProgressIndicator()
                : widget.child,
          )
        : widget.isOutlined
            ? OutlinedButton(
                onPressed: widget.isValid ? widget.onPressed : null,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30,
                    ),
                  ),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    Theme.of(context).textTheme.bodyMedium!,
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.transparent,
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).colorScheme.onTertiary,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(300.0),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                child: widget.isLoading
                    ? const CircularProgressIndicator()
                    : widget.child,
              )
            : widget.isIconButton
                ? IconButton(
                    onPressed: widget.isValid ? widget.onPressed : null,
                    icon: widget.isLoading
                        ? const CircularProgressIndicator()
                        : widget.child,
                    iconSize: 35,
                    style: ButtonStyle(
                      backgroundColor: widget.backgroundColor != null
                          ? MaterialStateProperty.all<Color>(
                              widget.backgroundColor!,
                            )
                          : null,
                      foregroundColor: widget.foregroundColor != null
                          ? MaterialStateProperty.all<Color>(
                              widget.foregroundColor!,
                            )
                          : null,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(300.0),
                        ),
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: widget.isValid ? widget.onPressed : null,
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(11.0),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        Theme.of(context).textTheme.bodyMedium!,
                      ),
                      backgroundColor: widget.isValid
                          ? MaterialStateProperty.all<Color>(
                              widget.backgroundColor != null
                                  ? widget.backgroundColor!
                                  : Theme.of(context).colorScheme.primary,
                            )
                          : null,
                      foregroundColor: widget.isValid
                          ? MaterialStateProperty.all<Color>(
                              widget.foregroundColor != null
                                  ? widget.foregroundColor!
                                  : Theme.of(context).colorScheme.onPrimary,
                            )
                          : null,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(300.0),
                          side: widget.isValid
                              ? BorderSide(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  width: 1.0,
                                )
                              : BorderSide.none,
                        ),
                      ),
                    ),
                    child: widget.isLoading
                        ? const CircularProgressIndicator()
                        : widget.child,
                  );
  }
}
