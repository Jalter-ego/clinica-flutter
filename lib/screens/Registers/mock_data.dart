Map<String, Object> antecedentesMock = {
  "paciente": {
    "id": 1,
    "nombre": "Jhon Said",
    "apellido_paterno": "Andia",
    "apellido_materno": "Merino",
    "email": "jhademels123@gmail.com",
  },
  "fecha_apertura": "2024-11-20T00:00:00.000Z",
  "antecedentes": [
    {
      "antecedente_id": 4,
      "tipo_antecedente": "Operación",
      "descripcion": "Prótesis Ocular",
      "especifico1": "reemplazo",
      "especifico2": "ojo dañado",
      "fecha_evento": "2024-10-16T00:00:00.000Z",
      "fecha_creacion": "2024-11-21T00:00:00.000Z",
      "es_importante": true,
    },
    // Otros elementos...
  ],
};

const consultasMock = [
  {
    "id": 1,
    "tipo_de_consulta": "Consulta oftalmológica general",
    "diagnostico_principal": "Miopía moderada",
    "diagnostico_secundario": "Astigmatismo compuesto",
    "fecha": "2024-11-20T00:00:00.000Z"
  },
  {
    "id": 2,
    "tipo_de_consulta": "Seguimiento oftalmológico",
    "diagnostico_principal": "Glaucoma primario de ángulo cerrado",
    "diagnostico_secundario": "Presbicia",
    "fecha": "2024-11-22T00:00:00.000Z"
  }
];

const diagnosticosMock = [
  {
    "id": 1,
    "consulta_id": 1,
    "descripcion": "Glaucoma confirmado en examen adicional",
    "tipo_diagnostico": "Final",
    "fecha": "2024-11-27T00:00:00.000Z"
  },
  {
    "id": 2,
    "consulta_id": 2,
    "descripcion": "Paciente con signos de glaucoma",
    "tipo_diagnostico": "Preliminar",
    "fecha": "2024-11-27T00:00:00.000Z"
  }
];

const tratamientosMock = [
  {
    "id": 2,
    "consulta_id": 1,
    "descripcion": "Tratamiento modificado para dolor ocular severo",
    "tipo_tratamiento": "farmacológico",
    "medicacion": "Gotas A, Analgésico B",
    "duracion_estimada": "3 semanas",
    "fecha_inicio": "2024-11-27T00:00:00.000Z",
    "fecha_fin": "2024-12-18T00:00:00.000Z",
    "observaciones": "Revisar nuevamente en una semana"
  },
  {
    "id": 4,
    "consulta_id": 2,
    "descripcion": "Tratamiento para ojos",
    "tipo_tratamiento": "farmacológico",
    "medicacion": "Analgésico",
    "duracion_estimada": "2 semanas",
    "fecha_inicio": "2024-11-27T00:00:00.000Z",
    "fecha_fin": "2024-12-03T00:00:00.000Z",
    "observaciones": "Aplicar cada 2 días"
  }
];
