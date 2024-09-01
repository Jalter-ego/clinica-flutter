//lib/modelos/usuario.dart
import 'dart:convert';

class Usuario {
  final String id;
  final String ci;
  final String nombre;
  final String email;
  final String token;

  Usuario({
    required this.id,
    required this.ci,
    required this.nombre,
    required this.email,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ci': ci,
      'nombre': nombre,
      'email': email,
      'token': token,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] ?? '',
      ci: map['ci'] ?? '',
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) =>
      Usuario.fromMap(json.decode(source) as Map<String, dynamic>);
}
