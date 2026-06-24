import 'dart:io';
import 'package:diakron_admin/models/users/user_base/user_base.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final _logger = Logger();

  Future<Result<Map<String, dynamic>>> getAdmin() async {
    try {
      if (_supabase.auth.currentUser != null) {
        final participant = await _supabase
            .from('full_admins')
            .select()
            .eq('id', _supabase.auth.currentUser!.id)
            .single();
        return Result.ok(participant);
      }
      return Result.error(Exception('Null user'));
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<String>> getValidationStatus(String userId) async {
    _logger.w('User id: $userId');
    try {
      // 1. Consultamos solo la columna necesaria para ahorrar ancho de banda
      final data = await _supabase
          .from('collection_centers')
          .select('validation_status')
          .eq('id', userId)
          .single();

      // 2. Mapeamos el String de la DB al Enum que creaste
      final String status = data['validation_status'] ?? 'UPLOADING';
      _logger.w(data['validation_status']);

      return Result.ok(status);
    } on Exception catch (error) {
      _logger.e('User id: $userId');
      return Result.error(error);
    }
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
      final String fullPath = await _supabase.storage
          .from('diakron_storage_private')
          .upload(path, file, fileOptions: const FileOptions(upsert: true));

      return fullPath; // Retornamos el path para guardarlo en la DB
    } catch (e) {
      _logger.e("Upload failed: $e");
      return null;
    }
  }

  // Obtain all data in table
  Future<Result<List<Map<String, dynamic>>>> fetchColumnsTable({
    required String table,
    required String columns,
  }) async {
    try {
      // ONLY ID AND COMPANY NAME
      final result = await _supabase.from(table).select(columns);
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

  /// Obtiene un registro único por ID de cualquier tabla
  Future<Result<Map<String, dynamic>>> getRecordById({
    required String table,
    required String id,
  }) async {
    try {
      final result = await _supabase.from(table).select().eq('id', id).single();
      _logger.i(result);
      return Result.ok(result);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  /// Obtiene un registro único por ID de cualquier tabla
  Future<Result<Map<String, dynamic>>> getUserById({
    required String table,
    required String id,
  }) async {
    try {
      final result = await _supabase.from(table).select().eq('id', id).single();
      _logger.i(result);
      return Result.ok(result);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> updateFullUser(UserBase user) async {
    try {
      final fullMap = user.toJson();
      final String id = user.id!;

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

      // Map only for the 'users' table
      final userData = Map<String, dynamic>.from(fullMap)
        ..removeWhere((key, _) => !userTableKeys.contains(key));

      // Map for the specific sub-table (e.g., collection_centers)
      final specificData = Map<String, dynamic>.from(fullMap)
        ..removeWhere((key, _) => userTableKeys.contains(key));

      _logger.w('USER DATA: $userData\n SPECIFIC DATA: $specificData');

      // Table name (pluralized version of user_type)
      final tableName = "${user.userType}s";

      // Run both in parallel for efficiency
      final result = await Future.wait([
        _supabase.from('users').update(userData).eq('id', id),
        _supabase.from(tableName).update(specificData).eq('id', id),
      ]);
      _logger.w(result);
      return Result.ok(null);
    } on Exception catch (error) {
      _logger.e(error);
      return Result.error(Exception(error));
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

  // Future<Result<void>> deleteUserById({required String id}) async {
  //   try {
  //     await _supabase.auth.admin.deleteUser(id);
  //     return Result.ok(null);
  //   } on Exception catch (error) {
  //     _logger.e(error);
  //     return Result.error(Exception(error));
  //   }
  // }

  Future<Result<void>> deleteRecordById({
    required String table,
    required String id,
  }) async {
    try {
      await _supabase.from(table).delete().eq('id', id);
      _logger.i('DELETED FROM SERVICE $table $id');
      return Result.ok(null);
    } on Exception catch (error) {
      _logger.e(error);
      return Result.error(Exception(error));
    }
  }

  Future<Result<List<Map<String, dynamic>>>> fetchAllWasteTypes() async {
    try {
      final data = await _supabase
          .from('waste_types')
          .select('*')
          .order('id', ascending: true); // Keeps the list alphabetical
      return Result.ok(List<Map<String, dynamic>>.from(data));
    } on Exception catch (error) {
      _logger.e(error);
      return Result.error(error);
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

  // For read private PDF docs
  Future<Result<String?>> getTemporaryUrl(String path) async {
    try {
      // Generate a URL that expires in 10 mins
      final String signedUrl = await _supabase.storage
          .from('diakron_storage_private')
          .createSignedUrl(path, 600);

      return Result.ok(signedUrl);
    } on Exception catch (error) {
      _logger.e("Error generating signed URL: $error on \n$path");
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

  Future<int> getTotalPoints() async {    
    return await _supabase.rpc('get_total_points_exchanged');
  }
  Future<int> getTotalComissions() async {    
    return await _supabase.rpc('get_total_comissions');
  }
}
