import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/barang.dart';

class BarangService {
  final http.Client _client;
  final String _baseUrl;

  BarangService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl =
          (baseUrl ??
                  const String.fromEnvironment(
                    'API_URL',
                    defaultValue: 'http://10.0.2.2:8080',
                  ))
              .replaceAll(RegExp(r'/$'), '');

  Future<List<Barang>> fetchBarang() async {
    final response = await _client.get(Uri.parse('$_baseUrl/barang'));

    _checkResponse(response);

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((item) => Barang.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Barang> fetchBarangById(String id) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/barang/${Uri.encodeComponent(id)}'),
    );

    _checkResponse(response);

    return Barang.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Barang>> fetchBarangByKategori(String kategori) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/kategori/${Uri.encodeComponent(kategori)}'),
    );

    _checkResponse(response);

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map((item) => Barang.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  void _checkResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Gagal memuat data. HTTP ${response.statusCode}: ${response.body}',
      );
    }
  }

  void close() {
    _client.close();
  }
}
