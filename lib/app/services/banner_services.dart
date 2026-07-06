import 'dart:convert';
import 'package:http/http.dart' as http;
// 🟢 FIX RELATIVE PATH: Dijamin pas nyari file api_config lo tanpa ngarang nama package
import 'package:hajato/app/core/constants/api_config.dart';
class BannerServices {
  static Future<List<dynamic>> fetchActiveBanners() async {
    // 🟢 Memakai endpoint API dinamis murni berbasis ApiConfig.baseUrl lo
    final String url = "${ApiConfig.baseUrl}/api/banners/active";
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> banners = responseData['data'];
        
        // 🟢 POTONG SUB-PATH /API KHUSUS UNTUK ASET GAMBAR STATIS
        // Biar path gambarnya gak jadi: https://domain-ngrok.com/api/static/uploads/...
        String domainMurni = ApiConfig.baseUrl;
        if (domainMurni.endsWith('/api')) {
          domainMurni = domainMurni.substring(0, domainMurni.length - 4);
        }
        
        // Loop untuk menyatukan Domain Ngrok Murni dengan path '/static/uploads/' dari MongoDB
        for (var banner in banners) {
          String imageUrl = banner['image_url'] ?? '';
          if (imageUrl.startsWith('/static')) {
            banner['image_url'] = domainMurni + imageUrl;
          }
        }
        
        return banners;
      } else {
        print("Gagal fetch banner: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error pada BannerServices: $e");
      return [];
    }
  }
}