import 'dart:io';
import 'package:diakron_stores/utils/result.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final _logger = Logger();

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
  Future<String?> uploadPrivateFile({
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

      return path; // Retornamos el path para guardarlo en la DB
    } catch (e) {
      _logger.e("Upload failed: $e");
      return null;
    }
  }

  Future<String?> uploadPublicFile({
    required String id,
    required String fileName,
    required File file,
  }) async {
    try {
      // The path MUST start with the userId for the RLS to pass
      final String path = '$id/$fileName';
      // Usamos 'upsert: true' por si el usuario reintenta una subida fallida
      await _supabase.storage
          .from('diakron_storage_public')
          .upload(path, file, fileOptions: const FileOptions(upsert: true));

      return path; // Retornamos el path para guardarlo en la DB
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

  Future<Result<Map<String, dynamic>>> getStore() async {
    try {
      if (_supabase.auth.currentUser != null) {
        final store = await _supabase
            .from('full_stores')
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
    required String value
  }) async {
    try {
      final result = await _supabase.from(table).select().eq(column, value);
      return Result.ok(result);
    } on Exception catch (error) {
      return Result.error(error);
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

  Future<Result<void>> insertTable({
    required String table,
    required Map<String, dynamic> values,
  }) async {
    try {
      await _supabase.from(table).insert(values);
      return Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> deleteRecordById({
    required String table,
    required String id,
  }) async {
    try {
      await _supabase.from(table).delete().eq('id', id);
      return Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> updateRecordById({
    required String table,
    required String id,
    required Map<String, dynamic> values,
  }) async {
    try {
      await _supabase.from(table).update(values).eq('id', id);
      return Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> deleteFromPublicStorage({required String path}) async {
    try {
      await _supabase.storage.from('diakron_storage_public').remove([path]);
      return Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<int>> manyCoupons({required String storeId}) async {
    try {
      final response = await _supabase.from('coupons').count().eq('id_store', storeId);
      // int count = response;
      return Result.ok(response);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
  Future<Result<void>> deleteUserById({required String id}) async {
    try {
      await _supabase.rpc('delete_user_secure', params: {'target_user_id': id});
      // If they deleted themselves, sign them out locally
      if (id == _supabase.auth.currentUser?.id) {
        await _supabase.auth.signOut();
      }

      _logger.i("User $id removed from the system.");
      return Result.ok(null);
    } on Exception catch (error) {
      _logger.e('Error deleting user');
      return Result.error(error);
    }
  }

  Future<Result<void>> updateData({
    required String table,
    required Map<String, dynamic> map,
    required String id,
  }) async {
    try {
      await _supabase.from(table).update(map).eq('id', id);
      return Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

}
