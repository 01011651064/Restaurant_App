import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:resto/main.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIStatus {
  int statusCode;
  String message;

  APIStatus({required this.statusCode, required this.message});
}

Future<APIStatus> sendProductPics(XFile imageFile, String name) async {
  var request =
      http.MultipartRequest("POST", Uri.parse('$serverUrl/admin/sendItemPics'));

//---------------------

  var stream1 = http.ByteStream(imageFile.openRead());
  stream1.cast();
  var length1 = await imageFile.length();
  var multipartFile1 =
      http.MultipartFile('file', stream1, length1, filename: basename(name));
  request.files.add(multipartFile1);
//---------------------
  var response = await request.send();
  String message = '';

  response.stream.transform(utf8.decoder).listen((value) {
    message = value;
  });
  return APIStatus(statusCode: response.statusCode, message: message);
}

Future<List<FoodCardData>> searchItem(String searchTerm) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';

  final response = await http.post(
    Uri.parse('$serverUrl/admin/searchItem'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },
    body: jsonEncode(<String, String>{
      'searchterm': searchTerm,
    }),
  );

  if (response.statusCode == 200) {
    return FoodCardData.toList(jsonDecode(response.body), Map());
  } else {
    throw Exception('faild to fetch food card data');
  }
}

Future<List<FoodCardData>> fetchFoodCardData(
    double rating, double maxPrice, double minPrice, int timeThreshold) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';

  final response =
      await http.post(Uri.parse('$serverUrl/admin/getItemsWithFilter'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'token': token,
          },
          body: jsonEncode(<String, String>{
            'ratingThreshold': rating.toString(),
            'TimesThreshold': timeThreshold.toString(),
            'maxPrice': maxPrice.toString(),
            'minPrice': minPrice.toString()
          }));
  if (response.statusCode == 200) {
    return FoodCardData.toList(jsonDecode(response.body), response.headers);
  } else {
    throw Exception('faild to fetch food card data');
  }
}

// Future<List<CategoryData>> fetchItemCategory(int itemId) async {
//   final response = await http.get(
//     Uri.parse('$url/menuitems/getItemCategories/$itemId'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );

//   if (response.statusCode == 200) {
//     return CategoryData.toList(jsonDecode(response.body));
//   } else {
//     throw Exception('faild to fetch food card data');
//   }
// }

Future<APIStatus> sendFoodCardData(FoodCardData dataObj) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';
  final response = await http.post(
    Uri.parse('$serverUrl/admin/addItem'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },
    body: jsonEncode(<String, String>{
      'name': dataObj.name,
      'stock': dataObj.stock.toString(),
      'description': dataObj.description.toString(),
      'rating': dataObj.rating.toString(),
      'price': dataObj.price.toString(),
      'timesOrdered': dataObj.timesOrdered.toString(),
      'firstImage': dataObj.firstImage,
      'secondImage': dataObj.secondImage,
      'categories': jsonEncode(dataObj.catagories),
    }),
  );

  return APIStatus(
      statusCode: response.statusCode,
      message: jsonDecode(response.body)['message']);
  // if (response.statusCode == 200) {

  //   func('pop');
  // } else if (response.statusCode == 500) {
  //   func("Duplicate Entry In 'name' Column.\nTry another name!");
  // } else {
  //   throw Exception('faild to send food card data');
  // }
}

Future<APIStatus> updateFoodCardData(FoodCardData dataObj) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';
  final response = await http.put(
    Uri.parse('$serverUrl/admin/updateItem/${dataObj.itemId.toString()}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },
    body: jsonEncode(<String, String>{
      'name': dataObj.name,
      'stock': dataObj.stock.toString(),
      'description': dataObj.description.toString(),
      'rating': dataObj.rating.toString(),
      'price': dataObj.price.toString(),
      'firstImage': dataObj.firstImage,
      'secondImage': dataObj.secondImage,
      'categories': jsonEncode(dataObj.catagories),
    }),
  );
  return APIStatus(
      statusCode: response.statusCode,
      message: jsonDecode(response.body)['message']);
}

Future<APIStatus> deleteFoodCardData(FoodCardData dataObj) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';
  final response = await http.delete(
    Uri.parse('$serverUrl/admin/deleteItem/${dataObj.itemId.toString()}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },
  );

  return APIStatus(
      statusCode: response.statusCode,
      message: jsonDecode(response.body)['message']);
}

class FoodCardData {
  static double maxPrice = 1000;
  static double maxTimesOrdered = 100;
  final int itemId;
  final String name;
  final int stock;
  final String description;
  final double rating;
  final double price;
  final int timesOrdered;
  final String firstImage;
  final String secondImage;
  List<CategoryData>? catagories;

  FoodCardData({
    required this.itemId,
    required this.name,
    required this.description,
    required this.rating,
    required this.price,
    required this.timesOrdered,
    required this.stock,
    required this.firstImage,
    required this.secondImage,
    this.catagories,
  });

  static List<FoodCardData> toList(
      List<dynamic> data, Map<String, String> headers) {
    if (headers.keys.contains('maxprice') ||
        headers.keys.contains('maxtimesordered')) {
      // if (headers['maxprice'].toString() != 'NaN') {
      //   maxPrice =
      //       double.parse(headers['maxprice'].toString()).ceil().toDouble();
      // }
      if (headers['maxtimesordered'].toString() != 'NaN') {
        maxTimesOrdered =
            double.tryParse(headers['maxtimesordered'].toString()) ?? 0;
      }
    }

    List<FoodCardData> card = [];
    for (int i = 0; i < data.length; i++) {
      try {
        card.add(FoodCardData(
          itemId: data[i]['itemId'],
          name: data[i]['name'],
          description: data[i]['description'],
          rating: data[i]['rating'] + .0,
          price: data[i]['price'] + .0,
          timesOrdered: data[i]['timesOrdered'],
          stock: data[i]['stock'],
          firstImage: data[i]['firstImage'],
          secondImage: data[i]['secondImage'],
          catagories: CategoryData.toList(data[i]['categories']),
        ));
      } catch (err) {
        print(err);
      }
    }
    return card;
  }

  static FoodCardData emptyObj() {
    return FoodCardData(
      itemId: 0,
      name: "",
      description: "",
      rating: 0,
      price: 0,
      timesOrdered: 0,
      stock: 0,
      firstImage: "",
      secondImage: "",
    );
  }
}
//////////////////////////////////

Future<APIStatus> sendCatagory(CategoryData dataObj) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';
  final response = await http.post(
    Uri.parse('$serverUrl/admin/addCategory'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },
    body: jsonEncode(<String, String>{
      'categoryName': dataObj.catagoryName,
    }),
  );
  return APIStatus(
      statusCode: response.statusCode,
      message: jsonDecode(response.body)['message']);
}

Future<APIStatus> deleteCatagory(CategoryData dataObj) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';
  final response = await http.delete(
    Uri.parse(
        '$serverUrl/admin/deleteCategory/${dataObj.categoryId.toString()}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },
  );

  return APIStatus(
      statusCode: response.statusCode,
      message: jsonDecode(response.body)['message']);
}

Future<List<CategoryData>> fetchCatagories() async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';
  final response = await http.get(
    Uri.parse('$serverUrl/admin/getCategories'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    return CategoryData.toList(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Bookings');
  }
}

class CategoryData {
  final int categoryId;
  final String catagoryName;

  const CategoryData({
    required this.categoryId,
    required this.catagoryName,
  });

  static List<CategoryData> toList(List<dynamic> data) {
    List<CategoryData> card = [];
    for (int i = 0; i < data.length; i++) {
      try {
        card.add(CategoryData(
          categoryId: data[i]['categoryId'],
          catagoryName: data[i]['categoryName'],
        ));
      } catch (err) {
        print(err);
      }
    }

    return card;
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'catagoryName': catagoryName,
    };
  }

  @override
  bool operator ==(Object other) =>
      other is CategoryData &&
      categoryId == other.categoryId &&
      catagoryName == other.catagoryName;
  @override
  int get hashCode => categoryId.hashCode ^ catagoryName.hashCode;
}
