import 'package:flutter/material.dart';

class ISScreenButton extends StatelessWidget {
  final String texto;
  final String rota;
  final VoidCallback? onPressed;
  const ISScreenButton({
    super.key,
    required this.texto,
    required this.rota,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!.call();
        }
        Navigator.of(context).pushNamed(rota);
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(11.0),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(
            horizontal: 5,
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          Theme.of(context).textTheme.bodyLarge!,
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.surface,
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.tertiary,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 3.0,
            ),
          ),
        ),
      ),
      child: Text(
        texto,
        textAlign: TextAlign.center,
      ),
    );
  }
}
