import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

Future<List<dynamic>> loadBarang() async {
  final file = File('data/barang.json');
  final content = await file.readAsString();

  return jsonDecode(content) as List<dynamic>;
}

// Menyamakan format kategori agar pencocokan lebih konsisten.
String normalizeCategory(String value) {
  final decoded = Uri.decodeComponent(value.replaceAll('+', '%20'));

  return decoded.trim().toLowerCase();
}

Future<void> main() async {
  final router = Router();

  // Endpoint 1: Mengambil semua barang.
  router.get('/barang', (Request request) async {
    final barang = await loadBarang();

    return Response.ok(
      jsonEncode(barang),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // Endpoint 2: Mengambil barang berdasarkan ID.
  router.get('/barang/<id>', (Request request, String id) async {
    final barang = await loadBarang();

    final hasil = barang.where((item) => item['id'].toString() == id).toList();

    if (hasil.isEmpty) {
      return Response.notFound(
        jsonEncode({'pesan': 'Barang tidak ditemukan'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    return Response.ok(
      jsonEncode(hasil.first),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // Endpoint 3: Mengambil barang berdasarkan kategori.
  router.get('/kategori/<nama>', (Request request, String nama) async {
    final barang = await loadBarang();

    final kategoriDicari = normalizeCategory(nama);

    final hasil = barang.where((item) {
      final kategoriBarang = normalizeCategory(
        item['kategori']?.toString() ?? '',
      );

      return kategoriBarang == kategoriDicari;
    }).toList();

    return Response.ok(
      jsonEncode(hasil),
      headers: {'Content-Type': 'application/json'},
    );
  });

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);

  print(
    'Preloved API berjalan di http://${server.address.host}:${server.port}',
  );
}
