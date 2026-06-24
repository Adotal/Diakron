import 'dart:io';

import 'package:diakron_stores/data/repositories/auth/auth_repository.dart';
import 'package:diakron_stores/data/repositories/user/store_repository.dart';
import 'package:diakron_stores/models/core/taxpayer_type/taxpayer_type.dart';
import 'package:diakron_stores/models/core/validation_status/validation_status.dart';
import 'package:diakron_stores/models/users/store.dart';
import 'package:diakron_stores/utils/command.dart';
import 'package:diakron_stores/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class UploadFilesViewModel extends ChangeNotifier {
  // Controllers live here to persist data between page swipes
  UploadFilesViewModel({
    required StoreRepository userRepository,
    required AuthRepository authRepository,
  }) : _userRepository = userRepository,
       _authRepository = authRepository {
    load = Command0(_load)..execute();
    completeRegistration = Command0(_completeRegistration);
  }

  late Command0 load;
  late Command0 completeRegistration;

  final StoreRepository _userRepository;
  final AuthRepository _authRepository;
  Store? _store;
  Store? get store => _store;

  // Store days open
  Set<int> daysOpen = {};

  // Its null while no error is detected
  String? timeErrorMsj;

  // GlobalKey for validations
  final step1FormKey = GlobalKey<FormState>();
  final step2FormKey = GlobalKey<FormState>();
  final step3FormKey = GlobalKey<FormState>();

  TaxpayerType _currentType = TaxpayerType.moral;
  TaxpayerType get currentType => _currentType;


  String _uploadMessage = "Iniciando registro...";
  String get uploadMessage => _uploadMessage;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;


  final _logger = Logger();

  // Company data
  final companyNameController = TextEditingController(
    
  );
  final commercialNameController = TextEditingController(
    
  );
  final categoryController = TextEditingController();
  final addressController = TextEditingController();
  final postCodeController = TextEditingController();

  // Billing data
  final billingEmailController = TextEditingController(
    
  );
  final rfcController = TextEditingController();
  final taxRegimeController = TextEditingController(
    
  );
  final bankController = TextEditingController();
  final clabeController = TextEditingController();

  Future<Result> _load() async {
    // Fetch store
    final storeResult = await _userRepository.getStore(forceRefresh: true);
    switch (storeResult) {
      case Success<Store>():
        _store = storeResult.value;

      case Failure<Store>():
        _logger.e('Error fetching initial store ${storeResult.error}');
        return Result.error(storeResult.error);
    }

    // Si ya tienen datos, no cargamos de nuevo
    if (_privacyMd != null && _termsMd != null) {
      _isLoading = false;
      notifyListeners();
      return Result.ok(null);
    }

    try {
      // Cargamos ambos en paralelo
      final results = await Future.wait([
        rootBundle.loadString('assets/privacy_policy.md'),
        rootBundle.loadString('assets/terms_and_conditions.md'),
      ]);

      _privacyMd = results[0];
      _termsMd = results[1];
    } catch (e) {
      debugPrint("Error cargando MD: $e");
    }
    _isLoading = false;
    notifyListeners();
    return Result.ok(null);
  }

  bool validateStep1() {
    _logger.w(genScheduleMap());

    if (daysOpen.isEmpty) {
      timeErrorMsj = 'Debe haber al menos un día de operación';
      notifyListeners();
      return false;
    }

    // Iterate open days and check all all filled
    for (int i = 0; i < daysOpen.length; i++) {
      if (weekSchedules[daysOpen.elementAt(i)].isUncomplete()) {
        timeErrorMsj = 'Todos los horarios deben ser llenados';
        notifyListeners();
        return false;
      }
    }
    timeErrorMsj = null;
    return step1FormKey.currentState?.validate() ?? false;
  }

  bool validateStep2() => step2FormKey.currentState?.validate() ?? false;

  bool validateStep3() {
    // Manual check for files
    return store!.pathLogo != null &&
        store!.pathIdRep != null &&
        store!.pathProofAddress != null &&
        store!.pathTaxCertificate != null;
  }

  void setTaxpayerType(TaxpayerType? value) {
    if (value == null) return;
    _currentType = value;
    notifyListeners();
  }

  @override
  void dispose() {
    companyNameController.dispose();
    commercialNameController.dispose();
    addressController.dispose();
    postCodeController.dispose(); // <-- Te faltaba este
    billingEmailController.dispose();
    rfcController.dispose();
    taxRegimeController.dispose();
    bankController.dispose();
    clabeController.dispose();
    super.dispose();
  }

  String timeOfDaytoString(TimeOfDay value) {
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  void updatePath(String field, dynamic value) {
    switch (field) {
      case 'pathLogo':
        _store = _store!.copyWith(pathLogo: value);
        break;
      case 'pathIdRep':
        _store = _store!.copyWith(pathIdRep: value);
        break;
      case 'pathProofAddress':
        _store = _store!.copyWith(pathProofAddress: value);
        break;
      case 'pathTaxCertificate':
        _store = _store!.copyWith(pathTaxCertificate: value);
        break;
    }
    notifyListeners();
  }

  void syncAllToModel() {
    _store = _store!.copyWith(
      // Now that have uploated files, status is pending
      validationStatus: ValidationStatus.pending,
      category: categoryController.text,

      companyName: companyNameController.text,
      commercialName: commercialNameController.text,
      rfc: rfcController.text,
      taxRegime: taxRegimeController.text,
      taxpayerType: currentType.label,
      schedule: genScheduleMap(),
      postCode: postCodeController.text,
      clabe: clabeController.text,
      billingEmail: billingEmailController.text,
      bank: bankController.text,
      address: addressController.text,
      // pathIdRep: pathIdRep,
      // pathProofAddress: pathProofAddress,
      // pathTaxCertificate: pathTaxCertificate,
    );
  }


  void _updateProgress(String message) {
    _uploadMessage = message;
    notifyListeners();
  }

  Future<Result> _completeRegistration() async {
    try {
      final String userId = _authRepository.userId;
      _isProcessing = true;

      _updateProgress("Sincronizando datos...");

      // Update model
      syncAllToModel();

      // Upload files
      // Upload Logo
      _updateProgress("Subiendo: Logo de empresa...");
      await uploadDocument(userId, _store!.pathLogo, 'pathLogo', false);

      // Upload ID
      _updateProgress("Subiendo: Identificación del Representante...");
      await uploadDocument(userId, _store!.pathIdRep, 'pathIdRep', true);

      // Upload Proof Address
      _updateProgress("Subiendo: Comprobante de Domicilio...");
      await uploadDocument(
        userId,
        _store!.pathProofAddress,
        'pathProofAddress',
        true,
      );
      // Upload Tax Certificate
      _updateProgress("Subiendo: Constancia de Situación Fiscal...");
      await uploadDocument(
        userId,
        _store!.pathTaxCertificate,
        'pathTaxCertificate',
        true,
      );

      // Database sync
      _updateProgress("Finalizando: Información del Centro de Acopio...");

      // Upload all data to Database
      final result = await _userRepository.uploadUserData(
        'stores',
        _authRepository.userId,
        _store!,
      );
      switch (result) {
        case Success():
          _updateProgress('Todo listo!');
          _logger.d(_store!.toJson());
          _isProcessing = false;
          return Result.ok(null);

        case Failure():
          _updateProgress("Error al subir los datos. Reintenta.");
          _isProcessing = false;
          _logger.e('${_store!.toJson()}\n ${result.error}');
          return Result.error(Exception());
      }
    } on Exception catch (error) {
      _logger.e('Error UPLAODING STORE $error');
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }

  Future<void> uploadDocument(
    String userId,
    String? localPath,
    String docType,
    bool isPrivate,
  ) async {
    if (localPath == null) return;

    final file = File(localPath);
    if (!await file.exists()) return;

    // Use the docType (e.g., 'pathIdRep') as the filename, but quit 'path', quit first 4 chars
    final String? result;
    final String fileName;
    if (isPrivate) {
      fileName = "${docType.substring(4)}.pdf";
    } else {
      // If public Always save as png
      fileName = "${docType.substring(4)}.png";
    }

    result = await _userRepository.uploadFile(
      id: userId,
      fileName: fileName,
      file: file,
      isPrivate: isPrivate,
    );

    _logger.i('PATH: $result');

    if (result != null) {
      // Update the model with the STORAGE path, not the local path
      switch (docType) {
        case 'pathLogo':
          _store = _store!.copyWith(pathLogo: result);
        case 'pathIdRep':
          _store = _store!.copyWith(pathIdRep: result);
          break;
        case 'pathProofAddress':
          _store = _store!.copyWith(pathProofAddress: result);
          break;
        case 'pathTaxCertificate':
          _store = _store!.copyWith(pathTaxCertificate: result);
          break;
      }
    }

    notifyListeners();
  }

  void updateTime(int index, bool isOpenTime, TimeOfDay time) {
    if (isOpenTime) {
      weekSchedules[index].openTime = time;
    } else {
      weekSchedules[index].closeTime = time;
    }
    notifyListeners();
  }

  void copyToAll(int fromIndex) {
    final source = weekSchedules[fromIndex];
    if (source.openTime == null || source.closeTime == null) return;

    for (int i = 0; i < weekSchedules.length; i++) {
      weekSchedules[i].isOpen = true;
      weekSchedules[i].openTime = source.openTime;
      weekSchedules[i].closeTime = source.closeTime;

      // Agregamos el índice al Set para que el SegmentedButton se vea seleccionado
      daysOpen.add(i);
    }
    notifyListeners();
  }

  String? getErrorMessage(int index) {
    final day = weekSchedules[index];
    if (day.isOpen && day.openTime != null && day.closeTime != null) {
      final start = day.openTime!.hour * 60 + day.openTime!.minute;
      final end = day.closeTime!.hour * 60 + day.closeTime!.minute;
      if (end <= start) {
        weekSchedules[index].closeTime = null;
        return "El cierre debe ser después de la apertura";
      }
    }
    return null;
  }

  // NEW SEGMENTED BUTTON

  // Tu lista de modelos (7 días)
  final List<DaySchedule> weekSchedules = List.generate(
    7,
    (index) => DaySchedule(dayName: _getDayName(index)),
  );

  void onDaysChanged(Set<int> newSelection) {
    daysOpen = newSelection;

    // Sincronizamos el booleano isOpen en nuestros modelos
    for (int i = 0; i < weekSchedules.length; i++) {
      weekSchedules[i].isOpen = daysOpen.contains(i);
      // If not contains make it null
      weekSchedules[i].deleteTimesOnClosed();
    }
    notifyListeners();
  }

  static String _getDayName(int i) => [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ][i];

  Map<String, dynamic>? genScheduleMap() {
    final Map<String, dynamic> scheduleMap = {
      for (var day in weekSchedules) day.dayName: day.toJson(),
    };
    return scheduleMap;
  }

  //------------------------------TERMS & CONDITIONS-------------------
  bool _isAccepted = false;
  bool get isAccepted => _isAccepted;
  String? _privacyMd;
  String? _termsMd;
  bool _isLoading = true;

  String get privacyData => _privacyMd ?? "";
  String get termsData => _termsMd ?? "";
  bool get isLoading => _isLoading;

  void setAccepted(bool value) {
    _isAccepted = value;
    notifyListeners();
  }
}

// Class to manage open times of week
class DaySchedule {
  final String dayName;
  bool isOpen;
  TimeOfDay? openTime;
  TimeOfDay? closeTime;

  DaySchedule({
    required this.dayName,
    this.isOpen = false,
    this.openTime,
    this.closeTime,
  });

  void deleteTimesOnClosed() {
    if (!isOpen) {
      openTime = closeTime = null;
    }
  }

  bool isUncomplete() {
    return (openTime == null || closeTime == null);
  }

  // Convierte el objeto a un mapa compatible con JSONB
  Map<String, dynamic> toJson() => {
    'isOpen': isOpen,
    'open': openTime != null ? timeOfDaytoString(openTime!) : null,
    'close': closeTime != null ? timeOfDaytoString(closeTime!) : null,
  };

  String timeOfDaytoString(TimeOfDay value) {
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }
}
