import 'package:flutter/material.dart';

import 'CustomButtom.dart';

void showDeleteConfirmationModal({
  required BuildContext context,
  required String itemName,
  required VoidCallback onDelete,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Confirmar Eliminación',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        content: Text('¿Estás seguro de que deseas eliminar este $itemName?'),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: CustomButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  textColor: Colors.white,
                  backgroundColor: Colors.blue,
                  text: 'Cancelar',
                ),
              ),
              SizedBox(
                child: CustomButton(
                  onPressed: () {
                    onDelete();
                    Navigator.of(context).pop();
                  },
                  backgroundColor: Colors.red,
                  text: 'Eliminar',
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
