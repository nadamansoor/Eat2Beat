
import 'package:eat2beat/features/admin/presentation/view/analytics/entities/dashboard_entity.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardData data;
  final int selectedForecastIndex;

  DashboardLoaded({
    required this.data,
    this.selectedForecastIndex = 0,
  });

  DashboardLoaded copyWith({
    DashboardData? data,
    int? selectedForecastIndex,
  }) {
    return DashboardLoaded(
      data: data ?? this.data,
      selectedForecastIndex: selectedForecastIndex ?? this.selectedForecastIndex,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}