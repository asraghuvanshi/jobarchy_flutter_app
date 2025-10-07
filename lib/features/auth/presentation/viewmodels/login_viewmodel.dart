import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jobarchy_flutter_app/core/network/network_exceptions.dart';
import 'package:jobarchy_flutter_app/core/utils/app_alerts.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/usecases/login_usecase.dart';


class LoginViewModel extends StateNotifier<AsyncValue<bool>> {
  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase) : super(const AsyncValue.data(false));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final entity = LoginEntity(email: email, password: password);
      final result = await _loginUseCase.execute(entity);
      state = AsyncValue.data(result);
      if (result) {
        AppAlerts.showSuccess("Login successful");
      }
    } on NetworkException catch (e) {
      AppAlerts.showError(e.message);
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      AppAlerts.showError("Unexpected error occurred");
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

