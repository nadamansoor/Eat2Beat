import 'package:eat2beat/features/admin/presentation/view/analytics/cubits/dashboard_state.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/data/mockup_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      emit(DashboardLoaded(data: MockupData.sampleDashboard));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  void refresh() => loadDashboard();

  void selectForecastDay(int index) {
    final current = state;
    if (current is DashboardLoaded) {
      emit(current.copyWith(selectedForecastIndex: index));
    }
  }
}