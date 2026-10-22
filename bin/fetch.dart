import 'package:fetch/http_product.dart';
import 'package:fetch/product.dart';

void main(List<String> arguments) async {
  String host = 'dummyjson.com';
  HttpProduct http = HttpProduct(host);

  Product product = await http.getProduct('/products/2');
  print(product.toString());

  List<Product> productList = await http.getProducts('/products');
  print(productList[2].toString());

  print(HttpProduct.productList[2].toString());
}
