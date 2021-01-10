import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';

import 'package:http_interceptor/http_interceptor.dart';

// const String baseUrl = 'http://192.168.201.1:5000/';
const String baseUrl = 'http://192.168.43.228:5000/';
// const String baseUrl = 'http://10.0.2.1:5000/';
// const String baseUrl = 'http://api.storebow.scoutframe.com/api/v1.0/';
// const String imageBaseUrl = 'http://192.168.43.228:2000/';

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;

  var unescape = new HtmlUnescape();
  var text = unescape.convert(parsedString);
  return text;
}

class Connections {
  static String BASE_URL = baseUrl;
  static String USER = baseUrl + 'posts';
  // static String IMAGE_BASE_URL = imageBaseUrl;
  static String IMAGE_BASE_URL = 'http://api.storebow.scoutframe.com/media/';
  static String IMAGE_BASE_URL_WITHOUT_MEDIA =
      'http://api.storebow.scoutframe.com/';
  static String PRODUCTS = 'products/public/';
  static String PRODUCTS_MOST_SALED = 'products/public/?_l=7&_t=MOST_SALED';
  static String PRODUCTS_ON_SALE = 'products/public/?_l=7&_t=ON_SALE';
  static String PRODUCTS_RELATED = 'products/{id}/related/';
  static String PRODUCTS_BY_ID = 'products/{id}/public/';
  static String CATEGORIES = 'product/categories/public-all/';
  static String PRODUCTS_BY_CATEGORIES = 'product/categories/{id}/public/';
  static String LOGIN = 'auth/login/';
  static String REGISTRO = 'customers/public/';
  static String EDIT_BILLING = 'customer/billing_information/{id}/edit/';
  static String EDIT_SHIPPING = 'customer/shipping_information/{id}/edit/';
  static String EDIT_ACCES_INFORNATION = 'customers/{id}/login_data/';
  static String ORDER = 'orders/';
  static String ORDER_NEW = 'orders/public/?_o=NUEVOS/';
  static String ORDER_LAST = 'orders/lasts/';
  static String ORDER_BY_ID = 'orders/{id}/';
  static String ADDRESS = 'customer/addresses/all';
  static String EDIT_ADDRESS = 'customer/addresses/{id}/';
  static String ADD_ADDRESS = 'customer/addresses/';
  static String PAISES = 'core/countries/all/';
  static String PROVINCIAS = 'core/states/{id}/country/';
  static String CIUDADES = 'core/cities/{id}/state/';

  static Connections _instance;
  Dio dio;

  Connections._internal() {
    _instance = this;
    BaseOptions options = new BaseOptions(
      baseUrl: baseUrl,
      headers: _getHeaders(),
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );

    dio = new Dio(options);
    dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
  }

  factory Connections() => _instance ?? Connections._internal();

  Future get(url) async {
    Response response;
    try {
      response = await dio.get(
        url,
        options: buildCacheOptions(Duration(days: 7), forceRefresh: false),
      );
      // log('response: $response');
      return response;
    } on DioError catch (e) {}
  }

  Future post(url, data) async {
    Response response;
    try {
      response = await dio.post(
        url,
        data: data,
      );
      return response;
    } on DioError catch (e) {}
  }

  Map<String, String> _getHeaders() {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Tenant-ID': 'construyaalcosto',
      'charset': 'application/json'
    };
    return requestHeaders;
  }

  static String getUrlById(int id, String url) {
    return url.replaceAll('{id}', id.toString());
  }
}

class Interceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    try {
      data.headers['Tenant-ID'] = 'construyaalcosto';
      data.headers['charset'] = 'application/json';
      data.headers['Content-Type'] = 'application/json';
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) {
    // TODO: implement interceptResponse
    throw UnimplementedError();
  }
}
