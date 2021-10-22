import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:salon/providers/barber_booking_details.dart';
import 'package:salon/providers/business.dart';
import 'package:salon/providers/customer_booking_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiCalls with ChangeNotifier {
  final baseUrl = 'https://hairambe.herokuapp.com/hairambe/';
  var _token;
  var user_Type;
  var name;
  var _id;
  var _userType;
  var _businessSetUp;
  var _expiryDate;
  var _authTimer;

  var orderId;

  List<Business> barberShopList = [];
  Map<String, String> barberDetails = {
    'barberName': '',
    'barberDescription': '',
    'barberAddress': '',
  };

  static List routes = [];

  // Map<String,String> getBarberDetails(int index) {
  //   barberShopList.where((element) {
  //     if (element.index == index) {
  //       barberDetails['barberName'] = element.businessName;
  //       barberDetails['barberDescription'] = element.description;
  //       barberDetails['barberAddress'] =
  //           '${element.state},${element.city},${element.country}';

  //     }
  //      return barberDetails;
  //   });
  // }

  Business getBarberDetails(int index) {
    return barberShopList.firstWhere((prod) => prod.index == index);
  }

  bool get isAuth {
    return token != null;
  }

  String? get userType {
    return user;
  }

  bool get businessSetUp {
    return business;
  }

  String? get userId {
    return _id;
  }

  String? get token {
    return _token;
  }

  String? get user {
    return _userType;
  }

  bool get business {
    if (_businessSetUp == null) {
      return false;
    } else {
      return _businessSetUp;
    }
  }

  Future<int> signUpBusiness(Map<String, String> user) async {
    final url = Uri.parse('${baseUrl}authorization/addNewUser');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            // 'name': user['name'],
            'email': user['email'],
            'password': user['password'],
            'user_Type': user['user_Type']
          },
        ),
      );

      // print(response.statusCode);
      return response.statusCode;
    } catch (e) {
      rethrow;
      // print('SignUp Error $e');
    }
  }

  Future<int> signUp(var data, var token) async {
    var image = data['image'];
    var name = data['fileName'];
    print(image.length);
    List<MultipartFile> newList = [];

    final Url = '${baseUrl}business/addNewBusiness';
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": token,
    };
    try {
      var request = http.MultipartRequest('POST', Uri.parse(Url));
      request.headers.addAll(headers);
      if (image != null) {
        for (int i = 0; i < image.length; i++) {
          var multipartFile = http.MultipartFile.fromBytes('image', image[i],
              // File(image).readAsBytesSync(),
              // File(image.relativePath).lengthSync(),
              filename: 'image${i}.jpg');
          newList.add(multipartFile);
        }
        request.files.addAll(newList);
        // request.files.add(
        //   http.MultipartFile.fromBytes('image', image,
        //       // File(image).readAsBytesSync(),
        //       // File(image.relativePath).lengthSync(),
        //       filename: name),
        // );
      }

      request.fields['Description'] = data['signUpData']['Description'];
      request.fields['BusinessName'] = data['signUpData']['BusinessName'];
      request.fields['Street'] = data['signUpData']['Street'];
      request.fields['Apt'] = data['signUpData']['Apt'];
      request.fields['City'] = data['signUpData']['city'];
      request.fields['State'] = data['signUpData']['State'];
      request.fields['ZipCode'] = data['signUpData']['ZipCode'];
      request.fields['Country'] = data['signUpData']['Country'];
      // request.fields['Address'] = data['signUpData'].toString();

      request.fields['BusinessCategory'] = data['signUpData']['Business'];

      // for (int i = 0; i < data['signUpData']['BarberNames'].length; i++) {
      //   return request.fields['Barber$i'] =
      //       data['signUpData']['BarberNames'][i];
      // }
      for (var barber in data['signUpData']['BarberNames']) {
        request.files.add(http.MultipartFile.fromString('Barber_Name', barber));
      }

      // print(request.fields);
      // print(request.files.toString());

      var res = await request.send();

      print(res.statusCode);
      if (res.statusCode == 201 || res.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        if (prefs.containsKey('userData')) {
          final extratedUserData =
              //we should use dynamic as a another value not a Object
              json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
          _token = extratedUserData["token"];
          _id = extratedUserData["userId"];
          _userType = extratedUserData["userType"];
          _businessSetUp = true;
          _expiryDate = DateTime.now().add(
            Duration(days: 60),
          );

          final userData = json.encode(
            {
              'token': _token,
              'userId': _id,
              'userType': _userType,
              'businessSetUp': _businessSetUp,
              'expiryDate': _expiryDate.toIso8601String(),
            },
          );
          prefs.setString('userData', userData);
        }
      }
      // print(res.statusCode);
      return res.statusCode;
    } catch (error) {
      // print(error);
    }
    return 500;
  }

  Future<Map<String, dynamic>> signUpCustomer(Map<String, String> user) async {
    final url = Uri.parse('${baseUrl}authorization/addNewUser');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            //'name': user['name'],
            'email': user['email'],
            'password': user['password'],
            'user_Type': user['user_Type']
          },
        ),
      );

      var data = json.decode(response.body);
      // print(response.statusCode);
      // print(response.body);
      _token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _id,
        },
      );
      prefs.setString('userData', userData);

      return {'status': response.statusCode, 'token': data['token']};
    } catch (e) {
      rethrow;
      // print('SignUp Error $e');
    }
  }

  Future<Map<String, dynamic>> signInUser(var email, var password) async {
    Map<String, dynamic> returnData = {
      'StatusCode': 0,
      'UserType': '',
      'token': '',
      'BusinessSetUp': '',
    };
    final url = Uri.parse('${baseUrl}authorization/signIn');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            'email': email,
            'password': password,
          },
        ),
      );
      // print(response.statusCode);
      // print(response.body);

      final responseData = json.decode(response.body);
      _token = responseData['token'];
      _id = responseData['user']['_id'];
      _userType = responseData['user']['user_Type'];
      _businessSetUp = responseData['user']['Business_SetUp'];
      _expiryDate = DateTime.now().add(
        Duration(days: 60),
      );
      name = responseData['user']['name'];
      returnData['StatusCode'] = response.statusCode;
      returnData['UserType'] = responseData['user']['user_Type'];
      returnData['token'] = responseData['token'];
      returnData['BusinessSetUp'] = responseData['user']['Business_SetUp'];

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _id,
          'userType': _userType,
          'businessSetUp': _businessSetUp,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
      // print(userData);

      return returnData;
    } catch (e) {
      // print('signIn Error $e');
    }
    return returnData;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print('userData');
      return false;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    if (extratedUserData['expiryDate'] != null) {
      final expiryDate =
          DateTime.parse(extratedUserData['expiryDate'].toString());
      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }
    }

    print('auto login $extratedUserData');

    _token = extratedUserData["token"];
    _id = extratedUserData["userId"] ?? 'No UserID';
    _userType = extratedUserData["userType"];
    _businessSetUp = extratedUserData["businessSetUp"];

    print(_token);

    notifyListeners();
    _autoLogOut();

    //  print(_token);
    return true;
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    if (_expiryDate != null) {
      final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
      _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
    }
  }

  Future<bool> logout() async {
    _token = null;
    _id = null;
    _userType = null;
    _businessSetUp = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    //notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return true;
  }

  Future<List<Business>> getBarberList(var token) async {
    final url = Uri.parse('${baseUrl}business/getBusiness');

    try {
      var res = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      var response = json.decode(res.body);
      List<Business> list = [];
      print(response);

      for (int i = 0; i < response.length; i++) {
        list.add(
          Business(
            id: response[i]['_id'],
            description: response[i]['Description'],
            businessName: response[i]['BusinessName'],
            street: response[i]['Street'],
            city: response[i]['City'],
            state: response[i]['State'],
            zipCode: response[i]['ZipCode'],
            country: response[i]['Country'],
            imagepath: response[i]['imagePath'] ?? '',
            index: i,
          ),
        );
      }

      // print(res.statusCode);
      // print(res.body);
      barberShopList = list;
      return list;
    } catch (e) {
      rethrow;
    }
    return [];
  }
  //getmybookinghistory
  //getmybookings

  Future<int> bookBarber(Map<String, String> data, var token) async {
    final url = Uri.parse('${baseUrl}booking/newBooking');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json", "Authorization": token},
        body: json.encode(data),
      );

      // print(response.statusCode);

      return response.statusCode;
    } catch (e) {
      // print(e);
    }

    return 500;
  }

  Future<List<CustomerBooking>> getCustomerBookings(var token) async {
    final url = Uri.parse('${baseUrl}booking/getmybookinghistory');

    try {
      var res = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      // print(res.statusCode);
      // print(res.body);
      var response = json.decode(res.body);
      print(response);
      List<CustomerBooking> list = [];
      for (var data in response) {
        list.add(
          CustomerBooking(
            barberName: data['Barber_Name'],
            id: data['_id'],
            selectedDate: data['Selected_Date'].toString(),
            shopName: data['Shop_Name'],
            time: data['Time'],
            shopImage: data['Shop_Image'],
          ),
        );
      }

      return list;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<BarberBookingDetails>> getBarberBookings(var token) async {
    final url = Uri.parse('${baseUrl}booking/getmybookings');

    try {
      var res = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      print(res.statusCode);
      print(res.body);

      var response = json.decode(res.body);
      List<BarberBookingDetails> list = [];
      for (var data in response) {
        list.add(
          BarberBookingDetails(
            barberName: data['Barber_Name'],
            time: data['Time'],
            date: data['Selected_Date'],
            customerName: data['name'],
          ),
        );
      }
      return list;
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<int> customerProfileSetUp(
      var data, var image, var token, var name) async {
    // var image = data['image'];
    // print(image);
    // print(name);

    final Url = '${baseUrl}userProfile/addNewUserProfile';
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": token,
    };
    try {
      var request = http.MultipartRequest('POST', Uri.parse(Url));
      request.headers.addAll(headers);
      if (image.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes('image', image,
              // File(image).readAsBytesSync(),
              // File(image.relativePath).lengthSync(),
              filename: name),
        );
      }

      request.fields['First_Name'] = data['First_Name'];
      request.fields['Last_Name'] = data['Last_Name'];
      request.fields['Street_Address'] = data['Address'];

      request.fields['City'] = data['City'];
      request.fields['State'] = data['State'];
      request.fields['ZipCode'] = data['Pin_Code'];
      request.fields['Country'] = data['Country'];

      var res = await request.send();
      // print(res.statusCode);
      var responseString = await res.stream.bytesToString();
      // print(json.decode(responseString));
      if (res.statusCode == 201 || res.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        if (prefs.containsKey('userData')) {
          final extratedUserData =
              //we should use dynamic as a another value not a Object
              json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
          _token = extratedUserData["token"];
          _id = extratedUserData["userId"];
          _userType = 'Customer';
          _businessSetUp = true;
          _expiryDate = DateTime.now().add(
            Duration(days: 60),
          );

          final userData = json.encode(
            {
              'token': _token,
              'userId': _id,
              'userType': _userType,
              'businessSetUp': _businessSetUp,
              'expiryDate': _expiryDate.toIso8601String(),
            },
          );
          prefs.setString('userData', userData);
        }
      }

      return res.statusCode;
    } catch (error) {
      // print(error);
    }
    return 500;
  }

  Future<Map<String, dynamic>> getUserProfile(var token) async {
    final Url = Uri.parse('${baseUrl}userProfile/getMyUserProfile');
    // print('api $token');

    try {
      var res = await http.get(
        Url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      print(res.statusCode);
      print('this is user ${res.body}');

      var response = json.decode(res.body);
      List images = [];
      Map<String, dynamic> imageData = {};
      for (var data in response['recentImages']) {
        imageData = data;

        images = imageData['cut_Images'];
      }

      return {
        'User_Id': response['profile']['User_Id'],
        'First_Name': response['profile']['First_Name'],
        'Last_Name': response['profile']['Last_Name'],
        'Street_Address': response['profile']['Street_Address'],
        'City': response['profile']['City'],
        'State': response['profile']['State'],
        'Zip_Code': response['profile']['ZipCode'],
        'Country': response['profile']['Country'],
        'image': response['profile']['Profile_Image'],
        'Prefered_HairStyle': response['profile']['Hair_Style'],
        'Cut_Images': images,
      };
    } catch (e) {
      print(e);
    }
    return {};
  }

  //'Payment_Method'
  Future<int> setPaymentMethod(var token) async {
    final Url = Uri.parse('${baseUrl}userProfile/updatePayment');

    try {
      var res = await http.patch(
        Url,
        body: json.encode({'Payment_Method': true}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      // print(res.statusCode);
      return res.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getShopProfile(var token) async {
    final Url = Uri.parse('${baseUrl}business/getMyBusinessProfile');

    try {
      var res = await http.get(
        Url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      // print(res.statusCode);
      // print(res.body);
      var response = json.decode(res.body);
      log(response.toString());

//business/getBarberList
      return {
        'ShopName': response['BusinessName'],
        'Description': response['Description'],
        'Address': response['Street'],
        'City': response['City'],
        'State': response['State'],
        'Country': response['Country'],
        'ZipCode': response['ZipCode'],
        'Barbers': response['Barber_Name'],
        'image': response['imagePath'],
        'UserId': response['User_Id'],
      };
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map<String, dynamic>> getBarbersList(var token, var shopId) async {
    final Url = Uri.parse('${baseUrl}business/getBarberList/$shopId');
    try {
      var res = await http.get(
        Url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      var response = json.decode(res.body);

      // print(res.statusCode);

      return {'BarberNames': response['Barber_Name']};
    } catch (e) {
      rethrow;
    }
  }

  Future<int> uploadCuts(List images, var token, var orderId) async {
    final Url = '${baseUrl}booking/addRecentImages';
    print(orderId);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": token,
    };
    List<MultipartFile> newList = [];

    try {
      var request = http.MultipartRequest('POST', Uri.parse(Url));
      request.headers.addAll(headers);
      for (int i = 0; i < images.length; i++) {
        var multipartFile = http.MultipartFile.fromBytes('image', images[i],
            // File(image).readAsBytesSync(),
            // File(image.relativePath).lengthSync(),
            filename: 'image${i}.jpg');
        newList.add(multipartFile);
      }
      request.files.addAll(newList);
      request.fields['Order_Id'] = orderId;
      var response = await request.send();

      var responseString = await response.stream.bytesToString();
      // print(json.decode(responseString));
      // print(response.reasonPhrase);
      // print(response.headers);
      var userData = json.decode(responseString);
      // print(response.statusCode);

      return response.statusCode;
    } catch (e) {
      print(e);
    }
    return 500;
  }

  // Future<void> getCustomerRecentCuts(var token)
  Future<int> updateShopProfilePic(
      var image, var token, var fileName, var oldImagePath) async {
    final Url = '${baseUrl}business/editBusinessImage';
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": token,
    };
    try {
      var request = http.MultipartRequest('PATCH', Uri.parse(Url));
      request.headers.addAll(headers);
      request.files.add(
        http.MultipartFile.fromBytes('image', image,
            // File(image).readAsBytesSync(),
            // File(image.relativePath).lengthSync(),
            filename: fileName),
      );
      request.fields['Old_Image'] = oldImagePath;

      var res = await request.send();
      // print(res.statusCode);
      return res.statusCode;
    } catch (error) {
      rethrow;
    }
  }

  Future<int> updateCustomerProfilePic(
      var image, var token, var fileName) async {
    final Url = '${baseUrl}userProfile/editImage';
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": token,
    };
    try {
      var request = http.MultipartRequest('PATCH', Uri.parse(Url));
      request.headers.addAll(headers);
      request.files.add(
        http.MultipartFile.fromBytes('image', image,
            // File(image).readAsBytesSync(),
            // File(image.relativePath).lengthSync(),
            filename: fileName),
      );

      // for (int i = 0; i < data['signUpData']['BarberNames'].length; i++) {
      //   return request.fields['Barber$i'] =
      //       data['signUpData']['BarberNames'][i];
      // }

      // print(request.fields);
      // print(request.files.toString());

      var res = await request.send();
      // print(res.statusCode);
      return res.statusCode;
    } catch (error) {
      // print(error);
    }
    return 500;
  }

  Future<int> updateCustomerProfile(var data, var token) async {
    final Url = '${baseUrl}userProfile/editCustomerProfile';

    try {
      var res = await http.patch(
        Uri.parse(Url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: json.encode(data),
      );

      // print(res.statusCode);
      // print(res.body);

      return res.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateShopProfile(var data, var token) async {
    final Url = '${baseUrl}business/editBusinessProfile';

    try {
      var res = await http.patch(
        Uri.parse(Url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: json.encode(data),
      );

      // print(res.statusCode);
      // print(res.body);

      return res.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addToFavorites(var id, var token) async {
    final Url = '${baseUrl}userProfile/addFavorite';
    print(id);

    try {
      var res = await http.post(
        Uri.parse(Url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: json.encode({'Id': id}),
      );

      print(res.statusCode);
      // print(res.body);
      notifyListeners();
      return res.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteFavorite(var id, var token) async {
    final Url = '${baseUrl}userProfile/removeFavorite/$id';

    try {
      var res = await http.patch(
        Uri.parse(Url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      print(res.statusCode);
      // print(res.body);

      return res.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  //userProfile/removeFavorite

  Future<List<Business>> fetchFavoriteList(var token) async {
    final url = Uri.parse('${baseUrl}userProfile/getFavorites');

    try {
      var res = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      print(res.statusCode);
      print(res.body);

      var response = json.decode(res.body);
      List<Business> list = [];

      for (int i = 0; i < response.length; i++) {
        list.add(
          Business(
            id: response[i]['_id'],
            description: response[i]['Description'],
            businessName: response[i]['BusinessName'],
            street: response[i]['Street'],
            city: response[i]['City'],
            state: response[i]['State'],
            zipCode: response[i]['ZipCode'],
            country: response[i]['Country'],
            imagepath: response[i]['imagePath'] ?? '',
            index: i,
          ),
        );
      }

      // print(res.body);
      barberShopList = list;
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> setHairStylePreference(var hairStyle, var token) async {
    final url = Uri.parse('${baseUrl}userProfile/addPreference');

    try {
      var res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
        body: json.encode({'Hair_Style': hairStyle}),
      );

      print(res.statusCode);
      // print(res.body);

      return res.statusCode;
    } catch (e) {
      rethrow;
    }
  }
}

//cutImages
