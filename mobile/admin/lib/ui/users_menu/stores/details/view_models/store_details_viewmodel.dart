import 'dart:convert';

import 'package:diakron_admin/data/repositories/users/store_repository.dart';
import 'package:diakron_admin/models/core/schedule/day_schedule.dart';
import 'package:diakron_admin/models/core/taxpayer_type/taxpayer_type.dart';
import 'package:diakron_admin/models/users/store/store.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/displayable_exception.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDetailsViewModel extends ChangeNotifier {
  StoreDetailsViewModel({
    required StoreRepository storeRepository,
    required this.storeId,
    required this.totalPoints,
  }) : _storeRepository = storeRepository {
    load = Command0(_load)..execute();
    deleteStore = Command0(_deleteStore);
    updateStore = Command0(_updateStore);
    changeValidationStatus = Command1(_changeValidationStatus);
    payment = Command0(_payment);
  }

  int totalPoints;
  double _totalMoneyToGive = 0;
  double get totalMoneyToGive => _totalMoneyToGive;

  double get repPercentage => store!.pointsExchanged * 100 / totalPoints;
  double get incentiveMoney => _totalMoneyToGive * repPercentage / 100;

  bool _isEditing = false;
  bool get isEditing => _isEditing;


  String? _checkoutURL;
  String get checkoutURL => _checkoutURL!;

  void toggleEdit() {
    _isEditing = !_isEditing;
    if (_isEditing) {
      editedCenter = store;
    }
    notifyListeners();
  }

  TaxpayerType? taxpayerType;

  final StoreRepository _storeRepository;
  final String storeId;

  late Command0 load;
  late Command0 deleteStore;
  late Command0 updateStore;
  late Command1<void, String> changeValidationStatus;
  late final Command0 payment;
  Store? store;
  Store? editedCenter;

  final _logger = Logger();

  Future<Result<void>> _changeValidationStatus(String status) async {
    _logger.i('New $status\n $storeId');
    try {
      final result = await _storeRepository.changeValidationStatus(
        status,
        storeId,
      );

      switch (result) {
        case Success<void>():
          _logger.i('Changed status to $status');
        case Failure<void>():
          _logger.e('ERROR CHANGING STATUS ${result.error}');
      }

      // Reload
      load.execute();
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result> _updateStore() async {
    try {
      final result = await _storeRepository.updateStore(editedCenter!);

      switch (result) {
        case Success<void>():
          _logger.i('Updated Store successfully');
        case Failure<void>():
          _logger.e('ERROR UPDATING Store');
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result> _load() async {
    try {
      // Fetch fresh data for this specific store
      final result = await _storeRepository.getStoreById(storeId);

      switch (result) {
        case Success<Store>():
          store = result.value;
          _logger.d(store);
        case Failure<Store>():
          return result;
      }
      // FILL SPECIAL FIELDS

      if (store != null) {
        if (store?.taxpayerType != null) {
          taxpayerType = TaxpayerType.fromString(store!.taxpayerType!);
        }

        loadFromJson(store!.schedule!);
      }

      final resultComissions = await _storeRepository.getTotalComissions();
      switch (resultComissions) {
        case Success<int>():
          _totalMoneyToGive = resultComissions.value * 0.75;
          _logger.i(_totalMoneyToGive);
          return const Result.ok(null);
        case Failure<int>():
          _logger.e(resultComissions.error);
          return Result.error(resultComissions.error);
      }

      return result;
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _deleteStore() async {
    try {
      final result = await _storeRepository.deleteStore(id: storeId);
      switch (result) {
        case Success<void>():
          _logger.i('Successfully deleted store');
        case Failure<void>():
          _logger.e('Error deleted store');
      }

      return result;
    } finally {
      notifyListeners();
    }
  }

  //-----------------------------SCHEDULE----------------------------
  final List<DaySchedule> weekSchedules = [
    DaySchedule(dayName: "Lunes"),
    DaySchedule(dayName: "Martes"),
    DaySchedule(dayName: "Miércoles"),
    DaySchedule(dayName: "Jueves"),
    DaySchedule(dayName: "Viernes"),
    DaySchedule(dayName: "Sábado"),
    DaySchedule(dayName: "Domingo"),
  ];

  Set<int> daysOpen = {};

  // Initialize data from your JSON Map
  void loadFromJson(Map<String, dynamic> json) {
    for (int i = 0; i < weekSchedules.length; i++) {
      final dayName = weekSchedules[i].dayName;
      if (json.containsKey(dayName)) {
        final data = json[dayName];
        weekSchedules[i].isOpen = data['isOpen'] ?? false;

        if (data['open'] != null) {
          weekSchedules[i].openTime = _parseTimeString(data['open']);
        }
        if (data['close'] != null) {
          weekSchedules[i].closeTime = _parseTimeString(data['close']);
        }

        if (weekSchedules[i].isOpen) {
          daysOpen.add(i);
        }
      }
    }
    notifyListeners();
  }

  // Convert current state back to JSON Map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    for (var day in weekSchedules) {
      result[day.dayName] = {
        "open": day.timeToString(day.openTime),
        "close": day.timeToString(day.closeTime),
        "isOpen": daysOpen.contains(weekSchedules.indexOf(day)),
      };
    }
    return result;
  }

  void onDaysChanged(Set<int> newSelection) {
    daysOpen = newSelection;
    // Set isOpen boolean based on selection
    for (int i = 0; i < weekSchedules.length; i++) {
      weekSchedules[i].isOpen = daysOpen.contains(i);
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

  String? getErrorMessage(int index) {
    final day = weekSchedules[index];
    if (day.openTime != null && day.closeTime != null) {
      final start = day.openTime!.hour * 60 + day.openTime!.minute;
      final end = day.closeTime!.hour * 60 + day.closeTime!.minute;
      if (start >= end) {
        return "La hora de cierre debe ser posterior a la apertura";
      }
    }
    return null;
  }

  TimeOfDay? _parseTimeString(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  //-----------------------------SCHEDULE----------------------------

  // Inside your Admin-facing Page or ViewModel
  Future<Result<void>> viewDocument(String path) async {
    try {
      final result = await _storeRepository.getTemporaryUrl(path);
      switch (result) {
        case Success<String?>():
          if (result.value != null) {
            String signedUrl = result.value!;
            final Uri url = Uri.parse(signedUrl);
            _logger.w('Opnening $url');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch PDF viewer for $signedUrl';
            }
          }
        case Failure<String?>():
          _logger.e('Error retreiving url');
      }

      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _payment() async {

     const url = 'https://diakron-backend.onrender.com/admin-payout-store';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        // ENVIAMOS EL PRECIO REAL
        body: jsonEncode({
          'storeId': store!.id,
          'amount': incentiveMoney,
          'rep_percentage': repPercentage,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _checkoutURL = data['initPoint'];
        _logger.i('Preferencia obtenida: $checkoutURL');        
        return Result.ok(null);
      } else {
        _logger.e('Error del servidor: ${response.body}');
        return Result.error(DisplayableException(response.body));
      }
    } on DisplayableException catch (error) {
      _logger.e('Fallo de conexión: $error');
      return Result.error(error);
    }  
  }
}
