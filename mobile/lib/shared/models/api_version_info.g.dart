// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_version_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiVersionInfo _$ApiVersionInfoFromJson(Map<String, dynamic> json) =>
    _ApiVersionInfo(
      name: json['name'] as String? ?? 'PantriBox API',
      version: json['version'] as String? ?? 'offline',
      apiPrefix: json['api_prefix'] as String? ?? '/api/v1',
      mcpCapabilities:
          (json['mcp_capabilities'] as List<dynamic>?)
              ?.map(
                (e) => McpCapabilityInfo.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <McpCapabilityInfo>[],
    );

Map<String, dynamic> _$ApiVersionInfoToJson(_ApiVersionInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'version': instance.version,
      'api_prefix': instance.apiPrefix,
      'mcp_capabilities': instance.mcpCapabilities,
    };

_McpCapabilityInfo _$McpCapabilityInfoFromJson(Map<String, dynamic> json) =>
    _McpCapabilityInfo(
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$McpCapabilityInfoToJson(_McpCapabilityInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
