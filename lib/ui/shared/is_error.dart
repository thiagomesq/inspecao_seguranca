import 'package:flutter/material.dart';

class ISError extends StatelessWidget {
  final Object? error;
  final VoidCallback? onReload;
  const ISError({
    super.key,
    this.error,
    this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE5E5E5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 100,
            color: Color(0xFFBDBDBD),
          ),
          const SizedBox(height: 20),
          Text(
            error.toString(),
            style: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          if (onReload != null)
            ElevatedButton(
              onPressed: onReload,
              child: const Text('Recarregar'),
            ),
        ],
      ),
    );
  }
}
