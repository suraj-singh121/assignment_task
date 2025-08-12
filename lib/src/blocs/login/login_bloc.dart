import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../../utils/validators.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(): super(const LoginState()) {
    on<LoginEmailChanged>((event, emit) {
      final isValid = Validators.isValidEmail(event.email);
      emit(state.copyWith(email: event.email, isEmailValid: isValid));
    });

    on<LoginPasswordChanged>((event, emit) {
      final isValid = Validators.isValidPassword(event.password);
      emit(state.copyWith(password: event.password, isPasswordValid: isValid));
    });

    on<LoginSubmitted>((event, emit) async {
      final isEmailValid = Validators.isValidEmail(event.email);
      final isPasswordValid = Validators.isValidPassword(event.password);

      if (!isEmailValid || !isPasswordValid) {
        emit(state.copyWith(isEmailValid: isEmailValid, isPasswordValid: isPasswordValid, isSubmitting: false));
        return;
      }

      emit(state.copyWith(isSubmitting: true, error: null));

      // For this assignment, "login" is just a validation pass. If you had an API, you'd call it here.
      await Future.delayed(const Duration(milliseconds: 500));

      // on success
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    });
  }
}
