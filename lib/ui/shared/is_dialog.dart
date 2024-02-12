import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<bool?> showConfirm({
  required BuildContext context,
  String? title,
  String? content,
  String? confirmationText,
  String? cancelText,
}) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(cancelText ?? 'Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(confirmationText ?? 'Confirmar'),
          ),
        ],
      );
    },
  );
}

Future<bool?> showAlert({
  required BuildContext context,
  String? title,
  String? textContent,
  String? confirmationText,
}) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: title != null ? Text(title) : null,
        content: textContent != null ? Text(textContent) : null,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(confirmationText ?? 'Ok'),
          ),
        ],
      );
    },
  );
}

String getErrorMessage(FirebaseException ex) {
  switch (ex.code) {
    case 'invalid-email':
      return 'O e-mail informado é inválido.';
    case 'user-disabled':
      return 'O usuário está desabilitado.';
    case 'user-not-found':
      return 'O usuário não foi encontrado.';
    case 'wrong-password':
      return 'A senha está incorreta.';
    case 'email-already-in-use':
      return 'O e-mail informado já está em uso.';
    case 'operation-not-allowed':
      return 'A operação não é permitida.';
    case 'weak-password':
      return 'A senha informada é muito fraca.';
    default:
      return 'Ocorreu um erro inesperado.';
  }
}
