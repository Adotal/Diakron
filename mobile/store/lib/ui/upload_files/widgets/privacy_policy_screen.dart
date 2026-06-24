import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:provider/provider.dart';
import 'package:diakron_stores/ui/upload_files/view_models/upload_files_viewmodel.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    // Usamos watch para que el widget se reconstruya cuando cambie isAccepted
    final vm = context.watch<UploadFilesViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Markdown(
                  data: vm.privacyData,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
                const Divider(height: 40),
                Markdown(
                  data: vm.termsData,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ],
            ),
          ),
        ),

        // Checkbox controlado por el ViewModel
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CheckboxListTile(
            title: const Text("He leído y acepto los términos"),
            value: vm.isAccepted,
            onChanged: (val) => vm.setAccepted(val ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      ],
    );
  }
}
