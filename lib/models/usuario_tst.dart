class UsuarioTST {
  final String? nome;
  final String? email;
  final bool? isEmailVerificado;
  String? senha;

  UsuarioTST({
    this.nome,
    this.email,
    this.isEmailVerificado,
  });

  factory UsuarioTST.fromMap(Map data) {
    return UsuarioTST(
      nome: data['nome'] ?? '',
      email: data['email'] ?? '',
      isEmailVerificado: data['isEmailVerificado'] ?? false,
    );
  }
}