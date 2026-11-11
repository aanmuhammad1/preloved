import 'package:flutter/material.dart';

import '../models/barang.dart';

class TambahBarangPage extends StatefulWidget {
  const TambahBarangPage({super.key});

  @override
  State<TambahBarangPage> createState() => _TambahBarangPageState();
}

class _TambahBarangPageState extends State<TambahBarangPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _penjualController = TextEditingController(text: 'Mahasiswa Preloved');

  final List<String> _kategori = [
    'Buku',
    'Elektronik',
    'Perlengkapan Kuliah',
    'Perabot Kos',
    'Lainnya',
  ];

  String _selectedKategori = 'Buku';
  String _selectedKondisi = 'Baru';
  bool _bisaNego = false;

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    _penjualController.dispose();
    super.dispose();
  }

  void _simpanBarang() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final barang = Barang(
      id: 'LOCAL-${DateTime.now().millisecondsSinceEpoch}',
      nama: _namaController.text.trim(),
      kategori: _selectedKategori,
      kondisi: _selectedKondisi,
      harga: int.parse(_hargaController.text.trim()),
      bisaNego: _bisaNego,
      diunggah: DateTime.now(),
      penjual: _penjualController.text.trim(),
      deskripsi: _deskripsiController.text.trim(),
    );

    Navigator.pop(context, barang);
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Barang')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text(
              'Jual barang preloved-mu',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Lengkapi informasi barang yang ingin kamu tawarkan.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _namaController,
              textCapitalization: TextCapitalization.sentences,
              decoration: _inputDecoration(
                'Nama barang',
                hint: 'Contoh: Buku Pemrograman Java',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama barang wajib diisi';
                }
                if (value.trim().length < 3) {
                  return 'Nama barang minimal 3 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedKategori,
              decoration: _inputDecoration('Kategori'),
              items: _kategori
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedKategori = value);
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Kondisi barang',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Baru', label: Text('Baru')),
                ButtonSegment(
                  value: 'Seperti Baru',
                  label: Text('Seperti Baru'),
                ),
                ButtonSegment(value: 'Bekas', label: Text('Bekas')),
              ],
              selected: {_selectedKondisi},
              showSelectedIcon: false,
              onSelectionChanged: (value) {
                setState(() => _selectedKondisi = value.first);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hargaController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Harga (Rp)', hint: 'Contoh: 75000'),
              validator: (value) {
                final harga = int.tryParse(value?.trim() ?? '');
                if (harga == null || harga <= 0) {
                  return 'Masukkan harga berupa angka lebih dari 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _deskripsiController,
              minLines: 3,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: _inputDecoration(
                'Deskripsi',
                hint: 'Jelaskan kondisi dan informasi barang...',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Deskripsi wajib diisi';
                }
                if (value.trim().length < 10) {
                  return 'Deskripsi minimal 10 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Harga bisa dinegosiasikan'),
              subtitle: const Text('Aktifkan jika pembeli boleh menawar.'),
              value: _bisaNego,
              onChanged: (value) => setState(() => _bisaNego = value),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _simpanBarang,
              icon: const Icon(Icons.check),
              label: const Text('Simpan Barang'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
