import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_version_info.freezed.dart';
part 'api_version_info.g.dart';

@freezed
abstract class ApiVersionInfo with _$ApiVersionInfo {
  const factory ApiVersionInfo({
    @Default('PantriBox API') String name,
    @Default('offline') String version,
    @JsonKey(name: 'api_prefix') @Default('/api/v1') String apiPrefix,
    @JsonKey(name: 'mcp_capabilities')
    @Default(<McpCapabilityInfo>[])
    List<McpCapabilityInfo> mcpCapabilities,
  }) = _ApiVersionInfo;

  const ApiVersionInfo._();

  factory ApiVersionInfo.fromJson(Map<String, dynamic> json) =>
      _$ApiVersionInfoFromJson(json);

  factory ApiVersionInfo.fallback() => const ApiVersionInfo();
}

@freezed
abstract class McpCapabilityInfo with _$McpCapabilityInfo {
  const factory McpCapabilityInfo({
    required String name,
    required String description,
  }) = _McpCapabilityInfo;

  factory McpCapabilityInfo.fromJson(Map<String, dynamic> json) =>
      _$McpCapabilityInfoFromJson(json);
}
