import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

//获取首页主题内容
Future getHomePageContent() async {
  try {
    print('开始获取首页数据');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    var formData = {'lon': '115.029.32', 'lat': '35.761.89'};
    response = await dio.post(servicePath['homePageContent'], data: formData);
    if (response.statusCode == 200) {
      print(response);
      return response;
    } else {
      throw Exception('后端接口异常');
    }
  } catch (e) {
    return print('error=============>${e}');
  }
}

Future getList() async {
  try {
    print('开始获取首页数据');
    Response response;
    Dio dio = new Dio();
    print(servicePath['banner']);
    response = await dio.get(servicePath['banner']);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('后端接口异常');
    }
  } catch (e) {
    return print('error=============>${e}');
  }
}
