import 'dart:io';

import 'package:diakron_collection_center/data/services/database_service.dart';
import 'package:diakron_collection_center/models/users/collection_center.dart';
import 'package:diakron_collection_center/models/waste_collection/waste_collection.dart';
import 'package:diakron_collection_center/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CCenterRepository extends ChangeNotifier {
  CCenterRepository({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;
  CollectionCenter? _cachedCCenter;
  CollectionCenter get ccenter => _cachedCCenter!;
  final _logger = Logger();

  Future<Result<CollectionCenter>> getCollectionCenter({
    bool forceRefresh = false,
  }) async {
    if (_cachedCCenter != null && !forceRefresh) {
      _logger.i(
        'Returned cached ${_cachedCCenter!.validationStatus} ${_cachedCCenter.toString()}',
      );
      return Future.value(Result.ok(_cachedCCenter!));
    }
    final result = await _databaseService.getCollectionCenter();
    switch (result) {
      case Success<Map<String, dynamic>>():
        _cachedCCenter = CollectionCenter.fromJson(result.value);

        _logger.i(
          'Returned refreshed ${_cachedCCenter!.validationStatus} ${_cachedCCenter.toString()}',
        );
        notifyListeners();

        return Result.ok(_cachedCCenter!);
      case Failure<Map<String, dynamic>>():
        return Result.error(result.error);
    }
  }

  Future<void> clearCache() async {
    _cachedCCenter = null;
    notifyListeners();
  }

  Future<String?> uploadFile({
    required String id,
    required String fileName,
    required File file,
  }) async {
    return await _databaseService.uploadFile(
      id: id,
      fileName: fileName,
      file: file,
    );
  }

  Future<Result<void>> uploadUserData(
    String table,
    String id,
    CollectionCenter collectionCenter,
  ) async {
    final fullMap = collectionCenter.toJson();
    final String id = collectionCenter.id!;

    const userTableKeys = {
      'email',
      'id',
      'user_name',
      'surnames',
      'phone_number',
      'is_active',
      'user_type',
      'created_at',
    };

    // Map without userbase data
    final specificData = Map<String, dynamic>.from(fullMap)
      ..removeWhere((key, _) => userTableKeys.contains(key));

    final result = await _databaseService.uploadUserData(
      table: table,
      id: id,
      data: specificData,
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> fetchAllWasteTypes() async {
    return await _databaseService.fetchAllWasteTypes();
  }

  Future<void> saveCenterCapabilities({
    required String centerId,
    required List<int> selectedWasteIds,
  }) async {
    await _databaseService.saveCenterCapabilities(
      centerId: centerId,
      selectedWasteIds: selectedWasteIds,
    );
  }

  Future<Result<WasteCollection>> fetchCollection({
    required String idCollection,
  }) async {
    try {
      final result = await _databaseService.fetchTableWhere(
        table: 'waste_collections',
        column: 'id',
        value: idCollection,
      );

      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          // Returns only content of first an unique resukt
          final WasteCollection collection = WasteCollection.fromJson(
            result.value[0],
          );
          return Result.ok(collection);
        case Failure<List<Map<String, dynamic>>>():
          _logger.e(result.error);
          return Result.error(result.error);
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Map<String, dynamic>>>> fetchWasteTypes() async {
    try {
      final result = await _databaseService.fetchTable(table: 'waste_types');

      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          return Result.ok(result.value);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<WasteCollection>>> fetchWasteCollections() async {
    try {
      final result = await _databaseService.fetchTableWhere(
        table: 'full_waste_collections',
        column: 'id_collection_center',
        value: _cachedCCenter!.id!,
      );

      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          List<WasteCollection> wasteCollections = (result.value as List)
              .map((json) => WasteCollection.fromJson(json))
              .toList();

          return Result.ok(wasteCollections);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Map<String, dynamic>>>> geCollectionWeights() async {
    try {
      final result = await _databaseService.callRPC(
        rpcName: 'get_mass_summary',
        params: Map.from({'ccenter_id': _cachedCCenter!.id}),
      );

      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          return Result.ok(result.value);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
