
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jobarchy_flutter_app/core/network/api_client.dart';
import 'package:jobarchy_flutter_app/features/auth/data/repositories/login_repository_impl.dart';
import 'package:jobarchy_flutter_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:jobarchy_flutter_app/features/auth/presentation/viewmodels/login_viewmodel.dart';


// Api Client
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// Repository
final loginRepositoryProvider = Provider(
  (ref) => LoginRepositoryImpl(ref.read(apiClientProvider)),
);

// UseCase
final loginUseCaseProvider = Provider(
  (ref) => LoginUseCase(ref.read(loginRepositoryProvider)),
);

// ViewModel
final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, AsyncValue<bool>>(
  (ref) => LoginViewModel(ref.read(loginUseCaseProvider)),
);
