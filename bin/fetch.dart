import 'package:fetch/http_product.dart'; //http methods for Products
import 'package:fetch/product.dart'; //our data model class
import 'package:fetch/http_exception.dart'; //Exception for http fails

typedef ProductList = List<Product>; //everything in the List must be an instance of Product
typedef MappyStringyList = List<Map<String, String>>;
/*
var stuff = [{'hello': 'goodbye'}, {'hola': 'adios'}];
if(stuff is MappyStringyList){}
if(stuff is! ProductList){}
as - casting
is - type checking
*/
typedef stringyNums = Map<String, int>;

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
    //ProductList is the typedef List<Product>
    ProductList productList = await http.getProducts('/products');
    print(productList[2].toString());

    print(HttpProduct.productList[2].toString());
  } on HttpHelperException catch (ex) {
    print(ex.toString());
  }
}
