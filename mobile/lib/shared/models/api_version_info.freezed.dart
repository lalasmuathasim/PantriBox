// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_version_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiVersionInfo {

 String get name; String get version;@JsonKey(name: 'api_prefix') String get apiPrefix;@JsonKey(name: 'mcp_capabilities') List<McpCapabilityInfo> get mcpCapabilities;
/// Create a copy of ApiVersionInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiVersionInfoCopyWith<ApiVersionInfo> get copyWith => _$ApiVersionInfoCopyWithImpl<ApiVersionInfo>(this as ApiVersionInfo, _$identity);

  /// Serializes this ApiVersionInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiVersionInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&(identical(other.apiPrefix, apiPrefix) || other.apiPrefix == apiPrefix)&&const DeepCollectionEquality().equals(other.mcpCapabilities, mcpCapabilities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,version,apiPrefix,const DeepCollectionEquality().hash(mcpCapabilities));

@override
String toString() {
  return 'ApiVersionInfo(name: $name, version: $version, apiPrefix: $apiPrefix, mcpCapabilities: $mcpCapabilities)';
}


}

/// @nodoc
abstract mixin class $ApiVersionInfoCopyWith<$Res>  {
  factory $ApiVersionInfoCopyWith(ApiVersionInfo value, $Res Function(ApiVersionInfo) _then) = _$ApiVersionInfoCopyWithImpl;
@useResult
$Res call({
 String name, String version,@JsonKey(name: 'api_prefix') String apiPrefix,@JsonKey(name: 'mcp_capabilities') List<McpCapabilityInfo> mcpCapabilities
});




}
/// @nodoc
class _$ApiVersionInfoCopyWithImpl<$Res>
    implements $ApiVersionInfoCopyWith<$Res> {
  _$ApiVersionInfoCopyWithImpl(this._self, this._then);

  final ApiVersionInfo _self;
  final $Res Function(ApiVersionInfo) _then;

/// Create a copy of ApiVersionInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? version = null,Object? apiPrefix = null,Object? mcpCapabilities = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,apiPrefix: null == apiPrefix ? _self.apiPrefix : apiPrefix // ignore: cast_nullable_to_non_nullable
as String,mcpCapabilities: null == mcpCapabilities ? _self.mcpCapabilities : mcpCapabilities // ignore: cast_nullable_to_non_nullable
as List<McpCapabilityInfo>,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiVersionInfo].
extension ApiVersionInfoPatterns on ApiVersionInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiVersionInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiVersionInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiVersionInfo value)  $default,){
final _that = this;
switch (_that) {
case _ApiVersionInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiVersionInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ApiVersionInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String version, @JsonKey(name: 'api_prefix')  String apiPrefix, @JsonKey(name: 'mcp_capabilities')  List<McpCapabilityInfo> mcpCapabilities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiVersionInfo() when $default != null:
return $default(_that.name,_that.version,_that.apiPrefix,_that.mcpCapabilities);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String version, @JsonKey(name: 'api_prefix')  String apiPrefix, @JsonKey(name: 'mcp_capabilities')  List<McpCapabilityInfo> mcpCapabilities)  $default,) {final _that = this;
switch (_that) {
case _ApiVersionInfo():
return $default(_that.name,_that.version,_that.apiPrefix,_that.mcpCapabilities);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String version, @JsonKey(name: 'api_prefix')  String apiPrefix, @JsonKey(name: 'mcp_capabilities')  List<McpCapabilityInfo> mcpCapabilities)?  $default,) {final _that = this;
switch (_that) {
case _ApiVersionInfo() when $default != null:
return $default(_that.name,_that.version,_that.apiPrefix,_that.mcpCapabilities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiVersionInfo extends ApiVersionInfo {
  const _ApiVersionInfo({this.name = 'PantriBox API', this.version = 'offline', @JsonKey(name: 'api_prefix') this.apiPrefix = '/api/v1', @JsonKey(name: 'mcp_capabilities') final  List<McpCapabilityInfo> mcpCapabilities = const <McpCapabilityInfo>[]}): _mcpCapabilities = mcpCapabilities,super._();
  factory _ApiVersionInfo.fromJson(Map<String, dynamic> json) => _$ApiVersionInfoFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  String version;
@override@JsonKey(name: 'api_prefix') final  String apiPrefix;
 final  List<McpCapabilityInfo> _mcpCapabilities;
@override@JsonKey(name: 'mcp_capabilities') List<McpCapabilityInfo> get mcpCapabilities {
  if (_mcpCapabilities is EqualUnmodifiableListView) return _mcpCapabilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mcpCapabilities);
}


/// Create a copy of ApiVersionInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiVersionInfoCopyWith<_ApiVersionInfo> get copyWith => __$ApiVersionInfoCopyWithImpl<_ApiVersionInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiVersionInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiVersionInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version)&&(identical(other.apiPrefix, apiPrefix) || other.apiPrefix == apiPrefix)&&const DeepCollectionEquality().equals(other._mcpCapabilities, _mcpCapabilities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,version,apiPrefix,const DeepCollectionEquality().hash(_mcpCapabilities));

@override
String toString() {
  return 'ApiVersionInfo(name: $name, version: $version, apiPrefix: $apiPrefix, mcpCapabilities: $mcpCapabilities)';
}


}

/// @nodoc
abstract mixin class _$ApiVersionInfoCopyWith<$Res> implements $ApiVersionInfoCopyWith<$Res> {
  factory _$ApiVersionInfoCopyWith(_ApiVersionInfo value, $Res Function(_ApiVersionInfo) _then) = __$ApiVersionInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, String version,@JsonKey(name: 'api_prefix') String apiPrefix,@JsonKey(name: 'mcp_capabilities') List<McpCapabilityInfo> mcpCapabilities
});




}
/// @nodoc
class __$ApiVersionInfoCopyWithImpl<$Res>
    implements _$ApiVersionInfoCopyWith<$Res> {
  __$ApiVersionInfoCopyWithImpl(this._self, this._then);

  final _ApiVersionInfo _self;
  final $Res Function(_ApiVersionInfo) _then;

/// Create a copy of ApiVersionInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? version = null,Object? apiPrefix = null,Object? mcpCapabilities = null,}) {
  return _then(_ApiVersionInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,apiPrefix: null == apiPrefix ? _self.apiPrefix : apiPrefix // ignore: cast_nullable_to_non_nullable
as String,mcpCapabilities: null == mcpCapabilities ? _self._mcpCapabilities : mcpCapabilities // ignore: cast_nullable_to_non_nullable
as List<McpCapabilityInfo>,
  ));
}


}


/// @nodoc
mixin _$McpCapabilityInfo {

 String get name; String get description;
/// Create a copy of McpCapabilityInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$McpCapabilityInfoCopyWith<McpCapabilityInfo> get copyWith => _$McpCapabilityInfoCopyWithImpl<McpCapabilityInfo>(this as McpCapabilityInfo, _$identity);

  /// Serializes this McpCapabilityInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is McpCapabilityInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description);

@override
String toString() {
  return 'McpCapabilityInfo(name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class $McpCapabilityInfoCopyWith<$Res>  {
  factory $McpCapabilityInfoCopyWith(McpCapabilityInfo value, $Res Function(McpCapabilityInfo) _then) = _$McpCapabilityInfoCopyWithImpl;
@useResult
$Res call({
 String name, String description
});




}
/// @nodoc
class _$McpCapabilityInfoCopyWithImpl<$Res>
    implements $McpCapabilityInfoCopyWith<$Res> {
  _$McpCapabilityInfoCopyWithImpl(this._self, this._then);

  final McpCapabilityInfo _self;
  final $Res Function(McpCapabilityInfo) _then;

/// Create a copy of McpCapabilityInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [McpCapabilityInfo].
extension McpCapabilityInfoPatterns on McpCapabilityInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _McpCapabilityInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _McpCapabilityInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _McpCapabilityInfo value)  $default,){
final _that = this;
switch (_that) {
case _McpCapabilityInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _McpCapabilityInfo value)?  $default,){
final _that = this;
switch (_that) {
case _McpCapabilityInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _McpCapabilityInfo() when $default != null:
return $default(_that.name,_that.description);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description)  $default,) {final _that = this;
switch (_that) {
case _McpCapabilityInfo():
return $default(_that.name,_that.description);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description)?  $default,) {final _that = this;
switch (_that) {
case _McpCapabilityInfo() when $default != null:
return $default(_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _McpCapabilityInfo implements McpCapabilityInfo {
  const _McpCapabilityInfo({required this.name, required this.description});
  factory _McpCapabilityInfo.fromJson(Map<String, dynamic> json) => _$McpCapabilityInfoFromJson(json);

@override final  String name;
@override final  String description;

/// Create a copy of McpCapabilityInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$McpCapabilityInfoCopyWith<_McpCapabilityInfo> get copyWith => __$McpCapabilityInfoCopyWithImpl<_McpCapabilityInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$McpCapabilityInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _McpCapabilityInfo&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description);

@override
String toString() {
  return 'McpCapabilityInfo(name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$McpCapabilityInfoCopyWith<$Res> implements $McpCapabilityInfoCopyWith<$Res> {
  factory _$McpCapabilityInfoCopyWith(_McpCapabilityInfo value, $Res Function(_McpCapabilityInfo) _then) = __$McpCapabilityInfoCopyWithImpl;
@override @useResult
$Res call({
 String name, String description
});




}
/// @nodoc
class __$McpCapabilityInfoCopyWithImpl<$Res>
    implements _$McpCapabilityInfoCopyWith<$Res> {
  __$McpCapabilityInfoCopyWithImpl(this._self, this._then);

  final _McpCapabilityInfo _self;
  final $Res Function(_McpCapabilityInfo) _then;

/// Create a copy of McpCapabilityInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,}) {
  return _then(_McpCapabilityInfo(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
