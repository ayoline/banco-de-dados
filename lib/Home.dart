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
  }

  @override
  Widget build(BuildContext context) {
    _salvar();

    return Scaffold(
      appBar: AppBar(
        title: Text('Banco de dados'),
      ),
      body: Column(),
    );
  }
}
