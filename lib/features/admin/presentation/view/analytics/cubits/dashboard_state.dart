import 'package:eat2beat/features/admin/presentation/view/analytics/entities/dashboard_entity.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardData data;
  final int selectedForecastIndex;
  final int days;

  DashboardLoaded({
    required this.data,
    this.selectedForecastIndex = 0,
    required this.days,
  });

  DashboardLoaded copyWith({
    DashboardData? data,
    int? selectedForecastIndex,
    int? days,
  }) {
    return DashboardLoaded(
      data: data ?? this.data,
      selectedForecastIndex: selectedForecastIndex ?? this.selectedForecastIndex,
      days: days ?? this.days,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}