import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:office_attendence/helpers/common_helper.dart';
import 'package:office_attendence/helpers/responsive.dart';
import '../../data/network/base_api_services.dart';
import 'package:http/http.dart' as http;

import '../app_exceptions.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url, requestName) async {
    if (kDebugMode) {
      debugPrint(url);
    }
    var headers = {'Authorization': 'Bearer $token'};

    url = "http://xghrm.org/api/" + url;
    debugPrint(url.toString());
    debugPrint(token.toString());
    dynamic responseJson;
    final dynamic response;
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      InternetException('');
      debugPrint("invalid url");
      showError(requestName, "Invalid Url");
    } on RequestTimeOut {
      debugPrint("request timeout");
      showError(requestName, "Request Timeout");
      RequestTimeOut('');
    } catch (e) {
      debugPrint(e.toString());
      showError(requestName, e.toString());
    }
    debugPrint(responseJson.toString());
    return responseJson;
  }

  @override
  Future<dynamic> postApi(var data, String url, requestName) async {
    if (kDebugMode) {
      debugPrint(url);
      debugPrint(data.toString());
    }
    url = "http://xghrm.org/api/" + url;
    debugPrint(url.toString());
    var headers = {'Authorization': 'Bearer $token'};

    dynamic responseJson;
    dynamic response;
    try {
      final response = await http
          .post(Uri.parse(url), body: data, headers: headers)
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
    } on SocketException {
      debugPrint("invalid url");
      showError(requestName, "Invalid Url");
    } on RequestTimeOut {
      debugPrint("request timeout");
      showError(requestName, "Request Timeout");
    } catch (e) {
      debugPrint(e.toString());
      try {
        if (e is Map && e['validation_errors'] != null) {
          showToast(
              e['validation_errors']
                  .values
                  .toList()
                  .first
                  .first
                  .toString()
                  .capitalize(),
              color: Colors.black);
        } else if (e is Map && e['message'] != null) {
          showToast(e['message'].toString(), color: Colors.black);
        } else if (e is Map && e['type'] == 'danger' && e['msg'] is Map) {
          showToast(
              e['msg'].values.toList().first.first.toString().capitalize(),
              color: Colors.black);
        } else if (e is Map && e['type'] == 'danger') {
          showToast(e['msg'].toString().capitalize(), color: Colors.black);
        } else {
          showToast(e.toString(), color: Colors.black);
        }
      } catch (e) {
        showError(requestName, e.toString());
      }
    }
    if (kDebugMode) {
      debugPrint(responseJson.toString());
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 422:
        dynamic responseJson = jsonDecode(response.body);
        throw responseJson;

      default:
        throw FetchDataException(
            'Error accoured while communicating with server ${response.statusCode}');
    }
  }

  showError(requestName, error) {
    if (requestName != null) {
      showToast("$requestName: $error", color: Colors.black);
    }
  }
}
