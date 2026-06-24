import 'package:diakron_stores/ui/core/themes/dimens.dart';
import 'package:diakron_stores/ui/core/ui/custom_alert_dialog.dart';
import 'package:diakron_stores/ui/core/ui/custom_network_image.dart';
import 'package:diakron_stores/ui/core/ui/custom_screen.dart';
import 'package:diakron_stores/ui/core/ui/custom_text_form_field.dart';
import 'package:diakron_stores/ui/core/ui/date_picker_tile.dart';
import 'package:diakron_stores/ui/core/ui/error_indicator.dart';
import 'package:diakron_stores/ui/core/ui/image_picker_tile.dart';
import 'package:diakron_stores/ui/coupons/coupons_crud/view_models/rud_coupon_viewmodel.dart';
import 'package:diakron_stores/utils/validation/validators.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';

class RUDCouponScreen extends StatefulWidget {
  const RUDCouponScreen({super.key, required this.viewModel});

  final RUDCouponViewmodel viewModel;

  @override
  State<RUDCouponScreen> createState() => _RUDCouponScreenState();
}

class _RUDCouponScreenState extends State<RUDCouponScreen> {
  // Helper constants for clarity
  final Color activeGreen = Colors.green.shade700; // Intense Green
  final Color mutedGreen = Colors.green.shade200; // Soft Green
  final Color activeRed = Colors.red.shade700; // Intense Red
  final Color mutedRed = Colors.red.shade200; // Soft Red
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _descript = TextEditingController();
  final TextEditingController _pricePoints = TextEditingController();
  final TextEditingController _couponsLeft = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.load.addListener(_onLoad);
    widget.viewModel.trySave.addListener(_onUpdatedCoupon);
    widget.viewModel.deleteCoupon.addListener(_onDelete);

    // Execute load here instead of the ViewModel constructor
    if (!widget.viewModel.load.running && widget.viewModel.coupon == null) {
      widget.viewModel.load.execute();
    }
  }

  @override
  void didUpdateWidget(covariant RUDCouponScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewModel != oldWidget.viewModel) {
      oldWidget.viewModel.trySave.removeListener(_onUpdatedCoupon);
      widget.viewModel.trySave.addListener(_onUpdatedCoupon);

      oldWidget.viewModel.load.removeListener(_onLoad);
      widget.viewModel.load.addListener(_onLoad);

      oldWidget.viewModel.deleteCoupon.removeListener(_onDelete);
      widget.viewModel.deleteCoupon.addListener(_onDelete);
    }
  }

  @override
  void dispose() {
    widget.viewModel.load.removeListener(_onLoad);
    widget.viewModel.trySave.removeListener(_onUpdatedCoupon);
    widget.viewModel.deleteCoupon.removeListener(_onDelete);
    _title.dispose();
    _descript.dispose();
    _pricePoints.dispose();
    _couponsLeft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Only listen to the load command at the top level
    return ListenableBuilder(
      listenable: widget.viewModel.load,
      builder: (context, child) {
        if (widget.viewModel.load.running) {
          return const Center(child: CircularProgressIndicator());
        }
        if (widget.viewModel.load.error) {
          return Center(
            child: ErrorIndicator(
              title: 'Error loading Coupon Info',
              label: 'Try again',
              onPressed: widget.viewModel.load.execute,
            ),
          );
        }

        // If program arrived here, coupon successfully retrieved
        return CustomScreen(
          title: 'Editar Cupón',
          actions: [
            // 2. Wrap only the Edit Icon to toggle its appearance based on state
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) => IconButton(
                onPressed: widget.viewModel.toggleEdit,
                icon: Icon(
                  Icons.edit,
                  color: widget.viewModel.isEditing ? Colors.green : null,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _showDeleteConfirm,
            ),
          ],
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          // 3. Rebuild FAB visibility only when viewModel changes
          floatingActionButton: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) => widget.viewModel.isEditing
                ? _buildSubmitButton()
                : const SizedBox.shrink(),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            // 4. Listen to the ViewModel strictly for the form elements
            child: ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                final isEditing = widget.viewModel.isEditing;

                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimens.paddingVertical),

                      Text(
                        'Cantidad de veces canjeado: ${widget.viewModel.coupon!.redeemTimes}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Estado:', style: TextStyle(fontSize: 18)),
                            Text(
                              widget.viewModel.isActive ? 'Activo' : 'Inactivo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: widget.viewModel.isActive
                                    ? (isEditing ? activeGreen : mutedGreen)
                                    : (isEditing ? activeRed : mutedRed),
                              ),
                            ),
                            Switch(
                              value: widget.viewModel.isActive,

                              // Active state (Green)
                              activeThumbColor: isEditing
                                  ? activeGreen
                                  : mutedGreen,
                              activeTrackColor: isEditing
                                  ? Colors.green.shade300
                                  : Colors.green.shade100,

                              // Inactive state (Red)
                              inactiveThumbColor: isEditing
                                  ? activeRed
                                  : Colors.blueGrey,
                              inactiveTrackColor: isEditing
                                  ? Colors.red.shade300
                                  : Colors.red.shade100,

                              onChanged: !isEditing
                                  ? null
                                  : (value) =>
                                        widget.viewModel.toggleActive(value),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimens.paddingVertical),

                      CustomTextFormField(
                        enabled: isEditing,
                        labelText: 'Título del beneficio',
                        controller: _title,
                        validator: Validators.required,
                        maxLength: 50,
                      ),

                      CustomTextFormField(
                        enabled: isEditing,
                        labelText: 'Descripción del beneficio',
                        controller: _descript,
                        validator: Validators.required,
                        keyboardType: TextInputType.multiline,
                        minMaxLines: 4,
                        maxLength: 500,
                      ),

                      CustomTextFormField(
                        enabled: isEditing,
                        labelText: 'Precio en puntos',
                        controller: _pricePoints,
                        validator: Validators.number,
                        keyboardType: TextInputType.number,
                      ),

                      ListenableBuilder(
                        listenable: widget.viewModel,
                        builder: (context, _) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: widget.viewModel.isUnlimited,
                                    onChanged: (bool? value) {
                                      widget.viewModel.toggleUnlimited(value);
                                    },
                                    activeColor: const Color(0xFF387C11),
                                  ),
                                  Text(
                                    'Cantidad ilimitada de existencias',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Dimens.paddingVertical),
                              if (!widget.viewModel.isUnlimited)
                                CustomTextFormField(
                                  enabled: isEditing,
                                  labelText:
                                      'Stock/Existencias (cuantos cupones existirán)',
                                  controller: _couponsLeft,
                                  validator: Validators.number,
                                  keyboardType: TextInputType.number,
                                ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: Dimens.paddingVertical),

                      if (widget.viewModel.isExpired)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Este cupón ha caducado',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                      DatePickerTile(
                        enabled: isEditing,
                        dateTime: widget.viewModel.expirationDate,
                        label: "Fecha de caducidad",
                        onTap: isEditing ? () => _selectDate(context) : null,
                      ),

                      const SizedBox(height: Dimens.paddingVertical),

                      CustomNetworkImage(
                        urlImage: widget.viewModel.coupon!.urlImage,
                      ),

                      const SizedBox(height: Dimens.paddingVertical),

                      if (isEditing)
                        ImagePickerTile(
                          label: "Cambiar imagen",
                          path: widget.viewModel.localImagePath,
                          onPick: () => _pickImage(context),
                        ),

                      const SizedBox(height: Dimens.paddingVertical),
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return ListenableBuilder(
      listenable: widget.viewModel.trySave,
      builder: (context, _) {
        final isLoading = widget.viewModel.trySave.running;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.green[600],
              onPressed: isLoading ? null : _handleUpload,
              label: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "GUARDAR CAMBIOS",
                      style: TextStyle(color: Colors.white),
                    ),
              icon: isLoading
                  ? null
                  : const Icon(Icons.check, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirm() {

    CustomAlertDialog.show(context: context,

        title: 'Confirmar eliminación',
        content: '¿Estás seguro de querer borrar este cupón?',
        actionText: 'Eliminar',
        onPressed: widget.viewModel.deleteCoupon.execute,
        actionButtonColor: Colors.red,
    );
  }

  void _onLoad() {
    // Prevent Null Pointer Error if load failed
    if (widget.viewModel.load.completed && widget.viewModel.coupon != null) {
      _title.text = widget.viewModel.coupon!.title;
      _descript.text = widget.viewModel.coupon!.descript;
      _pricePoints.text = widget.viewModel.coupon!.pricePoints.toString();
      // To avoid this field writes null if its unllimited
      if (!widget.viewModel.isUnlimited) {
        _couponsLeft.text = widget.viewModel.coupon!.couponsLeft.toString();
      }
    }
  }

  void _handleUpload() {
    if (_formKey.currentState!.validate() && widget.viewModel.isValidForSave) {
      widget.viewModel.trySave.execute((
        _title.text,
        _descript.text,
        _pricePoints.text,
        _couponsLeft.text,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Revisa los campos, la imagen y la fecha!'),
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    // If is expired, set initial date to now at select Date, if this is not set, the DatePicker will never open
    DateTime initialDate = widget.viewModel.expirationDate ?? DateTime.now();
    if (widget.viewModel.isExpired) initialDate = DateTime.now();

    final dt = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (dt != null) {
      widget.viewModel.updateTime(dt);
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      final file = result.files.single;

      if (file.size > 2 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("La imagen supera los 2 MB")),
          );
        }

        return;
      }

      widget.viewModel.updatePathLogo(file.path!);
    }
  }

  void _onUpdatedCoupon() {
    if (widget.viewModel.trySave.completed) {
      widget.viewModel.trySave.clearResult();
      widget.viewModel.load.execute(); // Reloads fresh data
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cupón actualizado!")));
    }

    if (widget.viewModel.trySave.error) {
      widget.viewModel.trySave.clearResult();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error actualizando cupón")));
    }
  }

  void _onDelete() {
    if (widget.viewModel.deleteCoupon.completed) {
      widget.viewModel.deleteCoupon.clearResult();
      context.pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cupón eliminado!")));
    }

    if (widget.viewModel.deleteCoupon.error) {
      widget.viewModel.deleteCoupon.clearResult();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error eliminando cupón")));
    }
  }
}
