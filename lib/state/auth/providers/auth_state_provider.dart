import 'package:hooks_riverpod/hooks_riverpod.dart' show StateNotifierProvider;
import 'package:student_attendance/state/auth/models/auth_state.dart';
import 'package:student_attendance/state/auth/notifiers/auth_state_notifier.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(),
);

