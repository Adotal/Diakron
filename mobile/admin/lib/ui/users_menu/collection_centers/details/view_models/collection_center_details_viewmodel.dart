import 'package:diakron_admin/data/repositories/global/waste_repository.dart';
import 'package:diakron_admin/data/repositories/users/collection_center_repository.dart';
import 'package:diakron_admin/models/core/schedule/day_schedule.dart';
import 'package:diakron_admin/models/core/taxpayer_type/taxpayer_type.dart';
import 'package:diakron_admin/models/users/collection_center/collection_center.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:url_launcher/url_launcher.dart';

class CollectionCenterDetailsViewModel extends ChangeNotifier {
  CollectionCenterDetailsViewModel({
    required CollectionCenterRepository repository,
    required WasteRepository wasteRepository,
    required this.centerId,
  }) : _ccenterRepository = repository,
  _wasteRepository = wasteRepository {
    load = Command0(_load)..execute();
    deleteCCenter = Command0(_deleteCCenter);
    updateCCenter = Command0(_updateCCenter);
    changeValidationStatus = Command1(_changeValidationStatus);
  }

  final WasteRepository _wasteRepository;
  WasteRepository get wasteRepository => _wasteRepository;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  void toggleEdit() {
    _isEditing = !_isEditing;
    if (_isEditing) {
      editedCenter = center;
    }
    notifyListeners();
  }

  TaxpayerType? taxpayerType;

  final CollectionCenterRepository _ccenterRepository;
  final String centerId;

  late Command0 load;
  late Command0 deleteCCenter;
  late Command0 updateCCenter;
  late Command1<void, String> changeValidationStatus;
  CollectionCenter? center;
  CollectionCenter? editedCenter;

  final _logger = Logger();

  Future<Result<void>> _changeValidationStatus(String status) async {
    try {
      final result = await _ccenterRepository.changeValidationStatus(
        status,
        centerId,
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

  Future<Result> _updateCCenter() async {
    try {
      final result = await _ccenterRepository.updateCCenter(editedCenter!);

      switch (result) {
        case Success<void>():
          _logger.i('Updated CCenter successfully');
        case Failure<void>():
          _logger.e('ERROR UPDATING CCENTER');
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result> _load() async {
    try {
      // Fetch fresh data for this specific center
      final result = await _ccenterRepository.getCollectionCenterById(centerId);

      switch (result) {
        case Success<CollectionCenter>():
          center = result.value;
          _logger.w(center!.wasteTypeIds.toString());
        case Failure<CollectionCenter>():
          return result;
      }

      // FILL SPECIAL FIELDS

      if (center != null) {
        if (center?.taxpayerType != null) {
          taxpayerType = TaxpayerType.fromString(center!.taxpayerType!);
        }

        loadFromJson(center!.schedule!);
      }

      return result;
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _deleteCCenter() async {
    try {
      final result = await _ccenterRepository.deleteCCenter(id: centerId);
      switch (result) {
        case Success<void>():
          _logger.i('Successfully deleted center');
        case Failure<void>():
          _logger.e('Error deleted center');
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
      final result = await _ccenterRepository.getTemporaryUrl(path);
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
}
