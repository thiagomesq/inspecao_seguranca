import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecao_seguranca/core/models/plataforma.dart';
import 'package:inspecao_seguranca/ui/pages/empresa/empresa_controller.dart';
import 'package:inspecao_seguranca/ui/pages/usuario/usuario_page.dart';
import 'package:inspecao_seguranca/ui/shared/controller_provider.dart';
import 'package:inspecao_seguranca/ui/shared/is_app_bar.dart';
import 'package:inspecao_seguranca/ui/shared/is_future_button.dart';
import 'package:inspecao_seguranca/ui/shared/is_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EmpresaPage extends StatelessWidget {
  static const routeName = '/empresa';
  const EmpresaPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isWeb = Plataforma.isWeb;
    double width = MediaQuery.of(context).size.width;
    final cnpjMask = MaskTextInputFormatter(
      mask: '##.###.###/####-##',
      filter: {"#": RegExp(r'[0-9]')},
      initialText: '',
    );
    return ControllerScope(
      create: (_) => EmpresaController(
        GetIt.I(),
        GetIt.I(),
      ),
      builder: (context, controller) {
        return Scaffold(
          appBar: !isWeb ? const ISAppBar() : null,
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: !isWeb ? 16 : width * 0.3,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cadastro de Empresa',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Preencha os campos abaixo para cadastrar sua empresa',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Form(
                    child: ListView(
                      children: [
                        ISTextField(
                          keyboardType: TextInputType.number,
                          labelText: 'CNPJ',
                          onChanged: (value) => controller.cnpj = value,
                          inputFormatters: [cnpjMask],
                        ),
                        const SizedBox(height: 16),
                        ISTextField(
                          labelText: 'Nome Fantasia',
                          onChanged: (value) => controller.nomeFantasia = value,
                        ),
                        const SizedBox(height: 16),
                        ISTextField(
                          labelText: 'E-mail',
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => controller.email = value,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Observer(builder: (_) {
                  return ISFutureButton(
                    futureBuilder: (_) => controller.save(),
                    isValid: controller.isFormValid,
                    onOk: (_, __) {
                      Navigator.of(context)
                          .pushReplacementNamed(UsuarioPage.routeName);
                    },
                    child: const Text('Salvar'),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
