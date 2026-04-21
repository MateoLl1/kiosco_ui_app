import 'package:flutter/material.dart';
import 'package:kiosco_au/config/theme/guardia_theme.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class CitaTile extends StatelessWidget {
  final Cita cita;
  final VoidCallback onTap;

  const CitaTile({
    super.key,
    required this.cita,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final guardia = Theme.of(context).extension<GuardiaTheme>()!;
    final isWide = MediaQuery.of(context).size.width >= 900;
    final estilo = resolverEstiloCita(guardia, colors, cita.claveVisual);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: estilo.fondo,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: estilo.borde,
              width: 2,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 20 : 12,
              vertical: isWide ? 18 : 14,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    cita.horaCita,
                    style: TextStyle(
                      color: estilo.texto,
                      fontSize: isWide ? 24 : 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    cita.placa,
                    style: TextStyle(
                      color: estilo.texto,
                      fontSize: isWide ? 20 : 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cita.nombreCliente,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: estilo.texto,
                          fontSize: isWide ? 19 : 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cita.tipoLabor.replaceAll('_', ' '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: estilo.textoSecundario,
                          fontSize: isWide ? 15 : 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    cita.bahia,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: estilo.texto,
                      fontSize: isWide ? 22 : 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}