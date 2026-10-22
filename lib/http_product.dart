import 'dart:convert'; // for JSON conversion

import 'package:http/http.dart' as http; // for the HTTP methods from pub.dev
import 'package:fetch/http_exception.dart'; //our custom exceptions for http
import 'package:fetch/product.dart'; //our data model class

typedef ProductList = List<Product>;

//Class with all the Http Methods for Products
class HttpProduct {
  late Uri uri;
  static ProductList productList = [];
  // static List<Product> productList = [];

  HttpProduct(String hostname) {
    // or use the Uri.parse method
    // HttpProduct(String url) {
    // uri = Uri.tryParse(url); //check for exceptions
    //or you can build a URI from the parts
    // uri = Uri(host: hostname, scheme: 'https', port: 443, path: '/');
    //set a default base url so we just have to update the path
    uri = Uri.https(hostname, '/', {});
  }

  Future<Product> getProduct(String path) async {
    //Http Get a single product
    uri = Uri(host: uri.host, scheme: uri.scheme, port: uri.port, path: path);
    //we can set headers for the request like this
    Map<String, String>? headers = {'X-Important': 'you betcha'};
    final http.Response response;
    try {
      response = await http.get(uri, headers: headers); //our fetch() call
    } on http.ClientException catch (ex) {
      throw HttpHelperException('Request to ${ex.uri.toString()} failed.', null);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpHelperException(
        'Request failed with HTTP status ${response.statusCode}.',
        response.statusCode,
      );
    }
    //convert response body to Map<String, dynamic>
    Map decoded = jsonDecode(response.body) as Map;
    try {
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object.');
      }
    } catch (e) {
      print(e.toString());
    }
    //convert Map to a Product instance
    return Product.fromJson(decoded as Map<String, dynamic>);
    // Product.fromJson() was expecting a Map<String, dynamic> so we add "as"
  }

  //Future<List<Product>>.  Future<List<Map<String, dynamic>>>
  Future<ProductList> getProducts(String path) async {
    //Http Get a list of products
    uri = Uri(host: uri.host, scheme: uri.scheme, port: uri.port, path: path);
    //we can set headers for the request like this
    Map<String, String>? headers = {};
    final http.Response response;
    try {
      response = await http.get(uri, headers: headers);
    } on http.ClientException catch (error) {
      throw HttpHelperException('Request failed: $error', null);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpHelperException(
        'Request failed with HTTP status ${response.statusCode}.',
        response.statusCode,
      );
    }
    //convert from JSON string
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object.');
      }

      final products = decoded['products'];
      if (products is! List) {
        throw const FormatException('Expected "products" to be a JSON array.');
      }

      HttpProduct.productList = products.map<Product>((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Expected each product to be a JSON object.');
        }
        return Product.fromJson(item);
      }).toList();
      //List.map() returns an Iterable... which must be converted to a List
      return HttpProduct.productList;
    } on FormatException catch (error) {
      throw HttpHelperException('Invalid products response: ${error.message}', response.statusCode);
    } on TypeError catch (error) {
      throw HttpHelperException('Invalid product data: $error', response.statusCode);
    }
  }
}
