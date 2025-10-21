import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jobarchy_flutter_app/core/network/api_service.dart';
import 'package:jobarchy_flutter_app/core/network/network_exceptions.dart';
import 'package:jobarchy_flutter_app/core/utils/app_constant.dart';
import 'package:jobarchy_flutter_app/features/model/postmodel/postmodel.dart';

final deletePostViewModelProvider =
    StateNotifierProvider<DeletePostViewModel, AsyncValue<UserPostModel?>>(
      (ref) => DeletePostViewModel(),
    );

class DeletePostViewModel extends StateNotifier<AsyncValue<UserPostModel?>> {
  final ApiService _apiService = ApiService();

  DeletePostViewModel() : super(const AsyncData(null));

  Future<void> deleteUserPost(int postId) async {
    state = const AsyncLoading();
    try {
      final data = await _apiService.delete(APIEndPoint.deletePost(postId));
      final posts = UserPostModel.fromJson(data);
      state = AsyncData(posts);
    } on NoInternetException {
      state = AsyncError('No Internet Connection', StackTrace.current);
    } on NetworkException catch (e) {
      state = AsyncError(e.message, StackTrace.current);
    } catch (e, stackTrace) {
      state = AsyncError('Unexpected error occurred: $e', stackTrace);
    }
  }
}
