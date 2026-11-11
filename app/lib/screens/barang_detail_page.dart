import 'package:flutter/material.dart';

import '../utils/barang_image.dart';
import '../models/barang.dart';

class BarangDetailPage extends StatefulWidget {
  final Barang barang;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final String heroTag;

  const BarangDetailPage({
    super.key,
    required this.barang,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.heroTag,
  });

  @override
  State<BarangDetailPage> createState() => _BarangDetailPageState();
}

class _BarangDetailPageState extends State<BarangDetailPage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() {
    widget.onFavoritePressed();
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  String _formatHarga(int harga) {
    final digits = harga.toString();
    final result = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        result.write('.');
      }
      result.write(digits[i]);
    }
    return 'Rp ${result.toString()}';
  }

  String _formatTanggal(DateTime tanggal) {
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${tanggal.day} ${bulan[tanggal.month - 1]} ${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Detail Barang'),
        actions: [
          IconButton(
            tooltip: _isFavorite
                ? 'Hapus dari favorit'
                : 'Tambahkan ke favorit',
            onPressed: _toggleFavorite,
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? colorScheme.error : null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 1.15,
                child: Hero(
                  tag: widget.heroTag,
                  child: buildBarangImage(context, widget.barang),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.barang.nama,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                if (widget.barang.bisaNego)
                  Chip(
                    label: const Text('Nego'),
                    backgroundColor: colorScheme.primaryContainer,
                    side: BorderSide.none,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatHarga(widget.barang.harga),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Informasi Barang',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _InfoRow(label: 'Kategori', value: widget.barang.kategori),
            _InfoRow(label: 'Kondisi', value: widget.barang.kondisi),
            _InfoRow(label: 'Penjual', value: widget.barang.penjual),
            _InfoRow(
              label: 'Diunggah',
              value: _formatTanggal(widget.barang.diunggah),
            ),
            const SizedBox(height: 20),
            Text(
              'Deskripsi',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.barang.deskripsi,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _toggleFavorite,
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
              label: Text(
                _isFavorite ? 'Hapus dari Favorit' : 'Simpan ke Favorit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Text(':  '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
