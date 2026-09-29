import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/core/api/api_client.dart';
import 'package:pantribox_mobile/features/household_nutrition/application/household_nutrition_models.dart';

final householdNutritionRepositoryProvider =
    Provider<HouseholdNutritionRepository>((ref) {
      return HouseholdNutritionRepository(ref.watch(dioProvider));
    });

class HouseholdNutritionRepository {
  const HouseholdNutritionRepository(this._dio);

  final Dio _dio;

  Future<HouseholdNutritionInsight> fetchInsight({
    required String householdId,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/households/$householdId/nutrition-insights',
      queryParameters: {
        'period_start': _dateOnly(periodStart),
        'period_end': _dateOnly(periodEnd),
      },
    );
    return HouseholdNutritionInsight.fromJson(response.data ?? const {});
  }

  Future<List<HouseholdMember>> fetchMembers(String householdId) async {
    final response = await _dio.get<List<dynamic>>(
      '/households/$householdId/members',
    );
    return (response.data ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(HouseholdMember.fromJson)
        .toList(growable: false);
  }

  Future<HouseholdMember> createMember({
    required String householdId,
    required String displayName,
    DateTime? dateOfBirth,
    String? sex,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/households/$householdId/members',
      data: {
        'display_name': displayName,
        'date_of_birth': dateOfBirth == null ? null : _dateOnly(dateOfBirth),
        'sex': sex,
      },
    );
    return HouseholdMember.fromJson(response.data ?? const {});
  }

  Future<HouseholdMember> updateMember({
    required String householdId,
    required HouseholdMember member,
    required String displayName,
    DateTime? dateOfBirth,
    String? sex,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/households/$householdId/members/${member.id}',
      data: {
        'display_name': displayName,
        'date_of_birth': dateOfBirth == null ? null : _dateOnly(dateOfBirth),
        'sex': sex,
        'is_active': member.isActive,
      },
    );
    return HouseholdMember.fromJson(response.data ?? const {});
  }

  Future<void> deactivateMember({
    required String householdId,
    required String memberId,
  }) async {
    await _dio.delete<void>('/households/$householdId/members/$memberId');
  }
}

String _dateOnly(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
