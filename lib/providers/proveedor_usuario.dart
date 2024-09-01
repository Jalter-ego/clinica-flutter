//lib/providers/proveedor_usuario
import 'package:flutter/material.dart';
import 'package:flutter_frontend/modelos/usuario.dart';

class UserProvider with ChangeNotifier {
  Usuario? _user;

  Usuario? get user => _user;

  void setUser(Usuario user) {
    _user = user;
    notifyListeners();
  }
}
