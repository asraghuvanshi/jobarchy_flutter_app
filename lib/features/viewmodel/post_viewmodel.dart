import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jobarchy_flutter_app/core/network/api_service.dart';
import 'package:jobarchy_flutter_app/core/network/network_exceptions.dart';
import 'package:jobarchy_flutter_app/features/model/postmodel.dart';

final postViewModelProvider =
    StateNotifierProvider<PostViewModel, AsyncValue<UserPostModel?>>(
      (ref) => PostViewModel(),
    );

class PostViewModel extends StateNotifier<AsyncValue<UserPostModel?>> {
  final ApiService _apiService = ApiService();

  PostViewModel() : super(const AsyncData(null));

  Future<void> getUserPost(String url) async {
    state = const AsyncLoading();
    try {
      final data = await _apiService.get(url);
      final posts = UserPostModel.fromJson(data);
      print(posts);
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
