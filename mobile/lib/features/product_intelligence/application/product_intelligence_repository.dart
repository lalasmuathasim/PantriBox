import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantribox_mobile/core/api/api_client.dart';
import 'package:pantribox_mobile/features/product_intelligence/application/product_lookup_models.dart';

final productIntelligenceRepositoryProvider =
    Provider<ProductIntelligenceRepository>((ref) {
      return ProductIntelligenceRepository(ref.watch(dioProvider));
    });

class ProductIntelligenceRepository {
  const ProductIntelligenceRepository(this._dio);

  final Dio _dio;

  Future<ProductLookupResult> lookupBarcode(String barcode) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/product-intelligence/barcode-lookups',
        data: {'barcode': barcode},
      );
      return ProductLookupResult.fromJson(response.data ?? <String, dynamic>{});
    } on DioException catch (error) {
      final response = error.response?.data;
      final message = response is Map<String, dynamic>
          ? ((response['error'] as Map<String, dynamic>?)?['message']
                as String?)
          : null;
      throw ProductLookupException(
        message ?? 'We could not look up that product right now.',
      );
    }
  }
}

class ProductLookupException implements Exception {
  const ProductLookupException(this.message);

  final String message;

  @override
  String toString() => message;
}
