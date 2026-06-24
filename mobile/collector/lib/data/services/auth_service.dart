import 'package:diakron_collectors/utils/displayable_exception.dart';
import 'package:diakron_collectors/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Provide a stream of auth changes
  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;

  String? get currentUserId => _supabase.auth.currentUser?.id;
  Session? get currentSession => _supabase.auth.currentSession;

  // Sign in (login)
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final result = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // Check user role is participant, maybeSingle() to prevent Postgrest exceptions if row is missing
    final data = await _supabase
        .from('users')
        .select('user_type')
        .eq('id', result.user!.id)
        .maybeSingle();

    // Check the data
    bool isCollector = data != null && data['user_type'] == 'collector';

    if (!isCollector) {
      await _supabase.auth.signOut(); // Ensure explicit sign-out
      throw DisplayableException('Credenciales inválidas');
    }

    return result;
  }

  // Sign up
  Future<AuthResponse> sigUpEmailPassword({
    required String email,
    required String password,
    required String username,
    required String surnames,
    required String phoneNumber,
  }) async {
    final result = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'user_name': username,
        'surnames': surnames,
        'phone_number': phoneNumber,
        // Empieza desactivado porque es solicitud de registro
        'is_active': false,
        // Siempre es collector
        'user_type': 'collector',
      },
    );

    return result;
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Send email password recover

  Future<Result<void>> sendEmailforgetPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.diakron.admin://reset-password/',
      );
      return Result.ok(null);
    } catch (error) {
      return Result.error(Exception(error));
    }
  }

  // Update user password
  Future<Result<UserResponse>> updatePassword({
    required String password,
  }) async {
    try {
      final result = await _supabase.auth.updateUser(
        UserAttributes(password: password),
      );
      return Result.ok(result);
    } catch (error) {
      return Result.error(Exception(error));
    }
  }

  // get Email
  String? getEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;

    return user?.email;
  }
}
