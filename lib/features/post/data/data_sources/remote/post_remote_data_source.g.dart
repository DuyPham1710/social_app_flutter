// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_remote_data_source.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter

class _PostRemoteDataSource implements PostRemoteDataSource {
  _PostRemoteDataSource(this._dio, {this.baseUrl}) {
    baseUrl ??= 'http://192.168.68.101:3000/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<PostListModel> getHomePosts(int page, int limit) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': page, r'limit': limit};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<PostListModel>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/post/home',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PostListModel _value;
    try {
      _value = PostListModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataState<PostListModel>> getProfilePosts({
    required String ownerId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/post/user/$ownerId',
        queryParameters: {'page': page, 'limit': limit},
      );

      final data = PostListModel.fromJson(response.data);
      return DataStateSuccess(data);
    } on DioException catch (e) {
      return DataStateError(e);
    }
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
