import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Estudiante {
  String cedula = '';
  String nombres = '';
  String apellidos = '';
  String calificacion = '';
  String lugarNacimiento = '';
  String fechaNacimiento = '';
  String sexo = '';
  String estadoCivil = '';

  Estudiante();

  factory Estudiante.fromJson(dynamic json) {
    final newEstudent = Estudiante();

    newEstudent.cedula = json['cedula'] as String;
    newEstudent.nombres = json['nombres'] as String;
    newEstudent.apellidos = json['apellidos'] as String;
    newEstudent.calificacion = json['calificacion'] as String;
    newEstudent.lugarNacimiento = json['lugarNacimiento'] as String;
    newEstudent.fechaNacimiento = json['fechaNacimiento'] as String;
    newEstudent.sexo = json['sexo'] as String;
    newEstudent.estadoCivil = json['estadoCivil'] as String;

    return newEstudent;
  }

  Map toJson() => {
        'cedula': cedula,
        'nombres': nombres,
        'apellidos': apellidos,
        'calificacion': calificacion,
        'lugarNacimiento': lugarNacimiento,
        'fechaNacimiento': fechaNacimiento,
        'sexo': sexo,
        'estadoCivil': estadoCivil
      };
}

class EstudiantesStorage2 {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/estudiantes.txt');
  }

  Future<String> readEstudiantes() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return '0';
    }
  }

  Future<File> writeEstudiantes(String estudiantes) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(estudiantes);
  }
}

class SendEmail extends StatefulWidget {
  const SendEmail({Key? key, required this.title, required this.storage})
      : super(key: key);

  final String title;
  final EstudiantesStorage2 storage;

  @override
  State<SendEmail> createState() => _SendEmailState();
}

List<dynamic> cargarFichero() {
  List<dynamic> _listaEstudiantes = [];

  // Datos para Inciar la App
  final _newEstudiante = Estudiante();

  _newEstudiante.cedula = '';
  _newEstudiante.nombres = '';
  _newEstudiante.apellidos = '';
  _newEstudiante.calificacion = '';
  _newEstudiante.lugarNacimiento = '';
  _newEstudiante.fechaNacimiento = '';
  _newEstudiante.sexo = '';
  _newEstudiante.estadoCivil = '';

  _listaEstudiantes.add(_newEstudiante);

  return _listaEstudiantes;
}

class _SendEmailState extends State<SendEmail> {
  // Datos para Inciar la App
  String jsonEstudiantes = '?';

  final List<dynamic> _listaSelecionada = cargarFichero();

  final emailControler = TextEditingController();

  String asunto = 'Resgistros de Calificaciones de INF-5180 ';

  String cuerpoDelMensaje =
      'Registros de Calificaciones de los Estudiantes de Programación 4\n\n';

  @override
  void initState() {
    super.initState();
    widget.storage.readEstudiantes().then((String value) {
      String jsonEstudianteActual = '';

      adds.add(
        TableRow(children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              'Nombre',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              'Cédula',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              'Calificación',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]),
      );

      if (value != '0' || value != '?') {
        for (var i = 0; i < value.length; i++) {
          if (value[i] == '{') {
            for (var j = i; j < value.length; j++) {
              jsonEstudianteActual += value[j];

              if (value[j] == '}') {
                Estudiante nuevoEstudiante =
                    Estudiante.fromJson(jsonDecode(jsonEstudianteActual));
                _listaSelecionada.add(nuevoEstudiante);

                jsonEstudianteActual = '';
                break;
              }
            }
          }
        }

        _listaSelecionada.removeAt(0);
      }

      setState(() {
        jsonEstudiantes = value;
      });

      for (var i = 0; i < _listaSelecionada.length; i++) {
        cuerpoDelMensaje += 'Nombre: ' +
            _listaSelecionada[i].nombres +
            "\n" +
            'Cédula: ' +
            _listaSelecionada[i].cedula +
            "\n" +
            'Calificación: ' +
            _listaSelecionada[i].calificacion +
            "\n\n";
      }

      for (var i = 0; i < _listaSelecionada.length; i++) {
        adds.add(
          TableRow(children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                _listaSelecionada[i].nombres,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                _listaSelecionada[i].cedula,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                _listaSelecionada[i].calificacion,
              ),
            ),
          ]),
        );
      }
      setState(() {});
    });
  }

  Future<File> guardarFichero(List<dynamic> _listaEstudiantes) {
    String datos = '[ \n';

    for (var i = 0; i < _listaEstudiantes.length; i++) {
      datos += '${jsonEncode(_listaEstudiantes[i])}, \n';
    }

    datos += ']';

    setState(() {
      jsonEstudiantes = datos;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeEstudiantes(datos);
  }

  List<TableRow> adds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                ), //apply padding to all four sides
                child: Image.asset('assets/images/logoUASD.png'),
              ),
              Form(
                //1 Form como raiz de nuestro formulario
                //key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        right: 25,
                        left: 25,
                      ), //apply padding to all four sides
                      child: TextFormField(
                        controller: emailControler,
                        decoration: const InputDecoration(
                          hintText: 'Inserte email de estino',
                          labelText: 'Email',
                        ), //2
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        children: [
                          TableRow(children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                child: const Text('Enviar'),
                                onPressed: () => launchEmail(
                                  toEmail: emailControler.text,
                                  subject: asunto,
                                  massage: cuerpoDelMensaje,
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        //controller: _scrollController,
                        children: adds,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future launchEmail({
    required String toEmail,
    required String subject,
    required String massage,
  }) async {
    Uri url = Uri.parse('mailto:$toEmail?subject=$subject&body=$massage');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
