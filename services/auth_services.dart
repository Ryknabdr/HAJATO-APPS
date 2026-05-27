  import 'dart:convert';
  import 'dart:io';

  import 'package:hajato/app/core/constants/api_config.dart';

  import 'package:http/http.dart' as http;

  class AuthService {


    // =========================
    // LOGIN
    // =========================
static Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {

  try {

    final response = await http.post(

      Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    return {
      "statusCode": response.statusCode,
      "data": data,
    };

  } catch (e) {

    print("LOGIN ERROR: $e");

    return {
      "statusCode": 500,
      "data": {
        "message": "Tidak dapat terhubung ke server"
      },
    };

  }
}
    // =========================
    // REGISTER USER
    // =========================
    static Future<Map<String, dynamic>> register({
      required String name,
      required String email,
      required String password,
      required String role,
    }) async {

      try {

        final response = await http.post(

          Uri.parse('${ApiConfig.baseUrl}/api/auth/register'),

          headers: {
            'Content-Type': 'application/json',
          },

          body: jsonEncode({
            "name": name,
            "email": email,
            "password": password,
            "role": role,
          }),
        );

        final data = jsonDecode(response.body);

        return {
          "statusCode": response.statusCode,
          "data": data,
        };

      } catch (e) {

        return {
          "statusCode": 500,
          "data": {
            "message": "Tidak dapat terhubung ke server"
          },
        };

      }
    }

    // =========================
    // REGISTER VENDOR
    // =========================
    static Future<Map<String, dynamic>> registerVendor({

      required String businessName,
      required String category,
      required String description,
      required String location,
      required String phone,

      required String ownerName,
      required String ownerNik,

      required String email,
      required String password,

      String? npwp,

      File? ktpFile,
      File? selfieFile,
      File? businessLicenseFile,

    }) async {

      try {

  final uri = Uri.parse(
    '${ApiConfig.baseUrl}/api/auth/register-vendor',
  );

        final request = http.MultipartRequest(
          'POST',
          uri,
        );

        // =========================
        // FIELD
        // =========================

        request.fields['name'] = businessName;
        request.fields['email'] = email;
        request.fields['password'] = password;

        request.fields['business_name'] = businessName;
        request.fields['category'] = category;
        request.fields['description'] = description;
        request.fields['location'] = location;
        request.fields['phone'] = phone;

        request.fields['owner_name'] = ownerName;
        request.fields['owner_nik'] = ownerNik;

        request.fields['npwp'] = npwp ?? '';

        // =========================
        // FILE KTP
        // =========================

        if (ktpFile != null) {

          request.files.add(
            await http.MultipartFile.fromPath(
              'ktp_image',
              ktpFile.path,
            ),
          );
        }

        // =========================
        // FILE SELFIE
        // =========================

        if (selfieFile != null) {

          request.files.add(
            await http.MultipartFile.fromPath(
              'selfie_image',
              selfieFile.path,
            ),
          );
        }

        // =========================
        // FILE IZIN USAHA
        // =========================

        if (businessLicenseFile != null) {

          request.files.add(
            await http.MultipartFile.fromPath(
              'business_license',
              businessLicenseFile.path,
            ),
          );
        }

        // =========================
        // SEND REQUEST
        // =========================

        final streamedResponse =
            await request.send();

        final response =
            await http.Response.fromStream(
          streamedResponse,
        );

        final data =
            jsonDecode(response.body);

        return {
          "statusCode": response.statusCode,
          "data": data,
        };

      } catch (e) {

        print(e);

        return {
          "statusCode": 500,
          "data": {
            "message": "Tidak dapat terhubung ke server"
          },
        };

      }
    }

    // =========================
    // GOOGLE LOGIN
    // =========================
    static Future<Map<String, dynamic>> googleLogin({
      required String idToken,
    }) async {

      try {

        final response = await http.post(

          Uri.parse('${ApiConfig.baseUrl}/api/auth/google-login'),

          headers: {
            'Content-Type': 'application/json',
          },

          body: jsonEncode({
            "idToken": idToken,
          }),
        );

        final data = jsonDecode(response.body);

        return {
          "statusCode": response.statusCode,
          "data": data,
        };

      } catch (e) {

        return {
          "statusCode": 500,
          "data": {
            "message": "Tidak dapat terhubung ke server"
          },
        };

      }
    }
  }