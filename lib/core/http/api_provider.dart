import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:education_systems_mobile/core/config/app_settings.dart';

const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

class ApiProvider {
  ApiProvider({@required String this.baseUrl, this.interceptors});

  final String baseUrl;
  final Iterable<Interceptor> interceptors;

  Dio _dio;
  DioCacheManager _cacheManager;

  void _init() {
    _dio = new Dio();
    _dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout
      ..httpClientAdapter
      ..options.headers = {'Content-Type': 'application/json; charset=UTF-8'};
    if (interceptors?.isNotEmpty ?? false) {
      _dio.interceptors.addAll(interceptors);
    }
    _dio.interceptors.add(_getCacheManager().interceptor);

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
          responseBody: true, error: true, requestHeader: false, responseHeader: false, request: false, requestBody: false));
    }
  }

  Future<dynamic> get(
      String uri, {
        Map<String, dynamic> queryParameters,
        Options options,
        CancelToken cancelToken,
        ProgressCallback onReceiveProgress,
        bool isCached = false,
        Duration cacheDuration,
      }) async {
    try {
      Options internalOptions = options;

      /****** Caching ******/
      if (isCached) {
        internalOptions = buildCacheOptions(cacheDuration, options: options);
      }
      /****** Caching ******/
      var response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: internalOptions,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> post(
      String uri, {
        data,
        Map<String, dynamic> queryParameters,
        Options options,
        CancelToken cancelToken,
        ProgressCallback onSendProgress,
        ProgressCallback onReceiveProgress,
        bool isCached = false,
        Duration cacheDuration,
      }) async {
    try {
      Options internalOptions = options;

      /****** Caching ******/
      if (isCached) {
        if (cacheDuration == null) cacheDuration = Duration(days: 1);
        internalOptions = buildCacheOptions((cacheDuration), options: options);
      }
      /****** Caching ******/

      var response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: internalOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> patch(
      String uri, {
        data,
        Map<String, dynamic> queryParameters,
        Options options,
        CancelToken cancelToken,
        ProgressCallback onSendProgress,
        ProgressCallback onReceiveProgress,
      }) async {
    try {
      var response = await _dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> delete(
      String uri, {
        data,
        Map<String, dynamic> queryParameters,
        Options options,
        CancelToken cancelToken,
      }) async {
    try {
      var response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  DioCacheManager _getCacheManager() {
    var cacheManager = new DioCacheManager(CacheConfig(defaultMaxAge: Duration(hours: 1)));
    return cacheManager;
  }
/*
*     (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
*
* */

  static Future<ApiProvider> create({Iterable<Interceptor> interceptors}) async {
    AppSettings appSettings = await AppSettings.get();
    String _baseUrl = appSettings.baseUrl;

    var apiProvider = new ApiProvider(interceptors: interceptors, baseUrl: _baseUrl);
    apiProvider._init();
    return apiProvider;
  }
}