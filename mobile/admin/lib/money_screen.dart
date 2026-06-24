import 'dart:convert';
import 'package:diakron_admin/ui/core/ui/custom_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class MoneyScreen extends StatefulWidget {
  const MoneyScreen({super.key});

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  final _logger = Logger();
  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Pagar a tienda',
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await _getPreferenceMP();
                  _launchUrl(result, context);
                },
                child: const Text('Mercado Pago'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _launchUrl(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (!await launchUrl(uri)) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  void _launchUrl(String url, BuildContext context) async {
    final theme = Theme.of(context);
    try {
      await launchUrl(
        Uri.parse(url),
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: theme.colorScheme.surface,
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // If the URL launch fails, an exception will be thrown. (For example, if no browser app is installed on the Android device.)
      debugPrint(e.toString());
    }
  }

  Future<String> _getPreferenceMP() async {
    const url = 'https://diakron-backend.onrender.com/admin-payout-store';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        // ENVIAMOS EL PRECIO REAL
        body: jsonEncode({
          'storeId': 'cd29c1c6-85a0-4434-8e02-147088936794',
          'amount': 140,
          'rep_percentage': 43.33,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _logger.i('Preferencia obtenida: ${data['sandboxURL']}');
        return data['initPoint'] ?? '';
      } else {
        _logger.e('Error del servidor: ${response.body}');
        return '';
      }
    } catch (error) {
      _logger.e('Fallo de conexión: $error');
      return '';
    }
  }
}
