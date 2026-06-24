import 'package:diakron_stores/routing/routes.dart';
import 'package:diakron_stores/ui/core/themes/dimens.dart';
import 'package:diakron_stores/ui/core/ui/custom_screen.dart';
import 'package:diakron_stores/ui/core/ui/custom_text_form_field.dart';
import 'package:diakron_stores/ui/core/ui/date_picker_tile.dart';
import 'package:diakron_stores/ui/core/ui/image_picker_tile.dart';
import 'package:diakron_stores/ui/coupons/coupons_crud/view_models/create_coupon_viewmodel.dart';
import 'package:diakron_stores/utils/validation/validators.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';

class CreateCouponScreen extends StatefulWidget {
  const CreateCouponScreen({super.key, required this.viewModel});

  final CreateCouponViewmodel viewModel;

  @override
  State<CreateCouponScreen> createState() => _CreateCouponScreenState();
}

class _CreateCouponScreenState extends State<CreateCouponScreen> {
  // Moved the FormKey to the View where it belongs.
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _descript = TextEditingController();
  final TextEditingController _pricePoints = TextEditingController();
  final TextEditingController _couponsLeft = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.trySave.addListener(_onSavedCoupon);
  }

  @override
  void didUpdateWidget(covariant CreateCouponScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewModel != oldWidget.viewModel) {
      oldWidget.viewModel.trySave.removeListener(_onSavedCoupon);
      widget.viewModel.trySave.addListener(_onSavedCoupon);
    }
  }

  @override
  void dispose() {
    widget.viewModel.trySave.removeListener(_onSavedCoupon);
    _title.dispose();
    _descript.dispose();
    _pricePoints.dispose();
    _couponsLeft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Crear cupón',
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildSubmitButton(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        // The Form and TextFields no longer rebuild when the date/image changes
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Dimens.paddingVertical),

              CustomTextFormField(
                labelText: 'Titulo del beneficio, ej. 50% café mediano',
                controller: _title,
                validator: Validators.required,
                maxLength: 50,
              ),

              CustomTextFormField(
                labelText:
                    'Descripción del beneficio (condiciones/restricciones)',
                controller: _descript,
                validator: Validators.required,
                keyboardType: TextInputType.multiline,
                minMaxLines: 4,
                maxLength: 500,
              ),

              CustomTextFormField(
                labelText: 'Precio en puntos Diakron',
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
                          labelText:
                              'Stock/Existencias (cuantos cupones existirán)',
                          controller: _couponsLeft,
                          validator: Validators.number,
                          keyboardType: TextInputType.number,
                          enabled: !widget.viewModel.isUnlimited,
                        ),
                    ],
                  );
                },
              ),

              // We ONLY wrap the widgets that actually care about ViewModel state changes
              ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, _) {
                  return Column(
                    children: [
                      DatePickerTile(
                        dateTime: widget.viewModel.expirationDate,
                        label: "Fecha de caducidad",
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: Dimens.paddingVertical),
                      ImagePickerTile(
                        label: "Imagen representativa",
                        path: widget.viewModel.localImagePath,
                        onPick: () => _pickImage(context),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: Dimens.paddingVertical),

              const Text(
                'NOTA: El cupón se marcará activo por defecto, es posible desactivarlos sin borrarlos posteriormente.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
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
              onPressed: isLoading ? null : _handleSave,
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

  void _handleSave() {
    // Validation is a UI concern. We check the form and the VM's state here.
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
    final dt = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  void _onSavedCoupon() {
    if (widget.viewModel.trySave.completed) {
      widget.viewModel.trySave.clearResult();
      context.go(Routes.coupons);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Nuevo cupón añadido!")));
    }

    if (widget.viewModel.trySave.error) {
      widget.viewModel.trySave.clearResult();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error añadiendo cupón")));
    }
  }
}
