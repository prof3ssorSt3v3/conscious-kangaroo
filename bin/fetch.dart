import 'package:fetch/http_product.dart';
import 'package:fetch/product.dart';
import 'package:fetch/http_exception.dart';

typedef ProductList = List<Product>;
void main(List<String> arguments) async {
  String host = 'dummyjson.com';
  HttpProduct http = HttpProduct(host);

  try {
    Product product = await http.getProduct('/products/2');
    print(product.toString());
  } on HttpHelperException catch (ex) {
    print(ex.toString());
  }

  try {
    ProductList productList = await http.getProducts('/products');
    print(productList[2].toString());

    print(HttpProduct.productList[2].toString());
  } on HttpHelperException catch (ex) {
    print(ex.toString());
  }
}
