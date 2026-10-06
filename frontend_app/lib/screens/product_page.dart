import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import 'profile_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<Product>> products;

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  void _refreshProducts() {
    products = ApiService.getProducts();
  }

  String _formatRupiah(double value) {
    final number = value.toStringAsFixed(0);
    final result = StringBuffer();

    for (int i = 0; i < number.length; i++) {
      if (i > 0 && (number.length - i) % 3 == 0) {
        result.write('.');
      }
      result.write(number[i]);
    }

    return 'Rp $result';
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==================== TAMBAH PRODUK ====================

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.add_box_outlined,
            size: 32,
          ),
          title: const Text('Tambah Produk'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nama Produk',
                    hintText: 'Contoh: Keyboard',
                    prefixIcon: Icon(
                      Icons.inventory_2_outlined,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Harga',
                    hintText: 'Contoh: 250000',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stok',
                    hintText: 'Contoh: 10',
                    prefixIcon: Icon(
                      Icons.numbers_outlined,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            FilledButton.icon(
              onPressed: () async {
                final name = nameController.text.trim();
                final price =
                    double.tryParse(priceController.text);
                final stock =
                    int.tryParse(stockController.text);

                if (name.isEmpty ||
                    price == null ||
                    stock == null ||
                    price < 0 ||
                    stock < 0) {
                  _showMessage(
                    'Isi semua data dengan benar',
                  );
                  return;
                }

                final success = await ApiService.addProduct(
                  name,
                  price,
                  stock,
                );

                if (!mounted) return;

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }

                if (success) {
                  setState(_refreshProducts);
                  _showMessage(
                    'Produk berhasil ditambahkan',
                  );
                } else {
                  _showMessage(
                    'Produk gagal ditambahkan',
                  );
                }
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // ==================== EDIT PRODUK ====================

  void _showEditProductDialog(Product product) {
    final nameController = TextEditingController(
      text: product.name,
    );

    final priceController = TextEditingController(
      text: product.price.toStringAsFixed(0),
    );

    final stockController = TextEditingController(
      text: product.stock.toString(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.edit_outlined,
            size: 32,
          ),
          title: const Text('Edit Produk'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nama Produk',
                    prefixIcon: Icon(
                      Icons.inventory_2_outlined,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Harga',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stok',
                    prefixIcon: Icon(
                      Icons.numbers_outlined,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            FilledButton.icon(
              onPressed: () async {
                final name = nameController.text.trim();
                final price =
                    double.tryParse(priceController.text);
                final stock =
                    int.tryParse(stockController.text);

                if (name.isEmpty ||
                    price == null ||
                    stock == null ||
                    price < 0 ||
                    stock < 0) {
                  _showMessage(
                    'Isi semua data dengan benar',
                  );
                  return;
                }

                final success =
                    await ApiService.updateProduct(
                  product.id,
                  name,
                  price,
                  stock,
                );

                if (!mounted) return;

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }

                if (success) {
                  setState(_refreshProducts);
                  _showMessage(
                    'Produk berhasil diperbarui',
                  );
                } else {
                  _showMessage(
                    'Produk gagal diperbarui',
                  );
                }
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // ==================== HAPUS PRODUK ====================

  Future<void> _confirmDelete(Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.delete_outline,
            size: 34,
          ),
          title: const Text('Hapus Produk'),
          content: Text(
            'Yakin ingin menghapus "${product.name}"?',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final success =
        await ApiService.deleteProduct(product.id);

    if (!mounted) return;

    if (success) {
      setState(_refreshProducts);
      _showMessage('Produk berhasil dihapus');
    } else {
      _showMessage('Produk gagal dihapus');
    }
  }

  // ==================== PRODUCT CARD ====================

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _formatRupiah(product.price),
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.inventory_outlined,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Stok ${product.stock}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Edit',
              onPressed: () {
                _showEditProductDialog(product);
              },
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: 'Hapus',
              onPressed: () {
                _confirmDelete(product);
              },
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context)
                    .colorScheme
                    .error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== TAMPILAN ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manajemen Produk',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Kelola data produk',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: 'Profil',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ProfilePage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.account_circle_outlined,
                size: 29,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: _showAddProductDialog,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
      ),
      body: FutureBuilder<List<Product>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 56,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Data produk tidak dapat dimuat',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Periksa koneksi lalu coba kembali.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        setState(_refreshProducts);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final productList = snapshot.data ?? [];

          if (productList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum ada produk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tambahkan produk pertama kamu.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final totalStock = productList.fold<int>(
            0,
            (total, product) =>
                total + product.stock,
          );

          return RefreshIndicator(
            onRefresh: () async {
              setState(_refreshProducts);
              await products;
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                100,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        icon:
                            Icons.inventory_2_outlined,
                        label: 'Produk',
                        value:
                            '${productList.length}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryCard(
                        icon:
                            Icons.warehouse_outlined,
                        label: 'Total Stok',
                        value: '$totalStock',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  'Daftar Produk',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...productList.map(
                  _buildProductCard,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color:
                Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}