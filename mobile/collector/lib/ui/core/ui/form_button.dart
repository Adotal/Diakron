import 'package:diakron_collectors/ui/core/themes/colors.dart';
import 'package:diakron_collectors/ui/core/themes/dimens.dart';
import 'package:diakron_collectors/utils/command.dart';
import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.listenable,
  });

  final String text;
  final VoidCallback onPressed;
  final Command listenable;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Close keyboard and exec onpressed

        FocusManager.instance.primaryFocus?.unfocus();
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(150, 60),
        backgroundColor: AppColors.greenDiakron1,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: ListenableBuilder(
        listenable: listenable,
        builder: (context, _) {
          if (listenable.running) {
            return const SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            );
          }
          return Text(text, style: TextStyle(fontSize: Dimens.fontMedium));
        },
      ),
    );
  }
}