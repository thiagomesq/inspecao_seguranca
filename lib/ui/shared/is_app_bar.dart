import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/infra/http/services/auth_service.dart';
import 'package:inspecao_seguranca/ui/pages/home/home_page.dart';
import 'package:inspecao_seguranca/ui/pages/login/login_page.dart';
import 'package:inspecao_seguranca/ui/shared/is_button.dart';

class ISAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ISAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = GetIt.I<AuthService>();
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      elevation: 15,
      actions: [
        ISButton(
          isIconButton: true,
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(HomePage.routeName);
          },
          child: const Icon(Icons.home),
        ),
        ISButton(
          isIconButton: true,
          onPressed: () {
            authService.logout();
            Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
          },
          child: const Icon(Icons.exit_to_app),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
