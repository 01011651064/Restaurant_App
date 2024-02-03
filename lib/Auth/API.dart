
import '/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIStatus {
  int statusCode;

  List<dynamic> body;

  APIStatus({required this.statusCode, required this.body});
}

class APIStatus2 {
  int statusCode;

  String message;

  APIStatus2({required this.statusCode, required this.message});
}


  Future<APIStatus2> generateCode(
    String email,
  ) async {
    final response = await http.post(
      Uri.parse('$serverUrl/api/forgotPassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    return APIStatus2(
        statusCode: response.statusCode,
        message: jsonDecode(response.body)['message'].toString());
  }

  
  Future<APIStatus2> changePassword(
    String email,
    String password,
  ) async {
    final response = await http.put(
      Uri.parse('$serverUrl/api/changeForgotPassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    return APIStatus2(
        statusCode: response.statusCode,
        message: jsonDecode(response.body)['message'].toString());
  }

  
  Future<APIStatus> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$serverUrl/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    return APIStatus(
        statusCode: response.statusCode,
        body: jsonDecode(response.body).values.toList());
  }

  
  Future<APIStatus> register(
      String firstName,
      String lastName,
      String email,
      String password,
      String birthDate,
      String longitudeAddress,
      String latitudeAddress,
      String phoneNumber,
      String type) async {
    final response = await http.post(
      Uri.parse('$serverUrl/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'birthDate': birthDate,
        'longitudeAddress': longitudeAddress,
        'latitudeAddress': latitudeAddress,
        'phoneNumber': phoneNumber,
        'type': type,
      }),
    );

    return APIStatus(
        statusCode: response.statusCode,
        body: jsonDecode(response.body).values.toList());
  }