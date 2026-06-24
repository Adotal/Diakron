import 'dart:io';
import 'package:diakron_collection_center/ui/upload_files/view_models/upload_files_viewmodel.dart';
import 'package:diakron_collection_center/utils/result.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final _logger = Logger();

  Future<Result<Map<String, dynamic>>> getCollectionCenter() async {
    try {
      if (_supabase.auth.currentUser != null) {
        final store = await _supabase
            .from('full_collection_centers')
            .select()
            .eq('id', _supabase.auth.currentUser!.id)
            .single();

        return Result.ok(store);
      }
      return Result.error(Exception('Null user'));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  // Obtain all data in table that match a value in column
  Future<Result<List<Map<String, dynamic>>>> fetchTableWhere({
    required String table,
    required String column,
    required String value,
  }) async {
    try {
      final result = await _supabase.from(table).select().eq(column, value);
      return Result.ok(result);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  /// Obtiene un registro único por ID de cualquier tabla
  Future<Map<String, dynamic>> getRecordById({
    required String table,
    required String id,
  }) async {
    return await _supabase
        .from(table)
        .select()
        .eq('id', id)
        .single(); // Trae un solo objeto, no una lista
  }

  /// Actualiza datos en una tabla específica
  Future<Result<void>> uploadUserData({
    required String table,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _supabase.from(table).update(data).eq('id', id);
      return Result.ok(null);
    } catch (e) {
      // This will catch if the table doesn't exist or a constraint is violated
      return Result.error(e as Exception);
    }
  }

  // --- Operaciones de Storage (Archivos) ---

  /// Sube un archivo y retorna la ruta interna (path)
  Future<String?> uploadFile({
    required String id,
    required String fileName,
    required File file,
  }) async {
    try {
      // The path MUST start with the userId for the RLS to pass
      final String path = '$id/$fileName';
      // Usamos 'upsert: true' por si el usuario reintenta una subida fallida
      await _supabase.storage
          .from('diakron_storage_private')
          .upload(path, file, fileOptions: const FileOptions(upsert: true));

      return path;
    } catch (e) {
      _logger.e("Upload failed: $e");
      return null;
    }
  }

  /// (Opcional) Escucha cambios en tiempo real de un registro
  Stream<Map<String, dynamic>> subscribeToRecord({
    required String table,
    required String id,
  }) {
    return _supabase
        .from(table)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((list) => list.first);
  }

  Future<List<Map<String, dynamic>>> fetchAllWasteTypes() async {
    try {
      final data = await _supabase
          .from('waste_types')
          .select('*')
          .order('waste_type', ascending: true); // Keeps the list alphabetical
      _logger.d(data);
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      _logger.e(e);
      return [{}];
    }
  }

  // Inserts in intermediate table for waste types
  Future<void> saveCenterCapabilities({
    required String centerId,
    required List<int> selectedWasteIds,
  }) async {
    try {
      // 1. Clear old selections for this center
      await _supabase
          .from('collection_center_waste')
          .delete()
          .eq('id_collection_center', centerId);

      // 2. Prepare the new rows
      final newRows = selectedWasteIds
          .map((id) => {'id_collection_center': centerId, 'id_waste_type': id})
          .toList();

      // 3. Bulk insert
      if (newRows.isNotEmpty) {
        await _supabase.from('collection_center_waste').insert(newRows);
      }
    } catch (e) {
      _logger.e(e);
    }
  }

  // Obtain all data in table
  Future<Result<List<Map<String, dynamic>>>> fetchTable({
    required String table,
  }) async {
    try {
      // ONLY ID AND COMPANY NAME
      final result = await _supabase.from(table).select();
      return Result.ok(result);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  // Call RPC with 1 param
  Future<Result<List<Map<String, dynamic>>>> callRPC({
    required String rpcName,
    required Map<String, dynamic> params,
  }) async {
    try {
      final result = await _supabase.rpc(rpcName, params: params);
      // This safely converts each item in the list
      return Result.ok(
        (result as List).map((e) => e as Map<String, dynamic>).toList(),
      );
      // return Result.ok(List<Map<String, dynamic>>.from(result.value));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
