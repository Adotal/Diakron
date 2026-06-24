import 'package:diakron_collectors/ui/core/themes/colors.dart';
import 'package:diakron_collectors/ui/core/ui/custom_alert_dialog.dart';
import 'package:diakron_collectors/ui/home/view_models/home_viewmodel.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load.execute();
    widget.viewModel.setTrackingStatus.addListener(_onSetTracking);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.viewModel.setTrackingStatus.removeListener(_onSetTracking);
    widget.viewModel.setTrackingStatus.addListener(_onSetTracking);
  }

  @override
  void dispose() {
    super.dispose();

    widget.viewModel.setTrackingStatus.removeListener(_onSetTracking);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Permite scroll si la pantalla es pequeña
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.46,
              child: Stack(
                children: [
                  Container(
                    height: size.height * 0.46,
                    width: double.infinity,
                    color: const Color(0xFF38761D),
                  ),
                  Positioned(
                    top: size.height * 0.40,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45),
                        ),
                      ),
                    ),
                  ),
                  _buildHeaderText(size),
                  _buildCharacterImage(size),
                ],
              ),
            ),

            //ÚLTIMOS INGRESOS
            _buildSectionTitle("Tus últimos ingresos."),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _incomeCard("+18 MXN"),
                  _incomeCard("+15 MXN"),
                  _incomeCard("+15 MXN"),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- SECCIÓN 3: RECOLECCIONES SEMANALES ---
            _buildSectionTitle("Cantidad de recolecciones de esta semana."),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dayColumn("Do.", "1", isFirst: true),
                  _dayColumn("Lu.", "7"),
                  _dayColumn("Ma.", "0"),
                  _dayColumn("Mi.", "2"),
                  _dayColumn("Ju.", "3"),
                  _dayColumn("Vi.", "5"),
                  _dayColumn("Sa.", "0", isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE APOYO ---
  Widget _buildHeaderText(Size size) {
    return Positioned(
      top: size.height * 0.08,
      left: 25,
      right:
          25, // Agregado para evitar que textos muy largos se salgan de la pantalla
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Envolvemos el saludo en un Row
          Row(
            children: [
              const Text(
                "Hola, ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28, // Tamaño un poco mayor para destacar
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Flexible evita el error de "overflow" si el nombre de usuario es muy largo
              Flexible(
                child: ListenableBuilder(
                  listenable: widget.viewModel.load,
                  builder: (context, _) {
                    if (widget.viewModel.load.running) {
                      // Reducimos el tamaño del indicador para que encaje en la línea de texto
                      return const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      );
                    } else if (widget.viewModel.load.error) {
                      return const Text(
                        "Error",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else {
                      return Text(
                        widget.viewModel.collector.userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow
                            .ellipsis, // Si es muy largo, muestra "..."
                      );
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 15,
          ), // Separación entre el saludo y la pregunta

          const Text(
            '¿Listo para comenzar\na recolectar?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight
                  .w500, // Un peso intermedio para no competir con el "Hola"
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '¡Activa tu ubicación\npara comenzar!',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 25),
          _buildToggle(),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      width: 200,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          // Mostrar un indicador de carga si está iniciando el GPS
          if (widget.viewModel.isLoading) {
            return const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          return Row(
            children: [
              // BOTÓN ACTIVO
              Expanded(
                child: GestureDetector(
                  // Iniciamos rastreo
                  onTap: () => widget.viewModel.setTrackingStatus.execute(true),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.viewModel.isActive
                          ? const Color(0xFF00C853)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Activo",
                      style: TextStyle(
                        color: widget.viewModel.isActive
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // BOTÓN INACTIVO
              Expanded(
                child: GestureDetector(
                  // Simplemente apagamos
                  onTap: () =>
                      widget.viewModel.setTrackingStatus.execute(false),
                  child: Container(
                    decoration: BoxDecoration(
                      color: !widget.viewModel.isActive
                          ? AppColors
                                .red1 // Asegúrate de importar tus colores
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Inactivo",
                      style: TextStyle(
                        color: !widget.viewModel.isActive
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCharacterImage(Size size) {
    return Positioned(
      top: size.height * 0.15,
      right: 20,
      child: SizedBox(
        width: 120,
        child: Image.asset(
          'assets/images/standing_man.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _incomeCard(String amount) {
    return Container(
      width: 110,
      height: 110,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF2E6118),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Text(
        amount,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _dayColumn(
    String day,
    String count, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFF4C9127), // Verde de los días
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            day,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFE8E9A1), // Color crema de los números
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            count,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _onSetTracking() {
    if (widget.viewModel.setTrackingStatus.error) {
      widget.viewModel.setTrackingStatus.clearResult;
      _showNotLocationActive();
    }
  }

  void _showNotLocationActive() {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Activar ubicación',
        content:
            'Debes activar la ubicación para recibir notificación de segregadores llenos!',
        actionText: 'Activar',
        // onPressed: ,
        actionTextColor: const Color.fromARGB(255, 0, 54, 0),
      ),
    );
  }
}
