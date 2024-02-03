import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:resto/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<OrderData>> fetchOrders(double minPrice, double maxPrice) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';

  final response = await http.post(Uri.parse('$serverUrl/admin/getOrders'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'token': token,
      },
      body: jsonEncode(<String, String>{
        'minPrice': minPrice.toString(),
        'maxPrice': maxPrice.toString()
      }));

  if (response.statusCode == 200) {
    return OrderData.toList(jsonDecode(response.body), response.headers);
  } else {
    throw Exception('Failed to load order history');
  }
}

Future<List<OrderData>> fetchOrdersNameFilter(String name) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';

  final response = await http.get(
    Uri.parse('$serverUrl/admin/getOrdersNameFilter/$name'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    return OrderData.toList(jsonDecode(response.body), response.headers);
  } else if (response.statusCode == 404) {
    return [];
  } else {
    throw Exception('Failed to load order history');
  }
}

Future<List<OrderData>> fetchOrdersFilterStatus(int deliveryStatus) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';

  final response = await http.get(
    Uri.parse('$serverUrl/admin/getOrdersFilterStatus/$deliveryStatus'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    return OrderData.toList(jsonDecode(response.body), response.headers);
  } else {
    throw Exception('Failed to load order history');
  }
}

class OrderData {
  static double maxPrice = 1000;
  final int orderId;
  final double longitudeAddress;
  final double latitudeAddress;
  final String dateOfOrder;
  final int deliveryStatus;
  final int? deliveryManId;
  final int customerId;
  final double totalPrice;
  final String firstName;
  final String lastName;

  const OrderData({
    required this.orderId,
    required this.longitudeAddress,
    required this.latitudeAddress,
    required this.dateOfOrder,
    required this.deliveryStatus,
    required this.deliveryManId,
    required this.customerId,
    required this.totalPrice,
    required this.firstName,
    required this.lastName,
  });

  static List<OrderData> toList(
      List<dynamic> data, Map<String, String> headers) {
    if (headers.keys.contains('maxprice')) {
      if (headers['maxprice'].toString() != 'NaN') {
        maxPrice = (double.tryParse(headers['maxprice'].toString()) ?? 0)
            .ceil()
            .toDouble();
      }
    }

    List<OrderData> card = [];
    for (int i = 0; i < data.length; i++) {
      try {
        card.add(OrderData(
          orderId: data[i]['orderId'],
          longitudeAddress: double.parse(data[i]['longitudeAddress']),
          latitudeAddress: double.parse(data[i]['latitudeAddress']),
          dateOfOrder: data[i]['dateOfOrder'],
          deliveryStatus: data[i]['deliveryStatus'],
          deliveryManId: data[i]['deliveryManId'],
          customerId: data[i]['customerId'],
          firstName: data[i]['firstName'],
          lastName: data[i]['lastName'],
          totalPrice: data[i]['totalPrice'] + 0.0,
        ));
        // card.add(OrderData(
        //   orderId: data[i]['orderId'],
        //   longitudeAddress: data[i]['longitudeAddress'] + 0.0,
        //   latitudeAddress: data[i]['latitudeAddress'] + 0.0,
        //   dateOfOrder: data[i]['dateOfOrder'],
        //   deliveryStatus: data[i]['deliveryStatus'],
        //   deliveryManId: data[i]['deliveryManId'],
        //   customerId: data[i]['customerId'],
        //   firstName: data[i]['firstName'],
        //   lastName: data[i]['lastName'],
        //   totalPrice: data[i]['totalPrice'] + 0.0,
        // ));
      } catch (err) {
        print(err);
      }
    }

    return card;
  }
}

Future<List<DeliveryMenData>> fetchDeliveryMen(int maxNumberOfOrders) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';

  final response = await http.get(
    Uri.parse('$serverUrl/admin/getDeliveryMen/$maxNumberOfOrders'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    return DeliveryMenData.toList(jsonDecode(response.body), response.headers);
  } else {
    throw Exception('Failed to load DeliveryMen');
  }
}

Future<List<DeliveryMenData>> fetchDeliveryMenFilterStatus(int status) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';

  final response = await http.get(
    Uri.parse('$serverUrl/admin/getDeliveryMenFilterStatus/$status'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },
  );
  if (response.statusCode == 200) {
    return DeliveryMenData.toList(jsonDecode(response.body), response.headers);
  } else {
    throw Exception('Failed to load DeliveryMen');
  }
}

// ignore: camel_case_types
class DeliveryMenData {
  static int maxNumberOfOrders = 100;
  final String firstName;
  final String lastName;
  final int deliveryManId;
  final String dateOfJoining;
  final double rating;
  final int numberOfOrders;

  const DeliveryMenData({
    required this.firstName,
    required this.lastName,
    required this.deliveryManId,
    required this.dateOfJoining,
    required this.rating,
    required this.numberOfOrders,
  });

  static List<DeliveryMenData> toList(
      List<dynamic> data, Map<String, String> headers) {
    if (headers.keys.contains('maxnumberoforders')) {
      if (headers['maxnumberoforders'].toString() != 'NaN') {
        maxNumberOfOrders =
            (int.tryParse(headers['maxnumberoforders'].toString()) ?? 0);
      }
    }

    List<DeliveryMenData> card = [];
    for (int i = 0; i < data.length; i++) {
      try {
        card.add(DeliveryMenData(
          firstName: data[i]['firstName'],
          lastName: data[i]['lastName'],
          deliveryManId: data[i]['deliveryManId'],
          dateOfJoining: data[i]['dateOfJoining'],
          rating: data[i]['rating'] + 0.0,
          numberOfOrders: data[i]['numberOfOrders'],
        ));
      } catch (err) {
        print(err);
      }
    }

    return card;
  }
}
/////////////////////

Future<List<BookingData>> fetchbooking() async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';

  final response = await http.get(
    Uri.parse('$serverUrl/admin/getBookings'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    return BookingData.toList(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Bookings');
  }
}

Future<List<BookingData>> fetchBookingWithTableNumber(int table) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';

  final response = await http.get(
    Uri.parse('$serverUrl/admin/getBookingWithTableNumberFilter/$table'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    return BookingData.toList(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Bookings');
  }
}

Future<List<BookingData>> fetchBookingWithNumberOfPeople(int people) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? '';

  final response = await http.get(
    Uri.parse('$serverUrl/admin/getBookingWithNumberOfPeopleFilter/$people'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'token': token,
    },
  );

  if (response.statusCode == 200) {
    return BookingData.toList(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Bookings');
  }
}

class BookingData {
  final int bookingId;
  final String date;
  final String startTime;
  final String endTime;
  final int numberOfPeople;
  final int tableNumber;

  const BookingData({
    required this.bookingId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.numberOfPeople,
    required this.tableNumber,
  });

  static List<BookingData> toList(List<dynamic> data) {
    List<BookingData> card = [];
    for (int i = 0; i < data.length; i++) {
      try {
        card.add(BookingData(
          bookingId: data[i]['bookingId'],
          date: data[i]['date'],
          startTime: data[i]['startTime'],
          endTime: data[i]['endTime'],
          numberOfPeople: data[i]['numberOfPeople'],
          tableNumber: data[i]['tableNumber'],
        ));
      } catch (err) {
        print(err);
      }
    }

    return card;
  }
}
