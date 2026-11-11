import 'package:flutter/material.dart';

import '../models/barang.dart';

String? getBarangImage(String id) {
  switch (id) {
    case 'BRG001':
      return 'assets/images/products/buku_java.png';
    case 'BRG002':
      return 'assets/images/products/keyboard.png';
    case 'BRG003':
      return 'assets/images/products/tas_kuliah.png';
    case 'BRG004':
      return 'assets/images/products/lampu_belajar.png';
    case 'BRG005':
      return 'assets/images/products/mouse_wireless.png';
    case 'BRG006':
      return 'assets/images/products/buku_basis_data.png';
    case 'BRG007':
      return 'assets/images/products/kursi_lipat.png';
    case 'BRG008':
      return 'assets/images/products/kalkulator_scientific.png';
    case 'BRG009':
      return 'assets/images/products/headset_bluetooth.png';
    case 'BRG010':
      return 'assets/images/products/novel_bekas.png';
    case 'BRG011':
      return 'assets/images/products/rak_buku_mini.png';
    case 'BRG012':
      return 'assets/images/products/binder_kuliah.png';
    default:
      return null;
  }
}

Widget buildBarangImage(BuildContext context, Barang barang) {
  final imagePath = getBarangImage(barang.id);
  final colorScheme = Theme.of(context).colorScheme;

  if (imagePath == null) {
    return Container(
      color: colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Icon(
        _getCategoryIcon(barang.kategori),
        size: 58,
        color: colorScheme.primary,
      ),
    );
  }

  return Image.asset(
    imagePath,
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        color: colorScheme.primaryContainer,
        alignment: Alignment.center,
        child: Icon(
          _getCategoryIcon(barang.kategori),
          size: 58,
          color: colorScheme.primary,
        ),
      );
    },
  );
}

IconData _getCategoryIcon(String kategori) {
  switch (kategori) {
    case 'Buku':
      return Icons.menu_book_outlined;
    case 'Elektronik':
      return Icons.devices_outlined;
    case 'Perlengkapan Kuliah':
      return Icons.school_outlined;
    case 'Perabot Kos':
      return Icons.chair_outlined;
    default:
      return Icons.inventory_2_outlined;
  }
}
