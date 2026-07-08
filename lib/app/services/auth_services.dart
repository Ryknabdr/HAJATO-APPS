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
          "message": "Tidak dapat terhubung ke server",
        },
      };
    }
  }

    // =========================
  // LOGIN WITH FACE
  // =========================
  static Future<Map<String, dynamic>> loginWithFace({
    required File faceImage,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/api/auth/login-face-identify',
      );

      final request = http.MultipartRequest(
        'POST',
        uri,
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'face_image',
          faceImage.path,
        ),
      );

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      final data = jsonDecode(response.body);

      return {
        "statusCode": response.statusCode,
        "data": data,
      };
    } catch (e) {
      print("LOGIN WITH FACE ERROR: $e");

      return {
        "statusCode": 500,
        "data": {
          "message": "Tidak dapat terhubung ke server",
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
    required String phone,
    required String password,
    String role = 'user',
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
          "phone": phone,
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
      print("REGISTER ERROR: $e");

      return {
        "statusCode": 500,
        "data": {
          "message": "Tidak dapat terhubung ke server",
        },
      };
    }
  }

  // =========================
  // VERIFY REGISTER OTP
  // Dipakai untuk register user dan register vendor
  // =========================
  static Future<Map<String, dynamic>> verifyRegisterOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/verify-register-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": email,
          "otp": otp,
        }),
      );

      final data = jsonDecode(response.body);

      return {
        "statusCode": response.statusCode,
        "data": data,
      };
    } catch (e) {
      print("VERIFY REGISTER OTP ERROR: $e");

      return {
        "statusCode": 500,
        "data": {
          "message": "Tidak dapat terhubung ke server",
        },
      };
    }
  }

    // =========================
  // REGISTER USER WITH FACE
  // =========================
  static Future<Map<String, dynamic>> registerWithFace({
    required String name,
    required String email,
    required String phone,
    required String password,
    required List<File> faceImages,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/api/auth/register-with-face',
      );

      final request = http.MultipartRequest(
        'POST',
        uri,
      );

      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['phone'] = phone;
      request.fields['password'] = password;

      for (int i = 0; i < faceImages.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'face_image_${i + 1}',
            faceImages[i].path,
          ),
        );
      }

      request.fields['pose_type_1'] = 'normal';
      request.fields['pose_type_2'] = 'smile';
      request.fields['pose_type_3'] = 'side';

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      final data = jsonDecode(response.body);

      return {
        "statusCode": response.statusCode,
        "data": data,
      };
    } catch (e) {
      print("REGISTER WITH FACE ERROR: $e");

      return {
        "statusCode": 500,
        "data": {
          "message": "Tidak dapat terhubung ke server",
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
      // FIELD USER
      // =========================
      request.fields['name'] = ownerName;
      request.fields['email'] = email;
      request.fields['password'] = password;

      // =========================
      // FIELD VENDOR
      // =========================
      request.fields['business_name'] = businessName;
      request.fields['category'] = category;
      request.fields['description'] = description;
      request.fields['location'] = location;
      request.fields['phone'] = phone;

      request.fields['owner_name'] = ownerName;

      // PENTING:
      // Backend Flask kamu membaca "nik", bukan "owner_nik"
      request.fields['nik'] = ownerNik;

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

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      final data = jsonDecode(response.body);

      return {
        "statusCode": response.statusCode,
        "data": data,
      };
    } catch (e) {
      print("REGISTER VENDOR ERROR: $e");

      return {
        "statusCode": 500,
        "data": {
          "message": "Tidak dapat terhubung ke server",
        },
      };
    }
  }

    // =========================
  // REGISTER VENDOR WITH FACE
  // =========================
  static Future<Map<String, dynamic>> registerVendorWithFace({
    required String businessName,
    required String category,
    required String description,
    required String location,
    required String phone,
    required String ownerName,
    required String ownerNik,
    required String email,
    required String password,
    required List<File> faceImages,
    String? npwp,
    File? ktpFile,
    File? selfieFile,
    File? businessLicenseFile,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/api/auth/register-vendor-with-face',
      );

      final request = http.MultipartRequest(
        'POST',
        uri,
      );

      // =========================
      // FIELD USER
      // =========================
      request.fields['name'] = ownerName;
      request.fields['email'] = email;
      request.fields['password'] = password;

      // =========================
      // FIELD VENDOR
      // =========================
      request.fields['business_name'] = businessName;
      request.fields['category'] = category;
      request.fields['description'] = description;
      request.fields['location'] = location;
      request.fields['phone'] = phone;

      request.fields['owner_name'] = ownerName;
      request.fields['nik'] = ownerNik;
      request.fields['npwp'] = npwp ?? '';

      // =========================
      // FILE DOKUMEN VENDOR
      // =========================
      if (ktpFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'ktp_image',
            ktpFile.path,
          ),
        );
      }

      if (selfieFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'selfie_image',
            selfieFile.path,
          ),
        );
      }

      if (businessLicenseFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'business_license',
            businessLicenseFile.path,
          ),
        );
      }

      // =========================
      // FOTO WAJAH VENDOR
      // =========================
      for (int i = 0; i < faceImages.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'face_image_${i + 1}',
            faceImages[i].path,
          ),
        );
      }

      request.fields['pose_type_1'] = 'normal';
      request.fields['pose_type_2'] = 'smile';
      request.fields['pose_type_3'] = 'side';

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      final data = jsonDecode(response.body);

      return {
        "statusCode": response.statusCode,
        "data": data,
      };
    } catch (e) {
      print("REGISTER VENDOR WITH FACE ERROR: $e");

      return {
        "statusCode": 500,
        "data": {
          "message": "Tidak dapat terhubung ke server",
        },
      };
    }
  }

  // =========================
  // GOOGLE LOGIN / GOOGLE REGISTER
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
      print("GOOGLE LOGIN ERROR: $e");

      return {
        "statusCode": 500,
        "data": {
          "message": "Tidak dapat terhubung ke server",
        },
      };
    }
  }
}