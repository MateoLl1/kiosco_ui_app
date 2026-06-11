class TurneroMedia {
  final int codigo;
  final int agenciaId;
  final int? usuarioId;
  final String bucket;
  final String objetoId;
  final String tipo;
  final int? orden;
  final String estado;
  final DateTime? fecha;
  final DateTime? modificacion;
  final String url;

  const TurneroMedia({
    required this.codigo,
    required this.agenciaId,
    required this.usuarioId,
    required this.bucket,
    required this.objetoId,
    required this.tipo,
    required this.orden,
    required this.estado,
    required this.fecha,
    required this.modificacion,
    required this.url,
  });

  factory TurneroMedia.fromJson(Map<String, dynamic> json) {
    return TurneroMedia(
      codigo: json['codigo'] ?? 0,
      agenciaId: json['agenciaId'] ?? 0,
      usuarioId: json['usuarioId'],
      bucket: json['bucket'] ?? '',
      objetoId: json['objetoId'] ?? '',
      tipo: json['tipo'] ?? '',
      orden: json['orden'],
      estado: json['estado'] ?? '',
      fecha: json['fecha'] == null ? null : DateTime.tryParse(json['fecha']),
      modificacion: json['modificacion'] == null
          ? null
          : DateTime.tryParse(json['modificacion']),
      url: json['url'] ?? '',
    );
  }

  bool get esImagen => tipo.toLowerCase() == 'imagen';

  bool get esVideo => tipo.toLowerCase() == 'video';
}