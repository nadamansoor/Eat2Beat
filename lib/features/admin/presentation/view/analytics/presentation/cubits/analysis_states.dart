import 'package:eat2beat/features/admin/presentation/view/analytics/domain/entities/analytics_entity.dart';

abstract class AnalyticsState {}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsSuccess extends AnalyticsState {
  final AnalyticsEntity data;
  AnalyticsSuccess(this.data);
}

class AnalyticsError extends AnalyticsState {
  final String message;
  AnalyticsError(this.message);
}
