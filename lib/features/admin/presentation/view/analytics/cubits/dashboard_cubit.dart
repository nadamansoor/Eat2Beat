import 'package:eat2beat/core/services/api_service.dart';
import 'package:eat2beat/features/admin/domain/usecases/get_demand_dashboard_usecase.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/cubits/dashboard_state.dart';
import 'package:eat2beat/features/auth/domain/repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final AuthRepo authRepo;
  final GetDemandDashboardUseCase getDemandDashboardUseCase;
  final ApiService apiService;
  String? _lastRestaurantId;
  int _lastDays = 7;

  DashboardCubit({
    required this.authRepo,
    required this.getDemandDashboardUseCase,
    required this.apiService,
  }) : super(DashboardInitial());

  Future<void> loadDashboard({String? restaurantId, int days = 7}) async {
    _lastRestaurantId = restaurantId;
    _lastDays = days;
    emit(DashboardLoading());
    try {
      final token = await authRepo.getIdToken();
      if (token == null) {
        emit(DashboardError('Authentication failed. Please sign in again.'));
        return;
      }

      String targetId = restaurantId ?? '';
      if (targetId.isEmpty) {
        try {
          targetId = await apiService.getRestaurantId(token);
        } catch (_) {
          targetId = FirebaseAuth.instance.currentUser?.uid ?? '';
          if (targetId.isEmpty) {
            emit(DashboardError('Failed to resolve restaurant ID.'));
            return;
          }
        }
      }
      _lastRestaurantId = targetId;

      final result = await getDemandDashboardUseCase(
        token: token,
        restaurantId: targetId,
        days: days,
      );

      result.fold(
        (failure) => emit(DashboardError(failure.message)),
        (data) => emit(DashboardLoaded(data: data, days: days)),
      );
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  void refresh() {
    if (_lastRestaurantId != null) {
      loadDashboard(restaurantId: _lastRestaurantId!, days: _lastDays);
    }
  }


  void selectForecastDay(int index) {
    final current = state;
    if (current is DashboardLoaded) {
      emit(current.copyWith(selectedForecastIndex: index));
    }
  }
}