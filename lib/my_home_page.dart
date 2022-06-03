import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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

class EstudiantesStorage {
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.storage})
      : super(key: key);

  final String title;
  final EstudiantesStorage storage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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

class _MyHomePageState extends State<MyHomePage> {
  String jsonEstudiantes = '?';
  String? gender;
  String? estadoCivil;
  String _proceso = 'Nuevo Registro';

  final List<dynamic> _listaEstudiantes = cargarFichero();

  var _estudianteActual = Estudiante();

  bool _isDisableNuevo = true;
  bool _isDisableConsultar = false;
  bool _isDisableRegistrar = false;
  bool _isDisableModificar = true;
  bool _isDisableEliminar = true;
  final bool _isDisableEnviar = false;

  var cedulaControler = TextEditingController();
  var nombresControler = TextEditingController();
  var apellidosControler = TextEditingController();
  var calificacionControler = TextEditingController();
  var lugarNacimientoControler = TextEditingController();
  var fechaNacimientoControler = TextEditingController();
  var sexoControler = TextEditingController();
  var estadoCivilControler = TextEditingController();

  void limpiarCampos() {
    cedulaControler.text = '';
    nombresControler.text = '';
    apellidosControler.text = '';
    calificacionControler.text = '';
    lugarNacimientoControler.text = '';
    fechaNacimientoControler.text = '';
  }

  void clickEnNuevo() {
    setState(() {
      _proceso = 'Nuevo Registro';
      _isDisableNuevo = true;
      _isDisableConsultar = false;
      _isDisableRegistrar = false;
      _isDisableModificar = true;
      _isDisableEliminar = true;
    });

    limpiarCampos();
  }

  void clickEnConsultar() {
    String cedula = cedulaControler.text;
    bool encontrado = false;

    for (var estudiante in _listaEstudiantes) {
      if (cedula == estudiante.cedula) {
        _estudianteActual = estudiante;
        encontrado = true;
      }
    }

    if (encontrado) {
      setState(() {
        _proceso = 'Consultar Registro';
        _isDisableNuevo = false;
        _isDisableConsultar = true;
        _isDisableRegistrar = true;
        _isDisableModificar = false;
        _isDisableEliminar = false;
      });

      // Mostrar datos obtenidos
      cedulaControler.text = _estudianteActual.cedula;
      nombresControler.text = _estudianteActual.nombres;
      apellidosControler.text = _estudianteActual.apellidos;
      calificacionControler.text = _estudianteActual.calificacion;

      setState(() {
        gender = _estudianteActual.sexo;
        estadoCivil = _estudianteActual.estadoCivil;
      });

      lugarNacimientoControler.text = _estudianteActual.lugarNacimiento;
      fechaNacimientoControler.text = _estudianteActual.fechaNacimiento;
    }
  }

  void clickEnRegistrar() {
    final _estudiante = Estudiante();

    _estudiante.cedula = cedulaControler.text;
    _estudiante.nombres = nombresControler.text;
    _estudiante.apellidos = apellidosControler.text;
    _estudiante.calificacion = calificacionControler.text;
    _estudiante.lugarNacimiento = lugarNacimientoControler.text;
    _estudiante.fechaNacimiento = fechaNacimientoControler.text;
    _estudiante.sexo = gender.toString();
    _estudiante.estadoCivil = estadoCivil.toString();

    if (_estudiante.cedula == '' ||
        _estudiante.nombres == '' ||
        _estudiante.apellidos == '' ||
        _estudiante.calificacion == '' ||
        _estudiante.lugarNacimiento == '' ||
        _estudiante.fechaNacimiento == '' ||
        _estudiante.sexo == '' ||
        _estudiante.estadoCivil == '') {
      setState(() {
        _proceso = 'Error: Todos los campos son obligatorios';
      });
    } else {
      _listaEstudiantes.add(_estudiante);

      setState(() {
        _proceso = 'Nuevo Registro';
        _isDisableNuevo = true;
        _isDisableConsultar = false;
        _isDisableRegistrar = false;
        _isDisableModificar = true;
        _isDisableEliminar = true;
      });

      guardarFichero(_listaEstudiantes);
      limpiarCampos();
    }
  }

  void clickEnModificar() {
    final _estudiante = Estudiante();
    bool encontrado = false;

    _estudiante.cedula = cedulaControler.text;
    _estudiante.nombres = nombresControler.text;
    _estudiante.apellidos = apellidosControler.text;
    _estudiante.calificacion = calificacionControler.text;
    _estudiante.lugarNacimiento = lugarNacimientoControler.text;
    _estudiante.fechaNacimiento = fechaNacimientoControler.text;
    _estudiante.sexo = gender.toString();
    _estudiante.estadoCivil = estadoCivil.toString();

    if (_estudiante.cedula == '' ||
        _estudiante.nombres == '' ||
        _estudiante.apellidos == '' ||
        _estudiante.calificacion == '' ||
        _estudiante.lugarNacimiento == '' ||
        _estudiante.fechaNacimiento == '' ||
        _estudiante.sexo == '' ||
        _estudiante.estadoCivil == '') {
      setState(() {
        _proceso = 'Error: Todos los campos son obligatorios';
      });
    } else {
      for (var i = 0; i < _listaEstudiantes.length; i++) {
        if (_estudiante.cedula == _listaEstudiantes[i].cedula) {
          _listaEstudiantes[i] = _estudiante;
          encontrado = true;
        }
      }

      if (encontrado) {
        setState(() {
          _proceso = 'Nuevo Registro';
          _isDisableNuevo = true;
          _isDisableConsultar = false;
          _isDisableRegistrar = false;
          _isDisableModificar = true;
          _isDisableEliminar = true;
        });

        guardarFichero(_listaEstudiantes);
        limpiarCampos();
      }
    }
  }

  void clickEnEliminar() {
    var _estudiante = Estudiante();
    bool encontrado = false;

    _estudiante.cedula = cedulaControler.text;

    for (var i = 0; i < _listaEstudiantes.length; i++) {
      if (_estudiante.cedula == _listaEstudiantes[i].cedula) {
        _estudiante = _listaEstudiantes[i];
      }
    }

    encontrado = _listaEstudiantes.remove(_estudiante);

    if (encontrado) {
      setState(() {
        _proceso = 'Nuevo Registro';
        _isDisableNuevo = true;
        _isDisableConsultar = false;
        _isDisableRegistrar = false;
        _isDisableModificar = true;
        _isDisableEliminar = true;
      });

      guardarFichero(_listaEstudiantes);
      limpiarCampos();
    }
  }

  @override
  void initState() {
    super.initState();
    widget.storage.readEstudiantes().then((String value) {
      String jsonEstudianteActual = '';

      // No va a funcionar
      //Estudiante nuevoEstudiante = Estudiante.fromJson(jsonDecode(value));

      if (value != '0' || value != '?') {
        for (var i = 0; i < value.length; i++) {
          if (value[i] == '{') {
            for (var j = i; j < value.length; j++) {
              jsonEstudianteActual += value[j];

              if (value[j] == '}') {
                Estudiante nuevoEstudiante =
                    Estudiante.fromJson(jsonDecode(jsonEstudianteActual));
                _listaEstudiantes.add(nuevoEstudiante);

                jsonEstudianteActual = '';
                break;
              }
            }
          }
        }

        _listaEstudiantes.removeAt(0);
      }

      setState(() {
        jsonEstudiantes = value;
      });
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
              const Padding(
                padding:
                    EdgeInsets.only(top: 30), //apply padding to all four sides
                child: Text(
                  'Registros de Estudiantes de la UASD',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 60), //apply padding to all four sides
                child: Text(
                  '<< $_proceso >>',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                        controller: cedulaControler,
                        decoration: const InputDecoration(
                          hintText: 'Inserte su Cédula',
                          labelText: 'Cédula',
                        ), //2
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        right: 25,
                        left: 25,
                      ), //apply padding to all four sides
                      child: TextFormField(
                        controller: nombresControler,
                        decoration: const InputDecoration(
                          hintText: 'Inserte sus Nombres',
                          labelText: 'Nombres',
                        ), //2
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        right: 25,
                        left: 25,
                      ), //apply padding to all four sides
                      child: TextFormField(
                        controller: apellidosControler,
                        decoration: const InputDecoration(
                          hintText: 'Inserte sus Apellidos',
                          labelText: 'Apellidos',
                        ), //2
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        right: 25,
                        left: 25,
                      ), //apply padding to all four sides
                      child: TextFormField(
                        controller: calificacionControler,
                        decoration: const InputDecoration(
                          hintText: 'Inserte la Calificación Obtenidad',
                          labelText: 'Calificación',
                        ), //2
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        right: 25,
                        left: 25,
                      ), //apply padding to all four sides
                      child: TextFormField(
                        controller: lugarNacimientoControler,
                        decoration: const InputDecoration(
                          hintText: 'Inserte su Lugar de Nacimiento',
                          labelText: 'Lugar de Nacimiento',
                        ), //2
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        right: 25,
                        left: 25,
                      ), //apply padding to all four sides
                      child: TextFormField(
                        controller: fechaNacimientoControler,
                        decoration: const InputDecoration(
                          hintText: 'Inserte su Fecha de Nacimiento',
                          labelText: 'Fecha de Nacimiento',
                        ), //2
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 25,
                        right: 25,
                        left: 25,
                      ), //apply padding to all four sides
                      child: Text('Sexo : '),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 25,
                        left: 25,
                      ), //apply padding to all four sides
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text("Hombre"),
                            leading: Radio(
                                value: "Hombre",
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value.toString();
                                  });
                                }),
                          ),
                          ListTile(
                            title: const Text("Mujer"),
                            leading: Radio(
                                value: "Mujer",
                                groupValue: gender,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value.toString();
                                  });
                                }),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 25,
                        right: 25,
                        left: 25,
                      ), //apply padding to all four sides
                      child: Text('Estado Civil : '),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 25,
                        left: 25,
                      ), //apply padding to all four sides
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text("Soltero"),
                            leading: Radio(
                                value: "Soltero",
                                groupValue: estadoCivil,
                                onChanged: (value) {
                                  setState(() {
                                    estadoCivil = value.toString();
                                  });
                                }),
                          ),
                          ListTile(
                            title: const Text("Casado"),
                            leading: Radio(
                                value: "Casado",
                                groupValue: estadoCivil,
                                onChanged: (value) {
                                  setState(() {
                                    estadoCivil = value.toString();
                                  });
                                }),
                          ),
                          ListTile(
                            title: const Text("Viod@"),
                            leading: Radio(
                                value: "Viudo",
                                groupValue: estadoCivil,
                                onChanged: (value) {
                                  setState(() {
                                    estadoCivil = value.toString();
                                  });
                                }),
                          )
                        ],
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
                                onPressed: _isDisableNuevo
                                    ? null
                                    : () {
                                        clickEnNuevo();
                                      },
                                child: const Text('Nuevo'),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: _isDisableConsultar
                                    ? null
                                    : () {
                                        clickEnConsultar();
                                      },
                                child: const Text('Consultar'),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: _isDisableEnviar
                                    ? null
                                    : () {
                                        Navigator.pushNamed(
                                            context, '/SendEmail');
                                      },
                                child: const Text('Env. Email'),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: _isDisableRegistrar
                                    ? null
                                    : () {
                                        clickEnRegistrar();
                                      },
                                child: const Text('Resgistrar'),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: _isDisableModificar
                                    ? null
                                    : () {
                                        clickEnModificar();
                                      },
                                child: const Text('Modificar'),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: _isDisableEliminar
                                    ? null
                                    : () {
                                        clickEnEliminar();
                                      },
                                child: const Text('Eliminar'),
                              ),
                            ),
                          ]),
                        ],
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
}
