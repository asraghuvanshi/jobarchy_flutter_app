import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jobarchy_flutter_app/core/network/api_service.dart';
import 'package:jobarchy_flutter_app/core/network/network_exceptions.dart';
import 'package:jobarchy_flutter_app/core/utils/app_constant.dart';
import 'package:jobarchy_flutter_app/features/model/postmodel/create_post_model.dart';

final createPostViewModelProvider =
    StateNotifierProvider<CreatePostViewModel, AsyncValue<CreatePostResponse?>>(
  (ref) => CreatePostViewModel(ref),
);

class CreatePostViewModel
    extends StateNotifier<AsyncValue<CreatePostResponse?>> {
  final ApiService _api = ApiService();

  CreatePostViewModel(Ref ref) : super(const AsyncData(null));

  Future<void> create({
    required String title,
    required String description,
    required String country,
    required List<File> images,
  }) async {
    state = const AsyncLoading();

    try {
      final data = await _api.postMultipart(
        url: APIEndPoint.createPost,
        fields: {
          'title': title,
          'description': description,
          'country': country,
        },
        files: images,
        filesFieldName: 'image',
      );

      final response = CreatePostResponse.fromJson(data);
      state = AsyncData(response);
    } on NoInternetException {
      state = AsyncError('No Internet Connection', StackTrace.current);
    } on NetworkException catch (e) {
      state = AsyncError(e.message, StackTrace.current);
    } catch (e, stack) {
      state = AsyncError('Unexpected error: $e', stack);
    }
  }

  void reset() => state = const AsyncData(null);
}