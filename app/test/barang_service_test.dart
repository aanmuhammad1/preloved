import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:preloved/models/barang.dart';
import 'package:preloved/services/barang_service.dart';

void main() {
  group('BarangService dengan MockClient', () {
    test('fetchBarang mengembalikan daftar barang dari API', () async {
      final mockClient = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.toString(), 'http://localhost:8080/barang');

        return http.Response(
          jsonEncode([
            {
              'id': 'BRG001',
              'nama': 'Buku Pemrograman Java',
              'kategori': 'Buku',
              'kondisi': 'Seperti Baru',
              'harga': 75000,
              'bisaNego': true,
              'diunggah': '2026-11-01T10:00:00.000Z',
              'penjual': 'Andi',
              'deskripsi': 'Buku pemrograman untuk mahasiswa.',
            },
          ]),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = BarangService(
        client: mockClient,
        baseUrl: 'http://localhost:8080',
      );

      final result = await service.fetchBarang();

      expect(result, hasLength(1));
      expect(result.first, isA<Barang>());
      expect(result.first.id, 'BRG001');
      expect(result.first.nama, 'Buku Pemrograman Java');
      expect(result.first.harga, 75000);
      expect(result.first.bisaNego, isTrue);
      expect(result.first.diunggah, DateTime.parse('2026-11-01T10:00:00.000Z'));

      service.close();
    });

    test('fetchBarang melempar exception jika server error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server error', 500);
      });

      final service = BarangService(
        client: mockClient,
        baseUrl: 'http://localhost:8080',
      );

      await expectLater(service.fetchBarang(), throwsA(isA<Exception>()));

      service.close();
    });
  });
}
