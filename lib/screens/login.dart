import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:inspecao_seguranca/constants.dart';
import 'package:inspecao_seguranca/models/tsl_data.dart';
import 'package:inspecao_seguranca/models/usuario_tst.dart';
import 'package:inspecao_seguranca/screens/tsl_tab_bar.dart';
import 'package:inspecao_seguranca/widgets/carregador.dart';
import 'package:inspecao_seguranca/widgets/custom_route.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    TSLData tslData = TSLData();
    return StreamBuilder<UsuarioTST>(
      stream: tslData.getUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Carregador();
        }
        UsuarioTST? usuario = snapshot.data;
        return FlutterLogin(
          theme: LoginTheme(
            primaryColor: emflorGreen,
          ),
          messages: LoginMessages(
              passwordHint: 'Senha',
              loginButton: 'Login',
              signupButton: 'Registrar',
              confirmPasswordHint: 'Confirmar Senha',
              additionalSignUpFormDescription: 'Informações adicinais para o cadastro.',
              additionalSignUpSubmitButton: 'Enviar',
              signUpSuccess: "Usuário cadastrado com sucesso.\nFoi enviada uma mensagem para o e-mail fornecido,\nfavor verificar para concluir o cadastro.",
              forgotPasswordButton: 'Esqueceu a senha?',
              recoverPasswordIntro: 'Recupere sua senha',
              recoverPasswordDescription: 'Enviaremos uma mensagem para que seja feita a mudança da senha.',
              recoverPasswordButton: 'Recuperar',
              recoverPasswordSuccess: 'Email enviado com sucesso.',
              goBackButton: 'Voltar'
          ),
          title: 'EI Consultoria',
          logo: const AssetImage('images/logo_ei.png'),
          titleTag: titleTag,
          logoTag: logoTag,
          savedEmail: usuario != null && usuario.email != null ? usuario.email! : '',
          savedPassword: usuario != null && usuario.senha != null ? usuario.senha! : '',
          navigateBackAfterRecovery: true,
          loginAfterSignUp: false,
          additionalSignupFields: const [
            UserFormField(keyName: 'Nome'),
          ],
          initialAuthMode: AuthMode.login,
          userValidator: (value) {
            if (!value!.contains('@')) {
              return "Email precisa ter '@'";
            } else if (value.indexOf('@') == value.length) {
              return "Email inválido";
            }
            return null;
          },
          passwordValidator: (value) {
            if (value!.isEmpty) {
              return 'Password is empty';
            }
            return null;
          },
          onLogin: (loginData) {
            return tslData.logIn(loginData.name, loginData.password);
          },
          onSignup: (signupData) {
            UsuarioTST u = UsuarioTST(
              email: signupData.name,
              isEmailVerificado: false,
              nome: signupData.additionalSignupData?['Nome'],
            );
            return tslData.createUsuario(u, signupData.password!);
          },
          onRecoverPassword: (email) {
            return tslData.recuperarSenha(email);
          },
          onSubmitAnimationCompleted: () {
            UsuarioTST? usuario = tslData.getUsuario();
            Navigator.of(context).pushReplacement(FadePageRoute(
              builder: (context) => TSLTabBar(usuario: usuario != null && usuario.nome != null ? usuario.nome! : ''),
            ));
          },
        );
      }
    );
  }
}
