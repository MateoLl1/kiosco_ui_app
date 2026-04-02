

class Databook {
    final double ccCodigo;
    final double dbCodigo;
    final String dsnPrimerApellido;
    final String dsnPrimerNombre;
    final String dsnSegundoApellido;
    final String dsnSegundoNombre;
    final String sdCivil;
    final String sdCivilNom;
    final String sdFecha1;
    final String sdNacionalidadNom;
    final String sdNombre;
    final String sdNut;
    final String sdProfesion;
    final String sdProfesionNom;
    final String sdSexo;
    final String sdSexoNom;

    Databook({
        required this.ccCodigo,
        required this.dbCodigo,
        required this.dsnPrimerApellido,
        required this.dsnPrimerNombre,
        required this.dsnSegundoApellido,
        required this.dsnSegundoNombre,
        required this.sdCivil,
        required this.sdCivilNom,
        required this.sdFecha1,
        required this.sdNacionalidadNom,
        required this.sdNombre,
        required this.sdNut,
        required this.sdProfesion,
        required this.sdProfesionNom,
        required this.sdSexo,
        required this.sdSexoNom,
    });

    factory Databook.fromJson(Map<String, dynamic> json) => Databook(
        ccCodigo: json["CC_CODIGO"],
        dbCodigo: json["DB_CODIGO"],
        dsnPrimerApellido: json["dsnPrimer_apellido"],
        dsnPrimerNombre: json["dsnPrimer_nombre"],
        dsnSegundoApellido: json["dsnSegundo_apellido"],
        dsnSegundoNombre: json["dsnSegundo_nombre"],
        sdCivil: json["sdCivil"],
        sdCivilNom: json["sdCivilNom"],
        sdFecha1: json["sdFecha_1"],
        sdNacionalidadNom: json["sdNacionalidadNom"],
        sdNombre: json["sdNombre"],
        sdNut: json["sdNut"],
        sdProfesion: json["sdProfesion"],
        sdProfesionNom: json["sdProfesionNom"],
        sdSexo: json["sdSexo"],
        sdSexoNom: json["sdSexoNom"],
    );

    Map<String, dynamic> toJson() => {
        "CC_CODIGO": ccCodigo,
        "DB_CODIGO": dbCodigo,
        "dsnPrimer_apellido": dsnPrimerApellido,
        "dsnPrimer_nombre": dsnPrimerNombre,
        "dsnSegundo_apellido": dsnSegundoApellido,
        "dsnSegundo_nombre": dsnSegundoNombre,
        "sdCivil": sdCivil,
        "sdCivilNom": sdCivilNom,
        "sdFecha_1": sdFecha1,
        "sdNacionalidadNom": sdNacionalidadNom,
        "sdNombre": sdNombre,
        "sdNut": sdNut,
        "sdProfesion": sdProfesion,
        "sdProfesionNom": sdProfesionNom,
        "sdSexo": sdSexo,
        "sdSexoNom": sdSexoNom,
    };
}
