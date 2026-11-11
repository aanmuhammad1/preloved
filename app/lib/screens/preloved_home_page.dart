import 'package:flutter/material.dart';

import '../utils/barang_image.dart';
import '../models/barang.dart';
import '../services/barang_service.dart';
import 'barang_detail_page.dart';
import 'tambah_barang_page.dart';

class PrelovedHomePage extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const PrelovedHomePage({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  @override
  State<PrelovedHomePage> createState() => _PrelovedHomePageState();
}

class _PrelovedHomePageState extends State<PrelovedHomePage> {
  int _selectedIndex = 0;

  final BarangService _barangService = BarangService();

  late Future<List<Barang>> _futureBarang;

  // ID barang yang disimpan sebagai favorit selama aplikasi berjalan.
  final Set<String> _favoriteIds = {};

  // Barang yang ditambahkan pengguna disimpan sementara di memori aplikasi.
  final List<Barang> _localBarang = [];

  final List<String> _categories = [
    'Buku',
    'Elektronik',
    'Perlengkapan Kuliah',
    'Perabot Kos',
    'Lainnya',
  ];

  String _selectedCategory = 'Buku';
  String _selectedPrice = 'Semua';

  late Future<List<Barang>> _futureKategori;

  @override
  void initState() {
    super.initState();
    _futureBarang = _barangService.fetchBarang();
    _futureKategori = _barangService.fetchBarangByKategori(_selectedCategory);
  }

  Future<void> _openTambahBarang() async {
    final barangBaru = await Navigator.push<Barang>(
      context,
      MaterialPageRoute(builder: (context) => const TambahBarangPage()),
    );

    if (!mounted || barangBaru == null) return;

    setState(() {
      _localBarang.insert(0, barangBaru);
      _selectedIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barang berhasil ditambahkan.')),
    );
  }

  void _retry() {
    setState(() {
      _futureBarang = _barangService.fetchBarang();
    });
  }

  Future<void> _refreshBarang() async {
    final request = _barangService.fetchBarang();
    setState(() {
      _futureBarang = request;
    });
    try {
      await request;
    } catch (_) {
      // Error ditampilkan oleh FutureBuilder agar pengguna dapat mencoba lagi.
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomePage(),
          _buildCategoryPage(),
          _buildFavoritesPage(),
          _buildProfilePage(),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Kategori',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(Barang barang) {
    setState(() {
      if (_favoriteIds.contains(barang.id)) {
        _favoriteIds.remove(barang.id);
      } else {
        _favoriteIds.add(barang.id);
      }
    });
  }

  Widget _buildProfilePage() {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          Text(
            'Profil',
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Informasi akun dan aplikasi.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: colorScheme.surface,
                  child: Icon(
                    Icons.person,
                    size: 36,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mahasiswa Preloved',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pengguna aplikasi',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Akun Saya',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerLow,
            child: ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text('Barang Saya'),
              subtitle: const Text('Kelola barang yang kamu tawarkan'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur Barang Saya belum tersedia.'),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Informasi',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerLow,
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang Preloved'),
              subtitle: const Text('Informasi aplikasi'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Preloved',
                  applicationVersion: '1.0.0',
                  applicationIcon: Icon(
                    Icons.shopping_bag_outlined,
                    color: colorScheme.primary,
                    size: 36,
                  ),
                  children: const [
                    Text(
                      'Preloved adalah prototipe marketplace barang bekas '
                      'mahasiswa untuk membantu pengguna menemukan dan '
                      'menawarkan barang preloved.',
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Tampilan',
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerLow,
            child: SwitchListTile(
              secondary: Icon(
                widget.themeMode == ThemeMode.dark
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
              title: const Text('Mode Gelap'),
              subtitle: Text(
                widget.themeMode == ThemeMode.dark
                    ? 'Tema gelap sedang aktif'
                    : 'Tema terang sedang aktif',
              ),
              value: widget.themeMode == ThemeMode.dark,
              onChanged: (enabled) {
                widget.onThemeModeChanged(
                  enabled ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          Center(
            child: Text(
              'Preloved versi 1.0.0',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesPage() {
    return SafeArea(
      child: FutureBuilder<List<Barang>>(
        future: _futureBarang,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_outlined, size: 48),
                  const SizedBox(height: 12),
                  const Text('Gagal memuat barang favorit'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _retry,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final allBarang = [...(snapshot.data ?? []), ..._localBarang];
          final favoriteBarang = allBarang
              .where((barang) => _favoriteIds.contains(barang.id))
              .toList();

          if (favoriteBarang.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada barang favorit',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tekan ikon hati pada barang untuk menyimpannya di sini.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      icon: const Icon(Icons.storefront_outlined),
                      label: const Text('Jelajahi barang'),
                    ),
                  ],
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Favorit',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${favoriteBarang.length} barang tersimpan',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                sliver: SliverGrid.builder(
                  itemCount: favoriteBarang.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.70,
                  ),
                  itemBuilder: (context, index) {
                    return _buildProductCard(
                      favoriteBarang[index],
                      sourceTag: 'favorites',
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryPage() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kategori',
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'Temukan barang sesuai kebutuhanmu.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          // Pilihan kategori
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _categories.map((category) {
                final selected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (value) {
                      if (value) {
                        setState(() {
                          _selectedCategory = category;
                          _selectedPrice = 'Semua';
                          _futureKategori = _barangService
                              .fetchBarangByKategori(category);
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Filter harga
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Filter Harga',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _priceChip('Semua'),
                _priceChip('< Rp50rb'),
                _priceChip('Rp50rb–200rb'),
                _priceChip('> Rp200rb'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Judul hasil kategori
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Barang $_selectedCategory',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),

          // Data dari REST API
          Expanded(
            child: FutureBuilder<List<Barang>>(
              future: _futureKategori,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 48),
                        const SizedBox(height: 12),
                        const Text('Gagal memuat kategori'),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              _futureKategori = _barangService
                                  .fetchBarangByKategori(_selectedCategory);
                            });
                          },
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                final barangList = [
                  ...(snapshot.data ?? []),
                  ..._localBarang.where(
                    (barang) => barang.kategori == _selectedCategory,
                  ),
                ];

                // Filter harga
                final filteredBarang = barangList.where((barang) {
                  switch (_selectedPrice) {
                    case '< Rp50rb':
                      return barang.harga < 50000;
                    case 'Rp50rb–200rb':
                      return barang.harga >= 50000 && barang.harga <= 200000;
                    case '> Rp200rb':
                      return barang.harga > 200000;
                    default:
                      return true;
                  }
                }).toList();

                if (filteredBarang.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada barang yang sesuai.'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  itemCount: filteredBarang.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.70,
                  ),
                  itemBuilder: (context, index) {
                    return _buildProductCard(
                      filteredBarang[index],
                      sourceTag: 'category',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceChip(String price) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(price),
        selected: _selectedPrice == price,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedPrice = price;
            });
          }
        },
      ),
    );
  }

  Widget _buildHomePage() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshBarang,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Preloved',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Temukan barang yang kamu butuhkan.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        IconButton.filledTonal(
                          tooltip: 'Tambah barang',
                          onPressed: _openTambahBarang,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Search bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari barang preloved...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerLow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Barang Terbaru',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${12 + _localBarang.length} barang',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Product grid from REST API
            FutureBuilder<List<Barang>>(
              future: _futureBarang,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.cloud_off_outlined, size: 48),
                          const SizedBox(height: 12),
                          const Text('Gagal memuat barang'),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: _retry,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final barangList = [..._localBarang, ...(snapshot.data ?? [])];

                if (barangList.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('Belum ada barang tersedia')),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  sliver: SliverGrid.builder(
                    itemCount: barangList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.70,
                        ),
                    itemBuilder: (context, index) {
                      return _buildProductCard(
                        barangList[index],
                        sourceTag: 'home',
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Barang barang, {required String sourceTag}) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BarangDetailPage(
                barang: barang,
                isFavorite: _favoriteIds.contains(barang.id),
                onFavoritePressed: () => _toggleFavorite(barang),
                heroTag: '$sourceTag-${barang.id}',
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image placeholder with Hero transition
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: '$sourceTag-${barang.id}',
                    child: buildBarangImage(context, barang),
                  ),

                  if (barang.bisaNego)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Nego',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  Positioned(
                    top: 6,
                    right: 6,
                    child: Material(
                      color: Theme.of(context).colorScheme.surface
                          .withValues(alpha: 0.95),
                      shape: const CircleBorder(),
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: _favoriteIds.contains(barang.id)
                            ? 'Hapus dari favorit'
                            : 'Tambahkan ke favorit',
                        onPressed: () => _toggleFavorite(barang),
                        icon: Icon(
                          _favoriteIds.contains(barang.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _favoriteIds.contains(barang.id)
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    barang.nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    _formatHarga(barang.harga),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    barang.kondisi,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
