import 'package:eat2beat/features/admin/presentation/view/analytics/presentation/cubits/analysis_states.dart';
import 'package:eat2beat/features/admin/presentation/view/analytics/presentation/cubits/moclab_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(AnalyticsInitial());

  /// Call this to load analytics for a restaurant
  Future<void> loadAnalytics(String restaurantId) async {
    emit(AnalyticsLoading());
    try {
      // TODO: replace with real repository call
      // final data = await _repo.getAnalytics(restaurantId);
      // emit(AnalyticsSuccess(data));

      // ── Mock data for now ──
      await Future.delayed(const Duration(milliseconds: 800));
      emit(AnalyticsSuccess(mockData(restaurantId)));
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }
  void retry(String restaurantId) => loadAnalytics(restaurantId);
}