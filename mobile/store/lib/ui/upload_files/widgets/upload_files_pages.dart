
import 'package:diakron_stores/models/core/taxpayer_type/taxpayer_type.dart';
import 'package:diakron_stores/ui/core/themes/colors.dart';
import 'package:diakron_stores/ui/core/themes/dimens.dart';
import 'package:diakron_stores/ui/core/ui/custom_text_form_field.dart';
import 'package:diakron_stores/ui/upload_files/view_models/upload_files_viewmodel.dart';
import 'package:diakron_stores/ui/upload_files/widgets/file_picker_tile.dart';
import 'package:diakron_stores/ui/core/ui/image_picker_tile.dart';
import 'package:diakron_stores/ui/upload_files/widgets/time_picker_tile.dart';
import 'package:diakron_stores/utils/validation/validators.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Company data
class UploadFilesStep1Page extends StatelessWidget {
  const UploadFilesStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<UploadFilesViewModel>();

    return Form(
      key: vm.step1FormKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            "Datos de la empresa y representante",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          CustomTextFormField(
            labelText: "Razón social / Nombre legal de la empresa",
            controller: vm.companyNameController,
            validator: Validators.required,
          ),

          CustomTextFormField(
            labelText: "Nombre comercial (será visible públicamente)",
            controller: vm.commercialNameController,
            validator: Validators.required,
          ),
          CustomTextFormField(
            labelText: "Categoría (Ej. Restaurante, Heladería, Cafetería)",
            controller: vm.categoryController,
            validator: Validators.required,
          ),
          CustomTextFormField(
            labelText: "Dirección fiscal",
            controller: vm.addressController,
            validator: Validators.required,
          ),

          CustomTextFormField(
            labelText: "Código postal de dirección fiscal",
            controller: vm.postCodeController,
            keyboardType: TextInputType.number,
            validator: Validators.postCode,
          ),

          Column(
            children: [
              Text('Selecciona los días de operación de la empresa'),
              SizedBox(height: 10),
              // Day selector
              ListenableBuilder(
                listenable: vm,
                builder: (context, _) {
                  return SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 0, label: Text('Lu')),
                      ButtonSegment(value: 1, label: Text('Ma')),
                      ButtonSegment(value: 2, label: Text('Mi')),
                      ButtonSegment(value: 3, label: Text('Ju')),
                      ButtonSegment(value: 4, label: Text('Vi')),
                      ButtonSegment(value: 5, label: Text('Sá')),
                      ButtonSegment(value: 6, label: Text('Do')),
                    ],
                    showSelectedIcon: false,
                    emptySelectionAllowed: true,
                    multiSelectionEnabled: true,
                    selected: vm.daysOpen,
                    onSelectionChanged: (newSelection) =>
                        vm.onDaysChanged(newSelection),
                  );
                },
              ),

              const SizedBox(height: 20),

              // 2. La lista de horarios dinámicos
              ListenableBuilder(
                listenable: vm,
                builder: (context, _) {
                  // Creamos la lista de widgets basada en los días seleccionados
                  final selectedIndices = vm.daysOpen.toList()..sort();

                  return Column(
                    children: selectedIndices.map((index) {
                      final error = vm.getErrorMessage(index);
                      final day = vm.weekSchedules[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  ListTile(
                                    trailing:
                                        (day.openTime != null &&
                                            day.closeTime != null)
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.copy_all,
                                              color: Colors.blue,
                                            ),
                                            tooltip: "Copiar a toda la semana",
                                            onPressed: () => _confirmCopy(
                                              context,
                                              vm,
                                              index,
                                            ),
                                          )
                                        : null,

                                    title: Text(
                                      day.dayName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (day.isOpen) ...[
                                    const Divider(height: 1),
                                    TimePickerTile(
                                      label: "Hora de apertura",
                                      time: day.openTime,
                                      onTap: () async {
                                        final t = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        if (t != null) {
                                          vm.updateTime(index, true, t);
                                        }
                                      },
                                    ),
                                    TimePickerTile(
                                      label: "Hora de Cierre",
                                      time: day.closeTime,
                                      onTap: () async {
                                        final t = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        if (t != null) {
                                          vm.updateTime(index, false, t);
                                        }
                                      },
                                    ),
                                    if (error != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Text(
                                          error,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ListenableBuilder(
          //   listenable: vm,
          //   builder: (context, child) {
          //     return Column(
          //       children: List.generate(vm.weekSchedules.length, (index) {
          //         final day = vm.weekSchedules[index];
          //         final error = vm.getErrorMessage(index);

          //         return Card(
          //           margin: const EdgeInsets.symmetric(
          //             vertical: 8,
          //             horizontal: 16,
          //           ),
          //           child: Column(
          //             children: [
          //               ListTile(
          //                 title: Text(
          //                   day.dayName,
          //                   style: const TextStyle(fontWeight: FontWeight.bold),
          //                 ),
          //                 subtitle: Text(day.isOpen ? "Abierto" : "Cerrado"),
          //               ),
          //               if (day.isOpen) ...[
          //                 const Divider(height: 1),
          //                 TimePickerTile(
          //                   label: "Apertura",
          //                   time: day.openTime,
          //                   onTap: () async {
          //                     final t = await showTimePicker(
          //                       context: context,
          //                       initialTime: TimeOfDay.now(),
          //                     );
          //                     if (t != null) vm.updateTime(index, true, t);
          //                   },
          //                 ),
          //                 TimePickerTile(
          //                   label: "Cierre",
          //                   time: day.closeTime,
          //                   onTap: () async {
          //                     final t = await showTimePicker(
          //                       context: context,
          //                       initialTime: TimeOfDay.now(),
          //                     );
          //                     if (t != null) vm.updateTime(index, false, t);
          //                   },
          //                 ),
          //                 if (error != null)
          //                   Padding(
          //                     padding: const EdgeInsets.only(bottom: 8),
          //                     child: Text(
          //                       error,
          //                       style: const TextStyle(
          //                         color: Colors.red,
          //                         fontSize: 12,
          //                       ),
          //                     ),
          //                   ),
          //               ],
          //             ],
          //           ),
          //         );
          //       }),
          //     );
          //   },
          // ),
          ListenableBuilder(
            listenable: vm,
            builder: (context, child) {
              final timeErrorMsj = vm.timeErrorMsj;
              return Column(
                children: [
                  if (timeErrorMsj != null)
                    Text(
                      timeErrorMsj,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  SizedBox(height: 10),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmCopy(BuildContext context, UploadFilesViewModel vm, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Copiar horario?"),
        content: Text(
          "Se aplicará el horario de ${vm.weekSchedules[index].dayName} a todos los demás días.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              vm.copyToAll(index);
              Navigator.pop(context);
            },
            child: const Text("Copiar a todos"),
          ),
        ],
      ),
    );
  }
}

// Billing data
class UploadFilesStep2Page extends StatelessWidget {
  const UploadFilesStep2Page({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<UploadFilesViewModel>();
    return Form(
      key: vm.step2FormKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            "Información fiscal",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          CustomTextFormField(
            labelText: "Correo electrónico de facturación",
            controller: vm.billingEmailController,
            validator: Validators.email,
          ),

          SizedBox(height: 10),

          Text(
            style: TextStyle(fontSize: Dimens.fontMedium),
            "Tipo de contribuyente empresa",
          ),
          SizedBox(height: 10),

          ListenableBuilder(
            listenable: vm,
            builder: (context, _) {
              return RadioGroup<TaxpayerType>(
                groupValue: vm.currentType,
                onChanged: (TaxpayerType? value) {
                  vm.setTaxpayerType(value);
                },
                child: const Column(
                  children: [
                    RadioListTile<TaxpayerType>(
                      title: Text("Persona Moral"),
                      value: TaxpayerType.moral,
                      activeColor: AppColors.greenDiakron1,
                    ),
                    RadioListTile<TaxpayerType>(
                      title: Text("Persona Física"),
                      value: TaxpayerType.physical,
                      activeColor: AppColors.greenDiakron1,
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 10),

          CustomTextFormField(
            labelText: "Régimen fiscal de la empresa",
            controller: vm.taxRegimeController,
            validator: Validators.required,
          ),
          CustomTextFormField(
            labelText: "RFC de la empresa",
            controller: vm.rfcController,
            validator: Validators.rfc,
          ),

          CustomTextFormField(
            labelText: "Banco de operaciones",
            controller: vm.bankController,
            validator: Validators.required,
          ),

          CustomTextFormField(
            labelText: "CLABE",
            controller: vm.clabeController,
            validator: Validators.clabe,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

// Docs data
class UploadFilesStep3Page extends StatelessWidget {
  const UploadFilesStep3Page({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UploadFilesViewModel>();
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          "Logo de la empresa",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ImagePickerTile(
          label: "Logo",
          path: vm.store!.pathLogo,
          onPick: () => _pickImage(context, 'pathLogo'),
        ),

        const Text(
          "Documentación PDF",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        FilePickerTile(
          label: "Identificación Representante",
          path: vm.store!.pathIdRep,
          onPick: () => _pickPDF(context, 'pathIdRep'),
        ),
        FilePickerTile(
          label: "Comprobante de Domicilio",
          path: vm.store!.pathProofAddress,
          onPick: () => _pickPDF(context, 'pathProofAddress'),
        ),
        FilePickerTile(
          label: "Constancia Situación Fiscal",
          path: vm.store!.pathTaxCertificate,
          onPick: () => _pickPDF(context, 'pathTaxCertificate'),
        ),
      ],
    );
  }

  Future<void> _pickPDF(BuildContext context, String field) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      final file = result.files.single;
      // Check 10 MB limit
      if (file.size > 10 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("El archivo supera los 10 MB")),
        );
        return;
      }
      // If its ok the size, save current file path
      context.read<UploadFilesViewModel>().updatePath(field, file.path);
    }
  }

  Future<void> _pickImage(BuildContext context, String field) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Cambiado a Image para mejor experiencia
    );

    if (result != null && result.files.single.path != null) {
      final file = result.files.single;

      // Validación de 2 MB
      if (file.size > 2 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("La imagen supera los 2 MB")),
        );
        return;
      }

      // Actualizar el path en el ViewModel
      // Asegúrate de que el ViewModel notifique el cambio (notifyListeners)
      context.read<UploadFilesViewModel>().updatePath(field, file.path!);
    }
  }
}
