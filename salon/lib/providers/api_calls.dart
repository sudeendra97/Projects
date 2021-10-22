import 'dart:convert';
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
  var orderId;

  List<Business> barberShopList = [];
  Map<String, String> barberDetails = {
    'barberName': '',
    'barberDescription': '',
    'barberAddress': '',
  };

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

  String? get userId {
    return _id;
  }

  String? get token {
    return _token;
  }

  Future<int> signUp(var data, var token) async {
    var image = data['image'];
    var name = data['fileName'];
    print('signUp');

    final Url = '${baseUrl}business/addNewBusiness';
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": token,
    };
    try {
      var request = http.MultipartRequest('POST', Uri.parse(Url));
      request.headers.addAll(headers);
      if (image != null) {
        request.files.add(
          http.MultipartFile.fromBytes('image', image,
              // File(image).readAsBytesSync(),
              // File(image.relativePath).lengthSync(),
              filename: name),
        );
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
      // print(res.statusCode);
      return res.statusCode;
    } catch (error) {
      // print(error);
    }
    return 500;
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
      // print('userData');
      return false;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    // final expiryDate =
    //     DateTime.parse(extratedUserData['expiryDate'].toString());
    // print(extratedUserData);

    // if (expiryDate.isBefore(DateTime.now())) {
    //   return false;
    //   // print(expiryDate);
    // }
    _token = extratedUserData["token"];
    _id = extratedUserData["userId"];

    print(_token);

    notifyListeners();

    //  print(_token);
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
      List<CustomerBooking> list = [];
      for (var data in response) {
        list.add(
          CustomerBooking(
            barberName: data['Barber_Name'],
            id: data['_id'],
            selectedDate: data['Selected_Date'].toString(),
            shopName: data['Shop_Name'],
            time: data['Time'],
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
      // print(res.statusCode);
      // print(res.body);

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
      // print(res.statusCode);
      // print('this is user ${res.body}');

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
      print(e);
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
  Future<int> updateShopProfilePic(var image, var token, var fileName) async {
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

      // for (int i = 0; i < data['signUpData']['BarberNames'].length; i++) {
      //   return request.fields['Barber$i'] =
      //       data['signUpData']['BarberNames'][i];
      // }

      // print(request.files.toString());

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
}

//cutImages
