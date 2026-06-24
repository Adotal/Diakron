import 'dart:io';
import 'package:diakron_collection_center/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collection_center/data/repositories/user/ccenter_repository.dart';
import 'package:diakron_collection_center/models/core/taxpayer_type/taxpayer_type.dart';
import 'package:diakron_collection_center/models/core/validation_status/validation_status.dart';
import 'package:diakron_collection_center/models/users/collection_center.dart';
import 'package:diakron_collection_center/utils/command.dart';
import 'package:diakron_collection_center/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class UploadFilesViewModel extends ChangeNotifier {
  // Controllers live here to persist data between page swipes
  UploadFilesViewModel({
    required CCenterRepository userRepository,
    required AuthRepository authRepository,
  }) : _userRepository = userRepository,
       _authRepository = authRepository {
    load = Command0(_load)..execute();
    completeRegistration = Command0(_completeRegistration);
  }

  final _logger = Logger();

  late Command0 load;
  late Command0 completeRegistration;

  final CCenterRepository _userRepository;
  final AuthRepository _authRepository;

  CollectionCenter? _collectionCenter;
  CollectionCenter? get collectionCenter => _collectionCenter;

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

  // Company data
  final companyNameController = TextEditingController(
    
  );
  final commercialNameController = TextEditingController(
    
  );
  final curpController = TextEditingController();
  final addressController = TextEditingController();
  final taxAddressController = TextEditingController();
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
    // Fetch collectionCenter
    final collectionCenterResult = await _userRepository.getCollectionCenter(
      forceRefresh: true,
    );
    switch (collectionCenterResult) {
      case Success<CollectionCenter>():
        _collectionCenter = collectionCenterResult.value;

      case Failure<CollectionCenter>():
        _logger.e(
          'Error fetching initial collectionCenter ${collectionCenterResult.error}',
        );
        return Result.error(collectionCenterResult.error);
    }

    //------------------------CHECKBOX OF WASTE TYPES---------------
    allWasteTypes = await _userRepository.fetchAllWasteTypes();

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

    if (selectedWasteIds.isEmpty) {
      timeErrorMsj = 'Debe haber al menos un tipo de desecho aceptado';
      notifyListeners();
      return false;
    }

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
    return collectionCenter!.pathIdRep != null &&
        collectionCenter!.pathProofAddress != null &&
        collectionCenter!.pathTaxCertificate != null;
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
    curpController.dispose();
    addressController.dispose();
    taxAddressController.dispose();
    postCodeController.dispose();
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
      case 'pathIdRep':
        _collectionCenter = _collectionCenter!.copyWith(pathIdRep: value);
        break;
      case 'pathProofAddress':
        _collectionCenter = _collectionCenter!.copyWith(
          pathProofAddress: value,
        );
        break;
      case 'pathTaxCertificate':
        _collectionCenter = _collectionCenter!.copyWith(
          pathTaxCertificate: value,
        );
        break;
    }
    notifyListeners();
  }

  void syncAllToModel() {
    _collectionCenter = _collectionCenter!.copyWith(
      // Now that have uploated files, status is pending
      validationStatus: ValidationStatus.pending,

      companyName: companyNameController.text,
      commercialName: commercialNameController.text,
      curpRep: curpController.text,
      rfc: rfcController.text,
      taxRegime: taxRegimeController.text,
      taxpayerType: currentType.label,
      schedule: genScheduleMap(),
      postCode: postCodeController.text,
      clabe: clabeController.text,
      billingEmail: billingEmailController.text,
      bank: bankController.text,
      address: addressController.text,
      taxAddress: taxAddressController.text,
      // Already in model:
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

      // Upload ID
      _updateProgress("Subiendo: Identificación del Representante...");
      await uploadDocument(userId, _collectionCenter!.pathIdRep, 'pathIdRep');

      // Upload Proof Address
      _updateProgress("Subiendo: Comprobante de Domicilio...");
      await uploadDocument(
        userId,
        _collectionCenter!.pathProofAddress,
        'pathProofAddress',
      );
      // Upload Tax Certificate
      _updateProgress("Subiendo: Constancia de Situación Fiscal...");
      await uploadDocument(
        userId,
        _collectionCenter!.pathTaxCertificate,
        'pathTaxCertificate',
      );
      _updateProgress("Subiendo tipos de materiales");
      await _userRepository.saveCenterCapabilities(
        centerId: _authRepository.userId,
        selectedWasteIds: selectedWasteIds,
      );

      // Database sync
      _updateProgress("Finalizando: Información del Centro de Acopio...");

      // Upload all data to Database
      final result = await _userRepository.uploadUserData(
        'collection_centers',
        _authRepository.userId,
        _collectionCenter!,
      );
      switch (result) {
        case Success():
          _updateProgress('Todo listo!');
          _logger.d(_collectionCenter!.toJson());
          _isProcessing = false;
          return Result.ok(null);

        case Failure():
          _updateProgress("Error al subir los datos. Reintenta.");
          await Future.delayed(Duration(seconds: 5));
          _isProcessing = false;
          _logger.e('${_collectionCenter!.toJson()}\n ${result.error}');
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
  ) async {
    if (localPath == null) return;

    final file = File(localPath);
    if (!await file.exists()) return;

    // Use the docType (e.g., 'pathIdRep') as the filename, but quit 'path', quit first 4 chars

    final fileName = "${docType.substring(4)}.pdf";

    final result = await _userRepository.uploadFile(
      id: userId,
      fileName: fileName,
      file: file,
    );

    _logger.i('PATH: $result');

    if (result != null) {
      // Update the model with the STORAGE path, not the local path
      switch (docType) {
        case 'pathIdRep':
          _collectionCenter = _collectionCenter!.copyWith(pathIdRep: result);
          break;
        case 'pathProofAddress':
          _collectionCenter = _collectionCenter!.copyWith(
            pathProofAddress: result,
          );
          break;
        case 'pathTaxCertificate':
          _collectionCenter = _collectionCenter!.copyWith(
            pathTaxCertificate: result,
          );
          break;
      }

      notifyListeners();
    }
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

  //----------------------WASTE TYPES CHECKBOX----------------------------
  List<int> selectedWasteIds = [];
  List<Map<String, dynamic>> allWasteTypes = [
    // {'id': 1, 'waste_type': 'PLÁSTICO'},
    // {'id': 2, 'waste_type': 'METAL'},
    // {'id': 3, 'waste_type': 'PAPEL/CARTÓN'},
    // {'id': 4, 'waste_type': 'VIDRIO'},
  ];

  void onSelectedWasteType(bool? checked, type) {
    if (checked == true) {
      selectedWasteIds.add(type['id']);
    } else {
      selectedWasteIds.remove(type['id']);
    }
    notifyListeners();
    _logger.w(selectedWasteIds);
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
