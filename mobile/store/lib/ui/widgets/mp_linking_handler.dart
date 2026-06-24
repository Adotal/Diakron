import 'package:diakron_stores/data/repositories/user/store_repository.dart';
import 'package:diakron_stores/routing/routes.dart';
import 'package:diakron_stores/ui/core/ui/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// Importa tu Bloc, Provider o Cubit aquí si es necesario
// import 'package:provider/provider.dart';

class MpLinkingHandler extends StatefulWidget {
  const MpLinkingHandler({super.key});

  @override
  State<MpLinkingHandler> createState() => _MpLinkingHandlerState();
}

class _MpLinkingHandlerState extends State<MpLinkingHandler> {
  @override
  void initState() {
    super.initState();

    // Ejecutar inmediatamente después del primer renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Actualizamos el repositorio (esto refresca el caché global del repo)
      await context.read<StoreRepository>().getStore(
        forceRefresh: true,
      );
      // Success de snackbar
      CustomSnackBar.showSuccess(
        context,
        message: '¡Mercado Pago vinculado con éxito!',
      );
      // Volvemos al perfil pasándole la señal de que debe recargar
      context.go('${Routes.profile}?refresh=true');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retornamos un loader muy simple y discreto por si la transición tarda milisegundos.
    // El usuario prácticamente ni verá esta pantalla.
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF009EE3)),
        ),
      ),
    );
  }
}
