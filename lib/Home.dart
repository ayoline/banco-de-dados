import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = caminhoBancoDados.toString() + "banco.db";

    var retornoDB = await openDatabase(localBancoDados, version: 1,
        onCreate: (db, dbVersaoRecente) {
      String sql =
          "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER) ";
      db.execute(sql);
    });
    return retornoDB;
    // print('aberto: ' + retornoDB.isOpen.toString());
  }

  _salvar() async {
    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {"nome": "Alison", "idade": 35};
    int id = await db.insert("usuarios", dadosUsuario);
    print("salvo: $id");
  }

  _listarUsuarios() async {
    Database db = await _recuperarBancoDados();

    // String sql = "SELECT * FROM usuarios WHERE idade = 35 ";
    // String sql = "SELECT * FROM usuarios WHERE idade = 35 OR idade = 36 ";
    // String sql = "SELECT * FROM usuarios WHERE idade BETWEEN 36 AND 37 ";
    // String sql = "SELECT * FROM usuarios WHERE idade IN (35,36) ";
    // String sql = "SELECT * FROM usuarios WHERE nome = 'Alison' ";
    // String sql = "SELECT * FROM usuarios WHERE nome LIKE 'Ali%' ";
    // String sql = "SELECT * FROM usuarios WHERE 1=1 ORDER BY UPPER(nome) ASC ";
    // String sql = "SELECT * FROM usuarios WHERE 1=1 ORDER BY UPPER(nome) DESC ";
    String sql = "SELECT * FROM usuarios ";
    List usuarios = await db.rawQuery(sql);

    for (var usuario in usuarios) {
      print(
        "item id: " +
            usuario["id"].toString() +
            " nome: " +
            usuario["nome"] +
            " idade: " +
            usuario["idade"].toString(),
      );
    }
    // print("usuarios: " + usuarios.toString());
  }

  _recuperarUsuarioPeloId(int id) async {
    Database db = await _recuperarBancoDados();

    // CRUD => Create, Read, Update, Delete
    List usuarios = await db.query(
      "usuarios",
      columns: ["id", "nome", "idade"],
      where: "id = ? ",
      whereArgs: [id],
    );

    for (var usuario in usuarios) {
      print(
        "item id: " +
            usuario["id"].toString() +
            " nome: " +
            usuario["nome"] +
            " idade: " +
            usuario["idade"].toString(),
      );
    }
  }

  _excluirUsuario(int id) async {
    Database db = await _recuperarBancoDados();

    int retorno = await db.delete(
      "usuarios",
      where: "id = ? ",
      whereArgs: [id],
    );

    print("item qtde removida: $retorno");
  }

  _atualizarUsuario(int id) async {
    Database db = await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      "nome": "Joao",
      "idade": 50,
    };

    int retorno = await db.update(
      "usuarios",
      dadosUsuario,
      where: "id = ? ",
      whereArgs: [id],
    );

    print("item qtde atualizada: $retorno");
  }

  @override
  Widget build(BuildContext context) {
    //_salvar();
    //_recuperarUsuarioPeloId(1);
    //_excluirUsuario(1);
    //_listarUsuarios();
    //_atualizarUsuario(2);
    _listarUsuarios();

    return Scaffold(
      appBar: AppBar(
        title: Text('Banco de dados'),
      ),
      body: Column(),
    );
  }
}
