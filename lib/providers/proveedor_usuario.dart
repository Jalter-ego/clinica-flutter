//lib/providers/proveedor_usuario
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  int? _id;
  String? _ci;
  String? _nombre;
  String? _apellido_paterno;
  String? _apellido_materno;
  String? _email;
  String? _telefono;
  String? _rol;
  List<String>? _permisos;
  
  int? get id => _id;
  String? get ci => _ci;
  String? get nombre => _nombre;
  String? get apellido_paterno => _apellido_paterno;
  String? get apellido_materno => _apellido_materno;
  String? get email => _email;
  String? get telefono => _telefono;
  String? get rol => _rol;
  List<String>? get permisos => _permisos;

  // Setters
  set nombre(String? value) {
    _nombre = value;
    notifyListeners(); // Notificar a los oyentes sobre el cambio
  }

  set apellido_paterno(String? value) {
    _apellido_paterno = value;
    notifyListeners();
  }

  set apellido_materno(String? value) {
    _apellido_materno = value;
    notifyListeners();
  }

  // Carga el token desde el almacenamiento seguro y decodifica los datos
  Future<void> loadUserFromToken() async {
    final token = await _storage.read(key: 'token');
    if (token != null && !JwtDecoder.isExpired(token)) {
      final decodedToken = JwtDecoder.decode(token);
      _id = decodedToken['id'];
      _ci = decodedToken['ci'];
      _nombre = decodedToken['nombre'];
      _apellido_paterno = decodedToken['apellido_paterno'];
      _apellido_materno = decodedToken['apellido_materno'];
      _email = decodedToken['email'];
      _telefono = decodedToken['telefono'];
      _rol = decodedToken['rol']['nombre'];
      _permisos =
          List<String>.from(decodedToken['permisos'].map((p) => p['nombre']));
      notifyListeners();
    }
  }

  // Guarda el token en el almacenamiento seguro y decodifica los datos
  Future<void> setToken(String token) async {
    await _storage.write(key: 'token', value: token);
    await loadUserFromToken(); // Decodifica y carga los datos automáticamente
  }

  // Borra el token (logout)
  Future<void> clearToken() async {
    await _storage.delete(key: 'token');
    _id=null;
    _ci = null;
    _nombre = null;
    _apellido_paterno = null;
    _apellido_materno = null;
    _email = null;
    _telefono = null;
    _rol = null;
    _permisos = null;
    notifyListeners();
  }
}
