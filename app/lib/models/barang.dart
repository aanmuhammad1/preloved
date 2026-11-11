class Barang {
  final String id;
  final String nama;
  final String kategori;
  final String kondisi;
  final int harga;
  final bool bisaNego;
  final DateTime diunggah;
  final String penjual;
  final String deskripsi;

  Barang({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.kondisi,
    required this.harga,
    required this.bisaNego,
    required this.diunggah,
    required this.penjual,
    required this.deskripsi,
  });

  // Mengubah JSON menjadi objek Barang
  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id'],
      nama: json['nama'],
      kategori: json['kategori'],
      kondisi: json['kondisi'],
      harga: json['harga'],
      bisaNego: json['bisaNego'],
      diunggah: DateTime.parse(json['diunggah']),
      penjual: json['penjual'],
      deskripsi: json['deskripsi'],
    );
  }

  // Mengubah objek Barang menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'kondisi': kondisi,
      'harga': harga,
      'bisaNego': bisaNego,
      'diunggah': diunggah.toIso8601String(),
      'penjual': penjual,
      'deskripsi': deskripsi,
    };
  }
}
