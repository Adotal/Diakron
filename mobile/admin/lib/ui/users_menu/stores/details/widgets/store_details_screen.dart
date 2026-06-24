//   Widget build(BuildContext context) {
//     return CustomScreen(
//       // title: 'Detalles del Centro',
import 'dart:convert';

import 'package:diakron_admin/models/core/taxpayer_type/taxpayer_type.dart';
import 'package:diakron_admin/models/core/validation_status/validation_status.dart';
import 'package:diakron_admin/ui/core/ui/custom_network_image.dart';
import 'package:diakron_admin/ui/core/ui/custom_screen.dart';
import 'package:diakron_admin/ui/core/ui/custom_snackbar.dart';
import 'package:diakron_admin/ui/core/ui/file_getter_tile.dart';
import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:diakron_admin/ui/core/themes/dimens.dart';
import 'package:diakron_admin/ui/core/ui/custom_alert_dialog.dart';
import 'package:diakron_admin/ui/core/ui/error_indicator.dart';
import 'package:diakron_admin/ui/core/ui/form_button.dart';
import 'package:diakron_admin/ui/users_menu/stores/details/view_models/store_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class StoreDetailsScreen extends StatefulWidget {
  const StoreDetailsScreen({super.key, required this.viewModel});

  final StoreDetailsViewModel viewModel;

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.deleteStore.addListener(_onDelete);
    widget.viewModel.updateStore.addListener(_onUpdate);
    widget.viewModel.changeValidationStatus.addListener(_onChangedValidation);
    widget.viewModel.payment.addListener(_onPaymentURL);
  }

  @override
  void didUpdateWidget(covariant StoreDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.deleteStore.removeListener(_onDelete);
    widget.viewModel.deleteStore.addListener(_onDelete);

    oldWidget.viewModel.updateStore.removeListener(_onUpdate);
    widget.viewModel.updateStore.addListener(_onUpdate);

    oldWidget.viewModel.changeValidationStatus.removeListener(
      _onChangedValidation,
    );
    widget.viewModel.changeValidationStatus.addListener(_onChangedValidation);

    oldWidget.viewModel.payment.removeListener(_onPaymentURL);
    widget.viewModel.payment.addListener(_onPaymentURL);
  }

  @override
  void dispose() {
    widget.viewModel.deleteStore.removeListener(_onDelete);
    widget.viewModel.updateStore.removeListener(_onUpdate);
    widget.viewModel.changeValidationStatus.removeListener(
      _onChangedValidation,
    );

    widget.viewModel.payment.removeListener(_onPaymentURL);
    // DISPOSE ALL CONTROLLERS
    _usernameController.dispose();
    _surnamesController.dispose();
    _phoneNumberController.dispose();
    _companyNameController.dispose();
    _rfcController.dispose();
    _taxRegimeController.dispose();
    _clabeController.dispose();
    _bankController.dispose();
    _commercialNameController.dispose();
    _addressController.dispose();
    _billingEmailController.dispose();
    _postCodeController.dispose();
    super.dispose();
  }

  // UserBase Text controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _surnamesController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _createdAtController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _rfcController = TextEditingController();
  final TextEditingController _taxRegimeController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _clabeController = TextEditingController();
  final TextEditingController _commercialNameController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _billingEmailController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();

  bool? _isActive;
  Map<String, dynamic>? _schedule;
  String? _validationStatus;

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Tienda',
      // AppBar(
      //   title: const Text("Entity Profile"),
      //   elevation: 0,
      actions: [
        // Edit Toggle
        IconButton(
          icon: Icon(
            widget.viewModel.isEditing
                ? Icons.cancel_outlined
                : Icons.edit_note,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              // Start editing -> Initialize controllers
              if (!widget.viewModel.isEditing) {
                final center = widget.viewModel.store;
                if (center != null) {
                  _usernameController.text = center.userName ?? '';
                  _surnamesController.text = center.surnames ?? '';
                  _phoneNumberController.text = center.phoneNumber ?? '';
                  _createdAtController.text = center.createdAt.toString();
                  _taxRegimeController.text = center.taxRegime ?? '';
                  _clabeController.text = center.clabe ?? '';
                  _bankController.text = center.bank ?? '';
                  _companyNameController.text = center.companyName ?? '';
                  _rfcController.text = center.rfc ?? '';
                  _commercialNameController.text = center.commercialName ?? '';
                  _addressController.text = center.address ?? '';
                  _billingEmailController.text = center.billingEmail ?? '';
                  _postCodeController.text = center.postCode ?? '';

                  _schedule = center.schedule;
                  _validationStatus = center.validationStatus;
                  _isActive = center.isActive;

                  widget.viewModel.toggleEdit();
                }
              } else {
                CustomAlertDialog.show(
                  context: context,
                  title: 'Salir del modo edición',
                  content:
                      '¿Estás seguro de salir del modo edición?\nSe perderán los cambios no guardados',
                  onPressed: () {
                    setState(() {
                      widget.viewModel.toggleEdit();
                    });
                  },
                  actionText: 'Salir',
                );
              }
            });
          },
        ),
        // Delete remains separate
        IconButton(
          icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
          onPressed: () {
            if (widget.viewModel.store?.id != null) {
              _showDeleteConfirm(widget.viewModel.store!.id!);
            }
          },
        ),
      ],
      // ),
      child: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: widget.viewModel.load,
              builder: (context, _) {
                if (widget.viewModel.load.running) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (widget.viewModel.load.error) {
                  return ErrorIndicator(
                    title: "Problem charging Collection Center",
                    label: "Try again",
                    onPressed: widget.viewModel.load.execute,
                  );
                }

                final store = widget.viewModel.store;

                if (store == null) {
                  return Center(
                    child: Text(
                      "No se encontró el store \n ${widget.viewModel.storeId}",
                    ),
                  );
                }

                return Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                      children: [
                        _buildHeaderStatus(
                          status: store.validationStatus ?? 'UPLOADING',
                        ),
                        const SizedBox(height: 24),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // --- TARJETA DE RESUMEN FINANCIERO ---
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Fila 1: Total Comisiones
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total comisiones Diakron',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        Text(
                                          '${widget.viewModel.totalMoneyToGive} MXN',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),

                                    // Fila 2: Representación (Estilo Badge/Chip)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Representación',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            '${widget.viewModel.repPercentage.toStringAsFixed(2)} %',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Divider(height: 1),
                                    ),

                                    // Fila 3: Incentivo a dar (Dato más importante destacado)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Incentivo a dar',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                        ),
                                        Text(
                                          '${widget.viewModel.incentiveMoney.toStringAsFixed(2)} MXN',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(
                                              0xFF38761D,
                                            ), // Tu color verde de marca
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 24.0,
                              ), // Mayor espacio de separación con el botón de acción
                              // --- BOTÓN DE ACCIÓN ---
                              FormButton(
                                text: 'Transferir incentivo',
                                onPressed: widget.viewModel.payment.execute,
                                listenable: widget.viewModel.payment,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        _buildSection('Imagen del negocio'),
                        CustomNetworkImage(urlImage: store.urlLogo),

                        const SizedBox(height: 24),

                        _buildSection("Representante legal"),

                        _buildDataRow(
                          "Correo electrónico",
                          store.email ?? '',
                          Icons.person_outline,
                          // controller: ,
                        ),

                        _buildDataRow(
                          "Nombre",
                          store.userName ?? '',
                          Icons.person_outline,
                          controller: _usernameController,
                        ),
                        _buildDataRow(
                          "Apellidos",
                          store.surnames ?? '',
                          Icons.person_outline,

                          controller: _surnamesController,
                        ),
                        _buildDataRow(
                          "Número telefónico",
                          store.phoneNumber ?? '',
                          Icons.person_outline,

                          controller: _phoneNumberController,
                        ),

                        ListenableBuilder(
                          listenable: widget.viewModel,
                          builder: (context, _) {
                            if (widget.viewModel.store!.isActive!) {
                              return ListTile(
                                title: Text('Activo'),
                                leading: Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                ),
                              );
                            }
                            return ListTile(
                              title: Text('Inactivo'),
                              leading: Icon(Icons.circle, color: Colors.red),
                            );
                          },
                        ),

                        _buildDataRow(
                          "Creado en",
                          store.createdAt != null
                              ? DateFormat(
                                  'dd/MM/yyyy HH:mm',
                                ).format(store.createdAt!.toLocal())
                              : 'N/A',
                          Icons.person_outline,
                          controller: _createdAtController,
                        ),

                        // COMPANY DATA
                        const SizedBox(height: 24),

                        _buildSection("Tax & Bank Details"),
                        _buildDataRow(
                          "Company Name",
                          store.companyName ?? '',
                          Icons.business,
                          controller: _companyNameController,
                        ),
                        _buildDataRow(
                          "RFC",
                          store.rfc ?? '',
                          Icons.description_outlined,
                          controller: _rfcController,
                        ),
                        _buildDataRow(
                          "Regimen fiscal",
                          store.taxRegime ?? '',
                          Icons.person_outline,

                          controller: _taxRegimeController,
                        ),
                        _buildDataRow(
                          "CLABE",
                          store.clabe ?? '',
                          Icons.person_outline,

                          controller: _clabeController,
                        ),
                        _buildDataRow(
                          "Bank",
                          store.bank ?? '',
                          Icons.account_balance_wallet_outlined,

                          controller: _bankController,
                        ),
                        _buildDataRow(
                          "Nombre comercial",
                          store.commercialName ?? '',
                          Icons.person_outline,

                          controller: _commercialNameController,
                        ),

                        _buildDataRow(
                          "Dirección",
                          store.address ?? '',
                          Icons.person_outline,

                          controller: _addressController,
                        ),

                        _buildDataRow(
                          "Código postal",
                          store.postCode ?? '',
                          Icons.person_outline,

                          controller: _postCodeController,
                        ),

                        _buildDataRow(
                          "Correo electrónico de facturación",
                          store.billingEmail ?? '',
                          Icons.person_outline,

                          controller: _billingEmailController,
                        ),

                        Text("Tipo de contribuyente"),
                        ListenableBuilder(
                          listenable: widget.viewModel,
                          builder: (context, _) {
                            return IgnorePointer(
                              ignoring: !widget.viewModel.isEditing,
                              child: Opacity(
                                opacity: widget.viewModel.isEditing ? 1.0 : 0.6,
                                child: Column(
                                  children: [
                                    RadioGroup<TaxpayerType>(
                                      groupValue: widget.viewModel.taxpayerType,
                                      onChanged: (TaxpayerType? value) {
                                        setState(() {
                                          widget.viewModel.taxpayerType =
                                              value!;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          const RadioListTile<TaxpayerType>(
                                            title: Text("Persona Moral"),
                                            value: TaxpayerType.moral,
                                            activeColor:
                                                AppColors.greenDiakron1,
                                          ),
                                          const RadioListTile<TaxpayerType>(
                                            title: Text("Persona Física"),
                                            value: TaxpayerType.physical,
                                            activeColor:
                                                AppColors.greenDiakron1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: Dimens.paddingVertical),
                                    SizedBox(height: Dimens.paddingVertical),
                                    const Text(
                                      'Calendario',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: Dimens.paddingVertical),
                                    ListenableBuilder(
                                      listenable: widget.viewModel,
                                      builder: (context, _) {
                                        return SegmentedButton<int>(
                                          segments: const [
                                            ButtonSegment(
                                              value: 0,
                                              label: Text('Lu'),
                                            ),
                                            ButtonSegment(
                                              value: 1,
                                              label: Text('Ma'),
                                            ),
                                            ButtonSegment(
                                              value: 2,
                                              label: Text('Mi'),
                                            ),
                                            ButtonSegment(
                                              value: 3,
                                              label: Text('Ju'),
                                            ),
                                            ButtonSegment(
                                              value: 4,
                                              label: Text('Vi'),
                                            ),
                                            ButtonSegment(
                                              value: 5,
                                              label: Text('Sá'),
                                            ),
                                            ButtonSegment(
                                              value: 6,
                                              label: Text('Do'),
                                            ),
                                          ],
                                          showSelectedIcon: false,
                                          emptySelectionAllowed: true,
                                          multiSelectionEnabled: true,
                                          selected: widget.viewModel.daysOpen,
                                          onSelectionChanged: (newSelection) =>
                                              widget.viewModel.onDaysChanged(
                                                newSelection,
                                              ),
                                        );
                                      },
                                    ),

                                    const SizedBox(height: 20),

                                    // Dynamic schedule list
                                    ListenableBuilder(
                                      listenable: widget.viewModel,
                                      builder: (context, _) {
                                        final selectedIndices =
                                            widget.viewModel.daysOpen.toList()
                                              ..sort();

                                        if (selectedIndices.isEmpty) {
                                          return const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 20,
                                            ),
                                            child: Text(
                                              "No hay días seleccionados",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          );
                                        }

                                        return Column(
                                          children: selectedIndices.map((
                                            index,
                                          ) {
                                            final error = widget.viewModel
                                                .getErrorMessage(index);
                                            final day = widget
                                                .viewModel
                                                .weekSchedules[index];

                                            return Card(
                                              margin: const EdgeInsets.only(
                                                bottom: 12,
                                              ),
                                              elevation: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ListTile(
                                                      contentPadding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                          ),
                                                      title: Text(
                                                        day.dayName,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      trailing:
                                                          (day.openTime !=
                                                                  null &&
                                                              day.closeTime !=
                                                                  null)
                                                          ? IconButton(
                                                              icon: const Icon(
                                                                Icons.copy_all,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              tooltip:
                                                                  "Copiar a toda la semana",
                                                              onPressed: null,
                                                              // () => _confirmCopy(context, widget.viewModel, index),
                                                            )
                                                          : null,
                                                    ),
                                                    const Divider(height: 1),
                                                    TimePickerTile(
                                                      label: "Hora de apertura",
                                                      time: day.openTime,
                                                      onTap: () async {
                                                        final t =
                                                            await showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  day.openTime ??
                                                                  TimeOfDay.now(),
                                                            );
                                                        if (t != null) {
                                                          widget.viewModel
                                                              .updateTime(
                                                                index,
                                                                true,
                                                                t,
                                                              );
                                                        }
                                                      },
                                                    ),
                                                    TimePickerTile(
                                                      label: "Hora de Cierre",
                                                      time: day.closeTime,
                                                      onTap: () async {
                                                        final t =
                                                            await showTimePicker(
                                                              context: context,
                                                              initialTime:
                                                                  day.closeTime ??
                                                                  TimeOfDay.now(),
                                                            );
                                                        if (t != null) {
                                                          widget.viewModel
                                                              .updateTime(
                                                                index,
                                                                false,
                                                                t,
                                                              );
                                                        }
                                                      },
                                                    ),
                                                    if (error != null)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.fromLTRB(
                                                              16,
                                                              0,
                                                              16,
                                                              8,
                                                            ),
                                                        child: Text(
                                                          error,
                                                          style:
                                                              const TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 12,
                                                              ),
                                                        ),
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
                              ),
                            );
                          },
                        ),

                        const Text(
                          "Documentación PDF",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FileGetterTile(
                          label: "Identificación Representante",
                          onPick: () => {
                            widget.viewModel.viewDocument(store.pathIdRep!),
                          },
                        ),
                        FileGetterTile(
                          label: "Comprobante de Domicilio",
                          onPick: () => {
                            widget.viewModel.viewDocument(
                              store.pathProofAddress!,
                            ),
                          },
                        ),
                        FileGetterTile(
                          label: "Constancia Situación Fiscal",
                          onPick: () => {
                            widget.viewModel.viewDocument(
                              store.pathTaxCertificate!,
                            ),
                          },
                        ),
                      ],
                    ),

                    // Smooth Bottom Update Button and validate/deny
                    ListenableBuilder(
                      listenable: widget.viewModel,
                      builder: (context, _) {
                        if (widget.viewModel.updateStore.running) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (widget.viewModel.isEditing) {
                          return AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: FloatingActionButton.extended(
                              backgroundColor: Colors.green[600],
                              onPressed: () {
                                _showUpdateConfirm();
                              },
                              label: const Text(
                                "GUARDAR CAMBIOS",
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }

                        // IF NOT EDITING SHOW VALIDATE/DENY

                        return Positioned(
                          bottom: 20,
                          right: 20,
                          left: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  iconColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.red,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                ),

                                child: Row(
                                  children: [
                                    Icon(Icons.close),
                                    SizedBox(width: 10),
                                    Text('Rechazar'),
                                  ],
                                ),
                                onPressed: () {
                                  CustomAlertDialog.show(
                                    context: context,
                                    title: 'Rechazar store',
                                    content:
                                        '¿Seguro que quieres rechazar este store?',
                                    actionText: 'Rechazar',
                                    actionButtonColor: Colors.red,
                                    onPressed: () {
                                      widget.viewModel.changeValidationStatus
                                          .execute(ValidationStatus.denied);
                                    },
                                  );
                                },
                              ),

                              ElevatedButton(
                                style: ButtonStyle(
                                  iconColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.green,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.check),
                                    SizedBox(width: 10),
                                    Text('Validar'),
                                  ],
                                ),
                                onPressed: () {
                                  CustomAlertDialog.show(
                                    context: context,
                                    title: 'Validar store',
                                    content:
                                        '¿Seguro que quieres validar este store?',
                                    actionText: 'Validar',
                                    actionButtonColor: Colors.green,
                                    onPressed: () {
                                      widget.viewModel.changeValidationStatus
                                          .execute(ValidationStatus.approved);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onPaymentURL() async {
    if (widget.viewModel.payment.completed) {
      widget.viewModel.payment.clearResult();
      _launchUrl();
    }
    if (widget.viewModel.payment.error) {
      final error = widget.viewModel.payment.result;
      widget.viewModel.payment.clearResult();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 5),
            persist: false,
            dismissDirection: DismissDirection.horizontal,
            content: Text('Error: $error'),
            action: SnackBarAction(
              label: "Try again",
              onPressed: () => widget.viewModel.payment.execute(),
            ),
          ),
        );
      }
    }
  }

  void _launchUrl() async {
    final theme = Theme.of(context);
    try {
      await launchUrl(
        Uri.parse(widget.viewModel.checkoutURL),
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

  void _showUpdateConfirm() {
    CustomAlertDialog.show(
      context: context,
      title: 'Guardar cambios',
      content:
          '¿Seguro de guardar cambios?\nEsta acción eliminará los datos anteriores',
      actionText: 'Guardar',
      onPressed: () {
        // UPDATE EDITStore
        widget.viewModel.editedCenter = widget.viewModel.editedCenter?.copyWith(
          address: _addressController.text,
          bank: _bankController.text,
          billingEmail: _billingEmailController.text,
          clabe: _clabeController.text,
          commercialName: _commercialNameController.text,
          companyName: _companyNameController.text,
          createdAt: DateTime.tryParse(_createdAtController.text),

          isActive: _isActive,
          phoneNumber: _phoneNumberController.text,
          postCode: _postCodeController.text,
          rfc: _rfcController.text,
          schedule: _schedule,
          surnames: _surnamesController.text,
          taxRegime: _taxRegimeController.text,
          taxpayerType: widget.viewModel.taxpayerType?.label,
          userName: _usernameController.text,
          // id: '',
          // pathIdRep: '',
          // pathProofAddress: '',
          // pathTaxCertificate: '',
          // userType: '',
          validationStatus: _validationStatus,
        );

        // EXEC UPDATE
        widget.viewModel.updateStore.execute();
        setState(() {
          widget.viewModel.toggleEdit();
          widget.viewModel.load.execute();
        });
      },
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildDataRow(
    String label,
    String value,
    IconData icon, {
    TextEditingController? controller,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: widget.viewModel.isEditing ? 4 : 12,
      ),
      decoration: BoxDecoration(
        color: widget.viewModel.isEditing ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.viewModel.isEditing ? Colors.green : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                widget.viewModel.isEditing && controller != null
                    ? TextField(
                        enabled: widget.viewModel.isEditing,
                        controller: controller,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          border: InputBorder.none,
                        ),
                      )
                    : Text(
                        // Show simply the value
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStatus({required String? status}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: status.statusColor.withValues(alpha: 0.1),
            child: Icon(status.statusIcon, color: status.statusColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Validación", style: TextStyle(fontSize: 12)),
              Text(
                status.statusLabel, // Uses the extension
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: status.statusColor, // Uses the extension
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(String id) {
    CustomAlertDialog.show(
      context: context,
      title: 'Confirmar eliminación',
      content: '¿Estás seguro de querer borrar este store?',
      actionText: 'Eliminar',
      onPressed: () async {
        await widget.viewModel.deleteStore.execute();
      },
      actionButtonColor: Colors.red,
    );
  }

  void _onUpdate() {
    if (widget.viewModel.updateStore.completed) {
      widget.viewModel.updateStore.clearResult();

      CustomSnackBar.showSuccess(context, message: "Tienda actualizada");
    }

    if (widget.viewModel.updateStore.error) {
      widget.viewModel.updateStore.clearResult();

      CustomSnackBar.showError(context, message: "Error al actualizar tienda");
    }
  }

  void _onDelete() {
    if (widget.viewModel.deleteStore.completed) {
      widget.viewModel.deleteStore.clearResult();
      CustomSnackBar.showSuccess(context, message: "Tienda eliminada");
      context.pop();
    }

    if (widget.viewModel.deleteStore.error) {
      widget.viewModel.deleteStore.clearResult();

      CustomSnackBar.showError(
        context,
        message: "Error al eliminar tienda",
        onRetry: () {
          widget.viewModel.deleteStore.execute();
        },
      );
    }
  }

  void _onChangedValidation() {
    if (widget.viewModel.changeValidationStatus.completed) {
      widget.viewModel.changeValidationStatus.clearResult();

      CustomSnackBar.showSuccess(
        context,
        message: "Cambiado estado de validación",
      );
    }

    if (widget.viewModel.changeValidationStatus.error) {
      widget.viewModel.changeValidationStatus.clearResult();

      CustomSnackBar.showError(
        context,
        message: "Error cambiando estado de validación",
      );
    }
  }
}

class TimePickerTile extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final VoidCallback onTap;

  const TimePickerTile({
    super.key,
    required this.label,
    this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        time?.format(context) ?? "Seleccionar",
        style: TextStyle(color: time == null ? Colors.grey : Colors.blue),
      ),
      onTap: onTap,
    );
  }
}
