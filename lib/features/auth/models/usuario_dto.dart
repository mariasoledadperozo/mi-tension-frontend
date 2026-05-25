class UsuarioDto {
  final String nombre;
  final String apellidos;
  final String email;
  final DateTime fechaNacimiento;
  final bool tomaMedicina;
  final int sexo;

  UsuarioDto({
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.fechaNacimiento,
    required this.sexo,
    required this.tomaMedicina,
  });

  Map<String, dynamic> toJson() {
    return {
      "nombre": nombre,
      "apellidos": apellidos,
      "fechaNacimiento":
          "${fechaNacimiento.year}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}",
      "sexo": sexo,
      "tomaMedicacion": tomaMedicina,
    };
  }

  factory UsuarioDto.fromJson(Map<String, dynamic> json) {
    return UsuarioDto(
      nombre: json["nombre"] ?? "",
      apellidos: json["apellidos"] ?? "",
      email: json["email"] ?? "",
      fechaNacimiento: DateTime.parse(json["fechaNacimiento"]),
      sexo: json["sexo"] is String
          ? int.tryParse(json["sexo"]) ?? 2
          : json["sexo"] ?? 2,
      tomaMedicina: json["tomaMedicacion"] ?? false,
    );
  }

  static int sexToInt(String? sex) {
    switch (sex) {
      case "Masculino":
        return 0;
      case "Femenino":
        return 1;
      default:
        return 2;
    }
  }

  String get sexoTexto {
    switch (sexo) {
      case 0:
        return "Masculino";
      case 1:
        return "Femenino";
      default:
        return "Otro";
    }
  }
}
