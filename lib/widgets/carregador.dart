import 'package:flutter/material.dart';

import '../constants.dart';

class Carregador extends StatelessWidget {
  const Carregador({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(
          emflorGreen,
        ),
      ),
    );
  }
}
