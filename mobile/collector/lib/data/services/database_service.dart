import 'package:diakron_collectors/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

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

  Future<Result<Map<String, dynamic>>> getCollector() async {
    try {
      if (_supabase.auth.currentUser != null) {
        final participant = await _supabase
            .from('full_collectors')
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

  Future<Result<List<Map<String, dynamic>>>> fetchCoupons() async {
    try {
      // Retrieve MAX 100 records
      final result = await _supabase
          .from('coupons')
          .select()
          .eq('is_active', true)
          .limit(100);
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

  Future<Map<String, dynamic>> getRecordById({
    required String table,
    String columns = '*',
    required String id,
  }) async {
    return await _supabase
        .from(table)
        .select(columns)
        .eq('id', id)
        .single(); // Trae un solo objeto, no una lista
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

  Future<Result<bool>> addfavoriteCoupon({
    required int couponId,
    required String participantId,
  }) async {
    try {
      final response = await _supabase
          .from('favorite_coupons')
          .select('id')
          .eq('id_coupon', couponId)
          .eq('id_participant', participantId)
          .maybeSingle(); // Returns null if no record is found

      final isFavorite = (response != null);
      return Result.ok(isFavorite);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> delfavoriteCoupon({
    required int couponId,
    required String participantId,
  }) async {
    try {
      await _supabase
          .from('favorite_coupons')
          .delete()
          .eq('id_coupon', couponId)
          .eq('id_participant', participantId);
      return Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Map>>> fetchFavoriteCoupons({
    required String participantId,
  }) async {
    try {
      final result = await _supabase
          .from('favorite_coupons')
          .select('''
          id_coupon,
          coupons (*)
        ''')
          .eq('id_participant', participantId);

      return Result.ok(result);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  // Obtain all data in table that match a value in column
  Future<Result<List<Map<String, dynamic>>>> fetchUserWasteStats({
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
}
