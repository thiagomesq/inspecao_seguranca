import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/models/is_usuario.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/ui/pages/empresa/empresa_page.dart';
import 'package:inspecao_seguranca/ui/pages/home/home_page.dart';
import 'package:inspecao_seguranca/ui/pages/login/login_controller.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_dialog.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  void onValidatedCode(
      BuildContext context, ISUsuario? usuario, bool isNewUser) {
    if (usuario!.id == null) {
      if (isNewUser) {
        Navigator.of(context).pushReplacementNamed(EmpresaPage.routeName);
      } else {
        showAlert(
          context: context,
          title: 'Acesso Negado!',
          textContent: 'Você não tem permissão para acessar nesta plataforma.',
        );
      }
    } else {
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ControllerScope(
      create: (_) => LoginController(
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
        onValidatedCode,
      ),
      builder: (context, controller) {
        final phoneMask = MaskTextInputFormatter(
          mask: '(##) #####-####',
          filter: {"#": RegExp(r'[0-9]')},
          initialText: controller.phone,
        );
        final sendSMSController = TextEditingController();
        return Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Plataforma.isWeb ? width * 0.3 : 20,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/images/logo_ei.png',
                    width: 174.3,
                    height: 170.8,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                Observer(
                  builder: (_) {
                    return !controller.isCodeSent
                        ? ISTextField(
                            controller: sendSMSController,
                            keyboardType: TextInputType.phone,
                            labelText: 'Celular',
                            onChanged: (value) => controller.phone = value,
                            inputFormatters: [
                              phoneMask,
                            ],
                          )
                        : ISTextField(
                            keyboardType: TextInputType.number,
                            labelText: 'Código SMS',
                            onChanged: (value) => controller.smsCode = value,
                          );
                  },
                ),
                const SizedBox(height: 20),
                Observer(
                  builder: (_) {
                    return !controller.isCodeSent
                        ? ISFutureButton(
                            isValid: controller.isFormValid,
                            futureBuilder: (_) {
                              sendSMSController.clear();
                              return controller.sendCode();
                            },
                            child: const Text('Enviar SMS'),
                          )
                        : ISFutureButton(
                            isValid: controller.isSmsCodeValid,
                            futureBuilder: (_) =>
                                controller.validateCode(context),
                            child: const Text('Validar SMS'),
                          );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
