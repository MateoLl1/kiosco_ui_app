import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';

class TurnoAsignadoScreen extends StatelessWidget {
  const TurnoAsignadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [


            Positioned.fill(
              child: CustomPaint(
                painter: HomePainter(
                  primaryColor: colors.primary,
                ),
              ),
            ),

            Positioned(
              top: 16,
              left: 16,
              child: ReturnPageButton()
            ),


            Positioned(
              child: Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        HomeHeader(
                          title: 'Turno asignado', 
                          subtitle: 'Su turno ha sido generado exitosamente'
                        ),
                    
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                          child: Column(
                            children: [
                          
                              Card(
                                color: colors.onSecondary,
                                elevation: 2,
                                shadowColor: colors.onSurface,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical:  30),
                                  child: Column(
                                    children: [
                          
                          
                                      Card(
                                        color: colors.surface,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                          child: Text(
                                            'T-044',style: textStyle.titleLarge,
                                          ),
                                        )
                                      ),
                                      Divider(),
                          
                          
                                      DetalleTurno(
                                        label: 'Cliente', 
                                        descripcion: 'Mateo Llerena', 
                                        icon: Icons.person
                                      ),
                                      DetalleTurno(
                                        label: 'Área', 
                                        descripcion: 'Taller - Servicios', 
                                        icon: Icons.area_chart
                                      ),
                                      DetalleTurno(
                                        label: 'Tiempo est.', 
                                        descripcion: '~15 min', 
                                        icon: Icons.timelapse
                                      ),
                                      DetalleTurno(
                                        label: 'En cola', 
                                        descripcion: '3 persona(s) antes', 
                                        icon: Icons.people
                                      ),
                                
                                      
                          
                          
                                    ],
                                  ),
                                ),
                              ),
                                
                              SizedBox(height: 10,),
                              CustomTextCard(),
                              SizedBox(height: 10,),
                              CustomIconTextButton(
                                texto: 'Volver al inico', 
                                icono: Icons.home, 
                                colorFondo: colors.primary,
                                onTap: () => context.go('/')
                              )
                                
                                
                            ],
                          ),
                        )
                    
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}


class DetalleTurno extends StatelessWidget {
  final String label;
  final String descripcion;
  final IconData icon;

  const DetalleTurno({
    super.key,
    required this.label,
    required this.descripcion,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: textStyle.titleMedium,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              descripcion,
              style: textStyle.bodyLarge,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }
}