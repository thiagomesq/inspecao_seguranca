import 'package:flutter/material.dart';

class ISAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ISAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      elevation: 15,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
