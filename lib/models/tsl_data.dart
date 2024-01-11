import 'dart:async';
import 'package:inspecao_seguranca/models/empresa.dart';
import 'package:inspecao_seguranca/models/funcao.dart';
import 'package:inspecao_seguranca/models/localidade.dart';
import 'package:inspecao_seguranca/models/motorista_operador.dart';
import 'package:inspecao_seguranca/models/questao_campo.dart';
import 'package:inspecao_seguranca/models/questao_comissio_veiculo.dart';
import 'package:inspecao_seguranca/models/questao_veiculo.dart';
import 'package:inspecao_seguranca/models/resposta_campo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inspecao_seguranca/models/resposta_comissio_veiculo.dart';
import 'package:inspecao_seguranca/models/resposta_veiculo.dart';
import 'package:inspecao_seguranca/models/tipo_veiculo.dart';
import 'package:inspecao_seguranca/models/usuario_tst.dart';
import 'package:inspecao_seguranca/models/veiculo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'finalidade_veiculo.dart';

class TSLData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static late final SharedPreferences prefs;
  static User? _user;
  static UsuarioTST? _usuario;

  void carregaPrefs() async {
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {}
  }

  void carregaUser() {
    _auth.authStateChanges().listen((event) {
      _user = event;
    });
    _user = _auth.currentUser;
  }

  UsuarioTST? getUsuario() {
    return _usuario;
  }

  Stream<List<Empresa>> getEmpresas() {
    return _firestore.collection('empresas').orderBy('nome').snapshots().map(
        (event) => event.docs.map((e) => Empresa.fromMap(e.data())).toList());
  }

  FutureOr<List<Empresa>> getEmpresasFiltradas(String nome) {
    return _firestore.collection('empresas').orderBy('nome').get().then(
          (value) => value.docs
              .map((e) => Empresa.fromMap(e.data()))
              .toList()
              .where(
                (element) =>
                    element.nome.toLowerCase().startsWith(nome.toLowerCase()),
              )
              .toList(),
        );
  }

  Stream<List<Empresa>> getEmpresasPorRespostasCampo(
      List<RespostaCampo> respostas) {
    return _firestore.collection('empresas').orderBy('nome').snapshots().map(
        (event) => event.docs
            .map((e) => Empresa.fromMap(e.data()))
            .toList()
            .where((empresa) =>
                respostas.any((resposta) => empresa.nome == resposta.empresa))
            .toList());
  }

  Stream<List<Localidade>> getLocalidades() {
    return _firestore.collection('localidades').orderBy('nome').snapshots().map(
          (event) =>
              event.docs.map((e) => Localidade.fromMap(e.data())).toList(),
        );
  }

  FutureOr<List<Localidade>> getLocalidadesFiltrada(String nome) {
    return _firestore.collection('localidades').orderBy('nome').get().then(
          (value) => value.docs
              .map((e) => Localidade.fromMap(e.data()))
              .toList()
              .where(
                (element) =>
                    element.nome.toLowerCase().startsWith(nome.toLowerCase()),
              )
              .toList(),
        );
  }

  Stream<List<QuestaoCampo>> getQuestoesCampo() {
    return _firestore
        .collection('questoes')
        .orderBy('id')
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return QuestaoCampo.fromMap(e.data());
      }).toList();
    });
  }

  Stream<List<RespostaCampo>> getRespostasCampo({
    required String data,
    required String empresa,
    required String localidade,
  }) {
    return _firestore
        .collection('respostasCampo')
        .where('data', isEqualTo: data)
        .where('empresa', isEqualTo: empresa)
        .where('localidade', isEqualTo: localidade)
        .orderBy('idQuestao')
        .snapshots()
        .asBroadcastStream(
            onListen: (subscription) => subscription.onData((event) {
                  event.docs
                      .map((e) => RespostaCampo.fromMap(e.data()))
                      .toList();
                }))
        .map((event) =>
            event.docs.map((e) => RespostaCampo.fromMap(e.data())).toList());
  }

  Stream<List<RespostaCampo>> getRespostasCampoPorData({required String data}) {
    return _firestore
        .collection('respostasCampo')
        .where('data', isEqualTo: data)
        .orderBy('empresa')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => RespostaCampo.fromMap(e.data())).toList());
  }

  Stream<List<RespostaCampo>> getRespostasCampoNaoConformidade(
      {required String data}) {
    return _firestore
        .collection('respostasCampo')
        .where('data', isEqualTo: data)
        .where('opcao', whereNotIn: ['1', 'NA'])
        .orderBy('opcao')
        .orderBy('empresa')
        .orderBy('localidade')
        .orderBy('idQuestao')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => RespostaCampo.fromMap(e.data())).toList());
  }

  void gerarRespostasCampo(
    List<QuestaoCampo> questaoValidaList,
    String data,
    String localidade,
    String empresa,
  ) {
    for (var e in questaoValidaList) {
      var addRespostaData = <String, dynamic>{};
      addRespostaData['idQuestao'] = e.id;
      addRespostaData['questao'] = e.nome;
      addRespostaData['empresa'] = empresa;
      addRespostaData['data'] = data;
      addRespostaData['localidade'] = localidade;
      addRespostaData['opcao'] = '1';
      addRespostaData['dscNC'] = '';
      addRespostaData['usuario'] = _usuario!.nome;
      _firestore
          .collection('respostasCampo')
          .where('idQuestao', isEqualTo: e.id)
          .where('data', isEqualTo: data)
          .where('empresa', isEqualTo: empresa)
          .where('localidade', isEqualTo: localidade)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          _firestore.collection('respostasCampo').doc().set(addRespostaData);
        }
      });
    }
  }

  void updateRespostaCampo(RespostaCampo resposta) {
    _firestore
        .collection('respostasCampo')
        .where('idQuestao', isEqualTo: resposta.idQuestao)
        .where('data', isEqualTo: resposta.data)
        .where('empresa', isEqualTo: resposta.empresa)
        .where('localidade', isEqualTo: resposta.localidade)
        .get()
        .then((value) {
      for (var e in value.docs) {
        var addRespostaData = <String, dynamic>{};
        addRespostaData['idQuestao'] = resposta.idQuestao;
        addRespostaData['questao'] = resposta.questao;
        addRespostaData['empresa'] = resposta.empresa;
        addRespostaData['data'] = resposta.data;
        addRespostaData['localidade'] = resposta.localidade;
        addRespostaData['opcao'] = resposta.opcao;
        addRespostaData['dscNC'] = resposta.dscNC;
        addRespostaData['usuario'] = _usuario!.nome;
        e.reference.set(addRespostaData);
      }
    });
  }

  void upadateDscNCCampo(String dscNCOld, String dscNCNew) {
    _firestore
        .collection('respostasCampo')
        .where('dscNC', isEqualTo: dscNCOld)
        .get()
        .then((value) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> e in value.docs) {
        var addRespostaData = e.data();
        addRespostaData['dscNC'] = dscNCNew;
        addRespostaData['usuario'] = _usuario!.nome;
        e.reference.set(addRespostaData);
      }
    });
  }

  void deleteRespostasCampo(String veiculo, String data, String localidade) {
    _firestore
        .collection('respostasCampo')
        .where('veiculo', isEqualTo: veiculo)
        .where('data', isEqualTo: data)
        .where('localidade', isEqualTo: localidade)
        .get()
        .then((value) {
      for (var e in value.docs) {
        e.reference.delete();
      }
    });
  }

  void deleteRespostasVeiculo(String veiculo, String data, String localidade) {
    _firestore
        .collection('respostasVeiculo')
        .where('veiculo', isEqualTo: veiculo)
        .where('data', isEqualTo: data)
        .where('localidade', isEqualTo: localidade)
        .get()
        .then((value) {
      for (var e in value.docs) {
        e.reference.delete();
      }
    });
  }

  void updateRespostasCampo(String data, String localidade) {
    _firestore
        .collection('respostasCampo')
        .where('data', isEqualTo: data)
        .where('localidade', isEqualTo: localidade)
        .get()
        .then((value) {
      for (var e in value.docs) {
        var addRespostaData = e.data();
        addRespostaData['data'] = '06/05/2021';
        addRespostaData['usuario'] = _usuario!.nome;
        e.reference.set(addRespostaData);
      }
    });
  }

  Stream<List<QuestaoVeiculo>> getQuestoesVeiculo() {
    return _firestore
        .collection('questoesVeiculo')
        .orderBy('id')
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return QuestaoVeiculo.fromMap(e.data());
      }).toList();
    });
  }

  Stream<List<RespostaVeiculo>> getRespostasVeiculo(
      {required String data,
      required String veiculo,
      required String localidade}) {
    return _firestore
        .collection('respostasVeiculo')
        .where('data', isEqualTo: data)
        .where('veiculo', isEqualTo: veiculo)
        .where('localidade', isEqualTo: localidade)
        .orderBy('idQuestao')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => RespostaVeiculo.fromMap(e.data())).toList());
  }

  Stream<List<RespostaVeiculo>> getRespostasVeiculoNaoConformidade({
    required String data,
  }) {
    return _firestore
        .collection('respostasVeiculo')
        .where('data', isEqualTo: data)
        .where('opcao', isNotEqualTo: '1')
        .orderBy('opcao')
        .orderBy('veiculo')
        .orderBy('idQuestao')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => RespostaVeiculo.fromMap(e.data())).toList());
  }

  Stream<List<RespostaVeiculo>> getRespostasVeiculoPorData(
      {required String data}) {
    return _firestore
        .collection('respostasVeiculo')
        .where('data', isEqualTo: data)
        .orderBy('veiculo')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => RespostaVeiculo.fromMap(e.data())).toList());
  }

  Stream<List<QuestaoComissioVeiculo>> getQuestoesComissioVeiculo() {
    return _firestore
        .collection('questoesComissioVeiculo')
        .orderBy('id')
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        return QuestaoComissioVeiculo.fromMap(e.data());
      }).toList();
    });
  }

  Stream<List<RespostaComissioVeiculo>> getRespostasComissioVeiculo(
      {required String data, required String veiculo}) {
    return _firestore
        .collection('respostasComissioVeiculo')
        .where('data', isEqualTo: data)
        .where('veiculo', isEqualTo: veiculo)
        .orderBy('idQuestao')
        .snapshots()
        .map((event) => event.docs
            .map((e) => RespostaComissioVeiculo.fromMap(e.data()))
            .toList());
  }

  Stream<List<RespostaComissioVeiculo>>
      getRespostasComissioVeiculoNaoConformidade({
    required String data,
  }) {
    return _firestore
        .collection('respostasComissioVeiculo')
        .where('data', isEqualTo: data)
        .where('opcao', isNotEqualTo: '1')
        .orderBy('opcao')
        .orderBy('veiculo')
        .orderBy('idQuestao')
        .snapshots()
        .map((event) => event.docs
            .map((e) => RespostaComissioVeiculo.fromMap(e.data()))
            .toList());
  }

  Stream<List<TipoVeiculo>> getTipoVeiculo() {
    return _firestore
        .collection('tiposVeiculos')
        .orderBy('nome')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => TipoVeiculo.fromMap(e.data())).toList());
  }

  Stream<List<FinalidadeVeiculo>> getFinalidadeVeiculo() {
    return _firestore
        .collection('finalidadesVeiculos')
        .orderBy('nome')
        .snapshots()
        .map((event) => event.docs
            .map((e) => FinalidadeVeiculo.fromMap(e.data()))
            .toList());
  }

  Stream<List<Veiculo>> getVeiculos() {
    return _firestore
        .collection('veiculos')
        .orderBy('empresa')
        .orderBy('placa')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Veiculo.fromMap(e.data())).toList());
  }

  FutureOr<List<Veiculo>> getVeiculosFiltrados(String placa) {
    return _firestore
        .collection('veiculos')
        .orderBy('empresa')
        .orderBy('placa')
        .get()
        .then(
          (value) => value.docs
              .map((e) => Veiculo.fromMap(e.data()))
              .toList()
              .where(
                (element) => element.placa!
                    .toLowerCase()
                    .startsWith(placa.toLowerCase()),
              )
              .toList(),
        );
  }

  Stream<List<Veiculo>> getVeiculosPorRespostas(
      List<RespostaVeiculo> respostas) {
    return _firestore.collection('veiculos').orderBy('placa').snapshots().map(
        (event) => event.docs
            .map((e) => Veiculo.fromMap(e.data()))
            .toList()
            .where((veiculo) =>
                respostas.any((resposta) => veiculo.placa == resposta.veiculo))
            .toList());
  }

  Stream<List<Veiculo>> getVeiculosPorRespostasComissio(
      List<RespostaComissioVeiculo> respostas) {
    return _firestore.collection('veiculos').orderBy('placa').snapshots().map(
        (event) => event.docs
            .map((e) => Veiculo.fromMap(e.data()))
            .toList()
            .where((veiculo) =>
                respostas.any((resposta) => veiculo.placa == resposta.veiculo))
            .toList());
  }

  Stream<List<MotoristaOperador>> getMotoristasOperadores() {
    return _firestore
        .collection('motoristasOperadores')
        .orderBy('nome')
        .snapshots()
        .map((event) => event.docs
            .map((e) => MotoristaOperador.fromMap(e.data()))
            .toList());
  }

  FutureOr<List<MotoristaOperador>> getMotoristasOperadoresFiltrados(
    String nome,
  ) {
    return _firestore
        .collection('motoristasOperadores')
        .orderBy('nome')
        .get()
        .then(
          (value) => value.docs
              .map((e) => MotoristaOperador.fromMap(e.data()))
              .toList()
              .where(
                (element) =>
                    element.nome!.toLowerCase().startsWith(nome.toLowerCase()),
              )
              .toList(),
        );
  }

  void addVeiculo(
    String newPlaca,
    int? newAno,
    String newTipo,
    String newEmpresa,
    String? newRegistro,
    bool isLaudo,
    String newFinalidade,
  ) {
    var addVeiculoData = <String, dynamic>{};
    addVeiculoData['placa'] = newPlaca;
    addVeiculoData['ano'] = newAno;
    addVeiculoData['tipo'] = newTipo;
    addVeiculoData['empresa'] = newEmpresa;
    addVeiculoData['registro'] = newRegistro;
    addVeiculoData['laudo'] = isLaudo;
    addVeiculoData['finalidade'] = newFinalidade;
    addVeiculoData['usuario'] = _usuario!.nome;
    _firestore.collection('veiculos').doc().set(addVeiculoData);
  }

  void addMotoristaOperador(
    String newNome,
    String newFuncao,
    String newCNH,
    String newCategoria,
    String newValidade,
  ) {
    var addMotoristaOperadorData = <String, dynamic>{};
    addMotoristaOperadorData['nome'] = newNome;
    addMotoristaOperadorData['funcao'] = newFuncao;
    addMotoristaOperadorData['cnh'] = newCNH;
    addMotoristaOperadorData['categoria'] = newCategoria;
    addMotoristaOperadorData['validade'] = newValidade;
    addMotoristaOperadorData['usuario'] = _usuario!.nome;
    _firestore
        .collection('motoristasOperadores')
        .doc()
        .set(addMotoristaOperadorData);
  }

  void addFuncao(String newNome) {
    var addFuncaoData = <String, dynamic>{};
    addFuncaoData['nome'] = newNome;
    addFuncaoData['usuario'] = _usuario!.nome;
    _firestore.collection('funcoes').doc().set(addFuncaoData);
  }

  void addEmpresa(String newNome) {
    var addEmpresaData = <String, dynamic>{};
    addEmpresaData['nome'] = newNome;
    addEmpresaData['usuario'] = _usuario!.nome;
    _firestore.collection('empresas').doc().set(addEmpresaData);
  }

  void deleteVeiculo(Veiculo veiculo) {
    _firestore
        .collection('veiculos')
        .where('placa', isEqualTo: veiculo.placa)
        .get()
        .then((value) {
      for (var e in value.docs) {
        e.reference.delete();
      }
    });
  }

  void deleteMotoristaOperador(MotoristaOperador motoristaOperador) {
    _firestore
        .collection('motoristasOperadores')
        .where('cnh', isEqualTo: motoristaOperador.cnh)
        .get()
        .then((value) {
      for (var e in value.docs) {
        e.reference.delete();
      }
    });
  }

  void deleteFuncao(Funcao funcao) {
    _firestore
        .collection('funcoes')
        .where('nome', isEqualTo: funcao.nome)
        .get()
        .then((value) {
      for (var e in value.docs) {
        e.reference.delete();
      }
    });
  }

  void deleteEmpresa(Empresa funcao) {
    _firestore
        .collection('empresas')
        .where('nome', isEqualTo: funcao.nome)
        .get()
        .then((value) {
      for (var e in value.docs) {
        e.reference.delete();
      }
    });
  }

  void gerarRespostasVeiculo(
    List<QuestaoVeiculo> questaoValidaList,
    String data,
    String localidade,
    String veiculo,
    MotoristaOperador motoristaOperador,
  ) {
    for (var e in questaoValidaList) {
      var addRespostaData = <String, dynamic>{};
      addRespostaData['idQuestao'] = e.id;
      addRespostaData['questao'] = e.nome;
      addRespostaData['veiculo'] = veiculo;
      addRespostaData['data'] = data;
      addRespostaData['localidade'] = localidade;
      addRespostaData['condutor'] = motoristaOperador.nome;
      addRespostaData['validadeHabilitacao'] = motoristaOperador.validade;
      addRespostaData['opcao'] = '1';
      addRespostaData['dscNC'] = '';
      addRespostaData['usuario'] = _usuario!.nome;
      _firestore
          .collection('respostasVeiculo')
          .where('idQuestao', isEqualTo: e.id)
          .where('data', isEqualTo: data)
          .where('veiculo', isEqualTo: veiculo)
          .where('localidade', isEqualTo: localidade)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          _firestore.collection('respostasVeiculo').doc().set(addRespostaData);
        }
      });
    }
  }

  void updateRespostaVeiculo(RespostaVeiculo resposta) {
    _firestore
        .collection('respostasVeiculo')
        .where('idQuestao', isEqualTo: resposta.idQuestao)
        .where('data', isEqualTo: resposta.data)
        .where('veiculo', isEqualTo: resposta.veiculo)
        .where('localidade', isEqualTo: resposta.localidade)
        .get()
        .then((value) {
      for (var e in value.docs) {
        var addRespostaData = <String, dynamic>{};
        addRespostaData['idQuestao'] = resposta.idQuestao;
        addRespostaData['questao'] = resposta.questao;
        addRespostaData['veiculo'] = resposta.veiculo;
        addRespostaData['data'] = resposta.data;
        addRespostaData['localidade'] = resposta.localidade;
        addRespostaData['condutor'] = resposta.condutor;
        addRespostaData['validadeHabilitacao'] = resposta.validadeHabilitacao;
        addRespostaData['opcao'] = resposta.opcao;
        addRespostaData['dscNC'] = resposta.dscNC;
        addRespostaData['usuario'] = _usuario!.nome;
        e.reference.set(addRespostaData);
      }
    });
  }

  void upadateDscNCVeiculo(String dscNCOld, String dscNCNew) {
    _firestore
        .collection('respostasVeiculo')
        .where('dscNC', isEqualTo: dscNCOld)
        .get()
        .then((value) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> e in value.docs) {
        var addRespostaData = e.data();
        addRespostaData['dscNC'] = dscNCNew;
        addRespostaData['usuario'] = _usuario!.nome;
        e.reference.set(addRespostaData);
      }
    });
  }

  void gerarRespostasComissioVeiculo(
    List<QuestaoComissioVeiculo> questaoValidaList,
    String data,
    String veiculo,
  ) {
    for (var e in questaoValidaList) {
      var addRespostaData = <String, dynamic>{};
      addRespostaData['idQuestao'] = e.id;
      addRespostaData['questao'] = e.nome;
      addRespostaData['veiculo'] = veiculo;
      addRespostaData['data'] = data;
      addRespostaData['opcao'] = '1';
      addRespostaData['dscNC'] = '';
      addRespostaData['usuario'] = _usuario!.nome;
      _firestore
          .collection('respostasComissioVeiculo')
          .where('idQuestao', isEqualTo: e.id)
          .where('data', isEqualTo: data)
          .where('veiculo', isEqualTo: veiculo)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          _firestore
              .collection('respostasComissioVeiculo')
              .doc()
              .set(addRespostaData);
        }
      });
    }
  }

  void updateRespostaComissioVeiculo(RespostaComissioVeiculo resposta) {
    _firestore
        .collection('respostasComissioVeiculo')
        .where('idQuestao', isEqualTo: resposta.idQuestao)
        .where('data', isEqualTo: resposta.data)
        .where('veiculo', isEqualTo: resposta.veiculo)
        .get()
        .then((value) {
      for (var e in value.docs) {
        var addRespostaData = <String, dynamic>{};
        addRespostaData['idQuestao'] = resposta.idQuestao;
        addRespostaData['questao'] = resposta.questao;
        addRespostaData['veiculo'] = resposta.veiculo;
        addRespostaData['data'] = resposta.data;
        addRespostaData['opcao'] = resposta.opcao;
        addRespostaData['dscNC'] = resposta.dscNC;
        addRespostaData['usuario'] = _usuario!.nome;
        e.reference.set(addRespostaData);
      }
    });
  }

  void upadateDscNCComissioVeiculo(String dscNCOld, String dscNCNew) {
    _firestore
        .collection('respostasComissioVeiculo')
        .where('dscNC', isEqualTo: dscNCOld)
        .get()
        .then((value) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> e in value.docs) {
        var addRespostaData = e.data();
        addRespostaData['dscNC'] = dscNCNew;
        addRespostaData['usuario'] = _usuario!.nome;
        e.reference.set(addRespostaData);
      }
    });
  }

  Stream<List<Funcao>> getFuncoes() {
    return _firestore.collection('funcoes').orderBy('nome').snapshots().map(
        (event) => event.docs.map((e) => Funcao.fromMap(e.data())).toList());
  }

  Stream<UsuarioTST> getUser() {
    try {
      if (_user == null) {
        return Stream.value(UsuarioTST());
      }
      _firestore
          .collection('usuarios')
          .where('email', isEqualTo: _user!.email)
          .get()
          .then((value) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> e in value.docs) {
          var usuario = e.data();
          usuario['isEmailVerificado'] = _user!.emailVerified;
          e.reference.set(usuario);
        }
      });
      return _firestore
          .collection('usuarios')
          .where('email', isEqualTo: _user!.email)
          .limit(1)
          .snapshots()
          .map((event) => event.docs.map((e) {
                _usuario = UsuarioTST.fromMap(e.data());
                _usuario!.senha = prefs.getString('senha');
                return _usuario!;
              }).first);
    } catch (e) {
      return Stream.value(UsuarioTST());
    }
  }

  Future<String?> logIn(String email, String senha) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _user = userCredential.user;
      if (!_user!.emailVerified) {
        return 'Favor verificar seu e-mail para ter acesso ao sistema.';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return 'Senha incorreta.';
      } else if (e.code == 'user-not-found') {
        return 'Usuário não encontrado.';
      }
    }
    if (_user == null) {
      return 'Não foi possível logar, favor tentar novamente em instantes.';
    }
    await prefs.setString('senha', senha);
    await _firestore
        .collection('usuarios')
        .where('email', isEqualTo: _user!.email)
        .get()
        .then((value) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> e in value.docs) {
        _usuario = UsuarioTST.fromMap(e.data());
        _usuario!.senha = prefs.getString('senha');
      }
    });
    return null;
  }

  Future<String?> createUsuario(
    UsuarioTST usuario,
    String senha,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: usuario.email!,
        password: senha,
      );
      User user = userCredential.user!;
      await user.updateDisplayName(usuario.nome);
      await user.sendEmailVerification();
      var addUsuarioData = <String, dynamic>{};
      addUsuarioData['nome'] = usuario.nome;
      addUsuarioData['email'] = usuario.email;
      addUsuarioData['isEmailVerificado'] = usuario.isEmailVerificado;
      _firestore.collection('usuarios').doc().set(addUsuarioData);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'A senha fornecida é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        return 'Já existe um usuário cadastrado com esse e-mail.';
      }
    } catch (e) {
      return 'Houve um erro inexperado, tente novamente em instantes.';
    }
    return null;
  }

  Future<void> logOut() async {
    await _auth.signOut();
    await prefs.remove('senha');
  }

  Future<String?>? recuperarSenha(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/invalid-email') {
        return 'Email inválido..';
      } else if (e.code == 'auth/user-not-found') {
        return 'Usuário não encontrado';
      }
    } catch (e) {
      return 'Houve um erro inexperado, tente novamente em instantes.';
    }
    return null;
  }

  void addQuestoesVeiculos() {
    var questoes = <String, dynamic>{};
    var nomes = [
      'Ano de fabricação do equipamento - Procedimento Emflors',
      'Documentação do Veículo / equipamento=',
      'Habilitação do motorista / operador segundo a função',
      'Identificação do Operador segundo a habilitação por equipamento',
      'Curso de Direção Defensiva / Reciclagem com menos de 01 ano',
      'Curso sobre Transporte Coletivo de Passageiros',
      'Licença para transporte de passageiros',
      'Licença municipal',
      'Procedimento da atividade',
      'Treinamento do procedimento / conhecimento',
      'Disponibilidade de MANUAL  do equipamento na frente de serviço',
      'Treinamento do PCE / Primeiros Socorros para o motorista',
      'Check list DIÁRIO do veículo',
      'Selo de Inspeção de Segurança da SST',
      'Coletor de resíduos classe I e enxada',
      'KIT de segurança Pessoal do motorista',
      'KIT de segurança do veículo',
      'Tacógrafo em funcionamento',
      'Disponibilidade de compartimento para transporte de ferramentas',
      'Itens obrigatórios de segurança (luzes, alarmes sonoros, setas, extintores)',
      'Etiqueta padrão do extintor',
      'Proteção de partes móveis girantes - para máquinas e equipamentos',
      'Proteção das zonas de perigo dos equipamentos / biombos',
      'Contra pinos / travas de segurança em ganchos e implementos',
      'Sistema de partida em funcionamento',
      'Painel de comando - instrumentos e indicadores',
      'Condições de conforto - estado de conservação dos bancos',
      'Condições de conforto - ar condicionado limpeza e manutenção',
      'Condições da cabine parte interna - limpeza',
      'Buzina em funcionamento',
      'Quebra sol atuante',
      'Avarias que comprometem a segurança',
      'Baterias - proteção dos polos e fixação do conjunto',
      'Fiação elétrica exposta',
      'Nível de óleo do motor, acesso de verificação adequado',
      'Nível de água do radiador',
      'Nível do óleo sistema hidráulico',
      'Lavador de para-brisa/água no reservatório',
      'Limpador de para-brisa em funcionamento',
      'Pisca alerta em funcionamento',
      'Sinalização de advertência em operação',
      'Sirene de ré acoplada a sistema de transmissão',
      'Estado das rodas / trincas/ ausência de porcas',
      'Fechaduras das portas em funcionamento',
      'Estado dos vidros e maçanetas',
      'Freio de estacionemento atuante',
      'Freio de serviço uniforme',
      'Lanternas traseiras em funcionamento',
      'Luz de freio LD / LE',
      'Luz de ré dos dois lados',
      'Pneu step, Macaco, Chave de roda e Triângulo de sinalização',
      'Pneu step não recauchutado para veículos de transporte de passageiro',
      'Estado de conservação dos pneus (desgaste e calibragem)',
      'Proteções contra queda / corrimãos de acesso às plataformas',
      'Acesso ao equipamento / evidências e treinamento',
      'Acesso lateral para inspeção sem subir no equipamento',
      'Estribos / corrimãos/ manípulos sem deformação',
      'Cinto de segurança afivelando',
      'Escapamento, proteção da superfície quente',
      'Estado dos pedais aderentes sem gambiarras',
      'Retrovisores internos e externos conservados e regulados',
      'Sistema de direção operante e sem vazamento',
      'Sistema de suspensão atuante',
      'Sistema hidráulico sem vazamentos',
      'Vazamento de água e óleo fora da regularidade',
      'Isolamento - bloqueio de acesso à  máquinas estacionárias',
      'Chaves de acionamento - emergências - localização correta?',
      'Estrutura de proteção contra tombamentos / capotamentos',
      'Chaves de ignição e procedimento de bloqueio?',
      'Caracteríticas do vaso sob pressão / pressão de trabalho',
      'Identificação / prontuário / relatórios de inspeções do vaso sob pressão',
      'Manômetros mantidos e calibrados regularmente ?',
      'Cilindros de gases bem acondicionados e com dispositivo para transporte',
      'Itens de segurança nas motosserras ?',
      'Caracteres indeléveis nas motosserras',
      'Limpador de párabrisa, freio de estacionamento',
      'Inclinômetro, e instrumentos de painel em funcionamento normal',
      'Sistema de comunicação ( rádio e outros )',
      'Existência de depósitos de combustíveis - licença de operação',
      'Nas operações com roçadeiras / proteção contra lançamento de materiais sólidos',
      'Inspeção dos equipamentos de aplicação de agroquímicos',
      'Check list da torre de vigilância',
      'Check list de quadriciclo / motos / motosserras e motoroçadeiras',
      'Proteção contra projeções de materiais, partículas e substâncias (biombos etc.)',
      'Organização / limpeza do veículo ou equipamento',
    ];
    var paras = <List<String>>[
      ['Veículo'],
      ['Veículo'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Ônibus/Vans'],
      ['Ônibus/Vans'],
      ['Ônibus/Vans'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Ônibus/Vans'],
      ['Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo'],
      ['Veículo', 'Ônibus/Vans'],
      ['Ônibus/Vans'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Equipamentos'],
      ['Equipamentos'],
      ['Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans'],
      ['Veículo', 'Ônibus/Vans'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans'],
      ['Veículo', 'Ônibus/Vans'],
      ['Veículo', 'Ônibus/Vans'],
      ['Veículo', 'Ônibus/Vans'],
      ['Veículo', 'Ônibus/Vans'],
      ['Ônibus/Vans'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Equipamentos'],
      ['Equipamentos'],
      ['Equipamentos'],
      ['Equipamentos'],
      ['Equipamentos'],
      ['Equipamentos'],
      ['Veículo', 'Equipamentos'],
      ['Equipamentos'],
      ['Equipamentos'],
      ['Equipamentos'],
      ['Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Equipamentos'],
      ['Equipamentos'],
      ['Equipamentos'],
      ['Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
      ['Equipamentos'],
      ['Veículo', 'Ônibus/Vans', 'Equipamentos'],
    ];

    for (int i = 0; i <= 84; i++) {
      questoes['id'] = i + 1;
      questoes['nome'] = nomes[i];
      questoes['para'] = paras[i];
      _firestore.collection('questoesVeiculo').doc().set(questoes);
    }
  }
}
