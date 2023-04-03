import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:student_attendance/state/auth/providers/auth_state_provider.dart';

part 'is_loading_provider.g.dart';

@riverpod
bool isLoading(IsLoadingRef ref) {
  final authState = ref.watch(authStateProvider);
  //final isUploadingImage = ref.watch(imageUploaderProvider);
  //final isSendingComment = ref.watch(sendCommentProvider);
  //final isDeletingComment = ref.watch(deleteCommentProvider);
  //final isDeletingPost = ref.watch(deletePostProvider);
  return authState.isLoading;
}
