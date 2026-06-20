import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'seruput_order_store.dart';
import 'dapur_seruput_screen.dart';

// =====================================================
// FILE: owner_seruput_screen.dart
// Login Owner dari pilih_akses_screen.dart:
// email    : owner@seruput.com
// password : owner123
//
// Fitur UI Owner:
// 1. Dashboard ringkasan bisnis.
// 2. Laporan penjualan harian/mingguan/bulanan/kustom.
// 3. Kelola menu dengan status tersedia/nonaktif.
// 4. Monitor operasional kasir, dapur, dan meja aktif.
// 5. Halaman akun Owner + tombol keluar.
//
// Catatan:
// Data masih lokal/demo dari SeruputOrderStore.
// Jika mau real-time antar HP, hubungkan store ini ke Firebase/Supabase/backend.
// =====================================================

class OwnerSeruputScreen extends StatefulWidget {
  const OwnerSeruputScreen({super.key});

  @override
  State<OwnerSeruputScreen> createState() => _OwnerSeruputScreenState();
}

class _OwnerSeruputScreenState extends State<OwnerSeruputScreen> {
  int selectedIndex = 0;
  String selectedReport = 'Harian';
  String selectedMenuCategory = 'Semua';
  DateTime selectedDate = DateTime.now();
  final TextEditingController searchController = TextEditingController();
  String menuSearch = '';

  late List<_OwnerMenuEntry> menus;

  @override
  void initState() {
    super.initState();
    menus = _OwnerMenuEntry.demoMenus();
    searchController.addListener(() {
      setState(() => menuSearch = searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String get _pageTitle {
    switch (selectedIndex) {
      case 1:
        return 'Laporan Penjualan';
      case 2:
        return 'Kelola Menu';
      case 3:
        return 'Monitor Operasional';
      case 4:
        return 'Akun Owner';
      default:
        return 'Halo, Owner 👋';
    }
  }

  String get _pageSubtitle {
    switch (selectedIndex) {
      case 1:
        return 'Analisis omzet, metode bayar, dan menu terlaris.';
      case 2:
        return 'Atur daftar menu, harga, dan ketersediaan produk.';
      case 3:
        return 'Pantau alur pesanan dari kasir sampai dapur.';
      case 4:
        return 'Profil akses dan keamanan akun owner.';
      default:
        return 'Berikut ringkasan bisnismu hari ini.';
    }
  }


  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: seruputNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: seruputNavy,
              onPrimary: Colors.white,
              onSurface: seruputNavy,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
      _showMessage('Tanggal diganti ke ${_dateLabel(picked)}.');
    }
  }

  int _notificationCount(List<KasirOrder> orders) {
    final waiting = orders.where((order) => order.status == KasirOrderStatus.menunggu).length;
    final kitchen = orders.where((order) => order.status == KasirOrderStatus.diproses).length;
    final inactive = menus.where((menu) => !menu.isAvailable).length;
    return waiting + kitchen + inactive;
  }

  void _openNotifications(List<KasirOrder> orders) {
    final waiting = orders.where((order) => order.status == KasirOrderStatus.menunggu).length;
    final kitchen = orders.where((order) => order.status == KasirOrderStatus.diproses).length;
    final inactive = menus.where((menu) => !menu.isAvailable).length;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _OwnerSheet(
          title: 'Notifikasi Owner',
          child: Column(
            children: [
              _NotificationTile(
                icon: Icons.point_of_sale_rounded,
                title: '$waiting pesanan menunggu kasir',
                subtitle: waiting == 0 ? 'Tidak ada antrian kasir.' : 'Ada customer yang perlu dikonfirmasi pembayarannya.',
                color: const Color(0xFFEDE9FF),
              ),
              const SizedBox(height: 10),
              _NotificationTile(
                icon: Icons.soup_kitchen_rounded,
                title: '$kitchen pesanan di dapur',
                subtitle: kitchen == 0 ? 'Belum ada pesanan diproses dapur.' : 'Pantau apakah pesanan sudah diterima dan dibuat.',
                color: const Color(0xFFFFF4D9),
              ),
              const SizedBox(height: 10),
              _NotificationTile(
                icon: Icons.block_rounded,
                title: '$inactive menu nonaktif',
                subtitle: inactive == 0 ? 'Semua menu sedang tersedia.' : 'Ada menu yang sedang dimatikan karena stok kosong.',
                color: const Color(0xFFFFEEEE),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: seruputNavy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openMenuForm({_OwnerMenuEntry? menu}) {
    final isEdit = menu != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: menu?.name ?? '');
    final priceController = TextEditingController(text: menu == null ? '' : menu.price.toString());
    final imageController = TextEditingController(text: menu?.imagePath ?? '');
    String category = menu?.category ?? 'Minuman';
    bool isAvailable = menu?.isAvailable ?? true;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return _OwnerSheet(
              title: isEdit ? 'Edit Menu' : 'Tambah Menu',
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    _OwnerFormField(
                      controller: nameController,
                      label: 'Nama menu',
                      hint: 'Contoh: Es Kopi Susu',
                      icon: Icons.restaurant_menu_rounded,
                      validator: (value) => value == null || value.trim().isEmpty ? 'Nama menu wajib diisi.' : null,
                    ),
                    const SizedBox(height: 12),
                    _OwnerFormField(
                      controller: priceController,
                      label: 'Harga',
                      hint: 'Contoh: 20000',
                      icon: Icons.payments_outlined,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final price = int.tryParse((value ?? '').trim());
                        if (price == null || price <= 0) return 'Harga harus angka lebih dari 0.';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: _ownerInputDecoration('Kategori', Icons.category_outlined),
                      items: const ['Minuman', 'Makanan', 'Dessert']
                          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) modalSetState(() => category = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    _OwnerFormField(
                      controller: imageController,
                      label: 'Path gambar',
                      hint: 'Boleh kosong, nanti pakai default',
                      icon: Icons.image_outlined,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: seruputCream,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: seruputNavy.withOpacity(0.10)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.inventory_2_outlined, color: seruputNavy),
                          const SizedBox(width: 10),
                          const Expanded(child: Text('Menu tersedia?', style: TextStyle(color: seruputNavy, fontWeight: FontWeight.w900))),
                          Switch.adaptive(
                            value: isAvailable,
                            activeColor: seruputNavy,
                            onChanged: (value) => modalSetState(() => isAvailable = value),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: seruputNavy,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;

                          final entry = _OwnerMenuEntry(
                            name: nameController.text.trim(),
                            price: int.parse(priceController.text.trim()),
                            category: category,
                            imagePath: imageController.text.trim().isEmpty ? _defaultMenuImage(category) : imageController.text.trim(),
                            isAvailable: isAvailable,
                          );

                          setState(() {
                            if (isEdit) {
                              final index = menus.indexWhere((item) => item.name == menu.name && item.category == menu.category);
                              if (index != -1) menus[index] = entry;
                            } else {
                              menus = [entry, ...menus];
                            }
                          });

                          Navigator.pop(sheetContext);
                          _showMessage(isEdit ? 'Menu berhasil diedit.' : 'Menu berhasil ditambahkan.');
                        },
                        icon: Icon(isEdit ? Icons.save_rounded : Icons.add_rounded),
                        label: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Menu', style: const TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      nameController.dispose();
      priceController.dispose();
      imageController.dispose();
    });
  }

  void _confirmDeleteMenu(_OwnerMenuEntry menu) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Hapus menu?', style: GoogleFonts.montserratAlternates(color: seruputNavy, fontWeight: FontWeight.w900)),
          content: Text('Menu ${menu.name} akan dihapus dari daftar menu.', style: TextStyle(color: seruputNavy.withOpacity(0.72), fontWeight: FontWeight.w700)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: seruputNavy, fontWeight: FontWeight.w900)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                setState(() => menus.removeWhere((item) => item.name == menu.name && item.category == menu.category));
                Navigator.pop(context);
                _showMessage('Menu ${menu.name} berhasil dihapus.');
              },
              child: const Text('Hapus', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        );
      },
    );
  }

  void _toggleMenu(_OwnerMenuEntry menu) {
    setState(() {
      final index = menus.indexWhere((item) => item.name == menu.name && item.category == menu.category);
      if (index != -1) {
        menus[index] = menus[index].copyWith(isAvailable: !menus[index].isAvailable);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: seruputCream,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: ValueListenableBuilder<List<KasirOrder>>(
        valueListenable: SeruputOrderStore.orders,
        builder: (context, orders, child) {
          return Scaffold(
            backgroundColor: seruputCream,
            body: SafeArea(
              child: Column(
                children: [
                  _OwnerHeader(
                    title: _pageTitle,
                    subtitle: _pageSubtitle,
                    notificationCount: _notificationCount(orders),
                    onLogout: () => Navigator.pop(context),
                    onNotificationTap: () => _openNotifications(orders),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      child: KeyedSubtree(
                        key: ValueKey(selectedIndex),
                        child: _buildPage(orders),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _OwnerBottomNav(
              selectedIndex: selectedIndex,
              onChanged: (index) => setState(() => selectedIndex = index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(List<KasirOrder> orders) {
    switch (selectedIndex) {
      case 1:
        return _ReportPage(
          orders: orders,
          menus: menus,
          selectedReport: selectedReport,
          selectedDate: selectedDate,
          onReportChanged: (value) => setState(() => selectedReport = value),
          onPickDate: _pickDate,
        );
      case 2:
        return _MenuManagementPage(
          menus: menus,
          searchController: searchController,
          selectedCategory: selectedMenuCategory,
          onCategoryChanged: (value) => setState(() => selectedMenuCategory = value),
          onToggle: _toggleMenu,
          onAdd: () => _openMenuForm(),
          onEdit: (menu) => _openMenuForm(menu: menu),
          onDelete: _confirmDeleteMenu,
          searchQuery: menuSearch,
        );
      case 3:
        return _OperationalPage(orders: orders);
      case 4:
        return _AccountPage(totalMenus: menus.length, activeMenus: menus.where((menu) => menu.isAvailable).length);
      default:
        return _DashboardPage(orders: orders, menus: menus, selectedDate: selectedDate, onPickDate: _pickDate, onOpenReport: () => setState(() => selectedIndex = 1));
    }
  }
}

class _OwnerHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final int notificationCount;
  final VoidCallback onLogout;
  final VoidCallback onNotificationTap;

  const _OwnerHeader({
    required this.title,
    required this.subtitle,
    required this.notificationCount,
    required this.onLogout,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Keluar',
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded, color: seruputNavy, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserratAlternates(
                    color: seruputNavy,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: seruputNavy.withOpacity(0.62),
                    fontSize: 11.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                tooltip: 'Notifikasi Owner',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  fixedSize: const Size(43, 43),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: seruputNavy.withOpacity(0.08)),
                  ),
                ),
                onPressed: onNotificationTap,
                icon: const Icon(Icons.notifications_none_rounded, color: seruputNavy, size: 22),
              ),
              if (notificationCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(color: Color(0xFFFF6B6B), shape: BoxShape.circle),
                    child: Text('$notificationCount', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  final List<KasirOrder> orders;
  final List<_OwnerMenuEntry> menus;
  final DateTime selectedDate;
  final VoidCallback onPickDate;
  final VoidCallback onOpenReport;

  const _DashboardPage({
    required this.orders,
    required this.menus,
    required this.selectedDate,
    required this.onPickDate,
    required this.onOpenReport,
  });

  @override
  Widget build(BuildContext context) {
    final completed = orders.where((order) => order.status == KasirOrderStatus.selesai && _isSameDay(order.createdAt, selectedDate)).toList();
    final activeOrders = orders.where((order) => order.status != KasirOrderStatus.selesai).toList();
    final todaySales = _sumOrders(completed);
    final topMenu = _topMenuName(orders);
    final weekly = _weeklyBars(orders.where((order) => order.status == KasirOrderStatus.selesai).toList());

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DatePill(label: _dateLabel(selectedDate), onTap: onPickDate),
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.18,
            children: [
              _OwnerMetricCard(
                title: 'Omset Hari Ini',
                value: formatRupiah(todaySales),
                trend: '+16.4% vs kemarin',
                icon: Icons.payments_rounded,
                imagePath: 'assets/images/akses_owner.png',
              ),
              _OwnerMetricCard(
                title: 'Transaksi',
                value: '${completed.length}',
                trend: '+12.5% vs kemarin',
                icon: Icons.point_of_sale_rounded,
              ),
              _OwnerMetricCard(
                title: 'Pesanan Aktif',
                value: '${activeOrders.length}',
                trend: activeOrders.isEmpty ? 'Tidak ada antrean' : 'Lagi diproses',
                icon: Icons.receipt_long_rounded,
              ),
              _OwnerMetricCard(
                title: 'Menu Terlaris',
                value: topMenu,
                trend: '${_topMenuQty(orders)} terjual',
                icon: Icons.local_cafe_rounded,
                compactValue: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _OwnerSectionCard(
            title: 'Ringkasan Omset 7 Hari Terakhir',
            actionText: 'Detail',
            onAction: onOpenReport,
            child: _WeeklyBarChart(data: weekly),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _SmallInfoCard(title: 'Menu Aktif', value: '${menus.where((m) => m.isAvailable).length}', icon: Icons.restaurant_menu_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _SmallInfoCard(title: 'Meja Aktif', value: '${_activeTableCount(orders)}', icon: Icons.table_restaurant_rounded)),
            ],
          ),
          const SizedBox(height: 16),
          _RecentOrdersCard(orders: orders.take(4).toList()),
        ],
      ),
    );
  }
}

class _ReportPage extends StatelessWidget {
  final List<KasirOrder> orders;
  final List<_OwnerMenuEntry> menus;
  final String selectedReport;
  final DateTime selectedDate;
  final ValueChanged<String> onReportChanged;
  final VoidCallback onPickDate;

  const _ReportPage({
    required this.orders,
    required this.menus,
    required this.selectedReport,
    required this.selectedDate,
    required this.onReportChanged,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    final reportOrders = _filterOrdersByReport(orders, selectedReport, selectedDate);
    final completed = reportOrders.where((order) => order.status == KasirOrderStatus.selesai).toList();
    final totalOmzet = _sumOrders(completed);
    final paymentSummary = _paymentSummary(reportOrders);
    final categorySummary = _categorySummary(reportOrders, menus);
    final topMenus = _topMenus(reportOrders, limit: 5);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SegmentedTabs(
            values: const ['Harian', 'Mingguan', 'Bulanan', 'Kustom'],
            selected: selectedReport,
            onChanged: onReportChanged,
          ),
          const SizedBox(height: 12),
          _DatePill(label: _dateLabel(selectedDate), trailingIcon: Icons.calendar_month_rounded, onTap: onPickDate),
          const SizedBox(height: 14),
          _OwnerSectionCard(
            title: 'Total Omset',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        formatRupiah(totalOmzet),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserratAlternates(
                          color: seruputNavy,
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const _TrendBadge(text: '+16.4%'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: paymentSummary.map((item) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: item == paymentSummary.last ? 0 : 8),
                        child: _PaymentMiniCard(data: item, total: math.max(1, _sumOrders(orders))),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _OwnerSectionCard(
            title: 'Distribusi Penjualan',
            child: Row(
              children: [
                SizedBox(
                  width: 118,
                  height: 118,
                  child: CustomPaint(
                    painter: _DonutPainter(values: categorySummary.map((e) => e.value.toDouble()).toList()),
                    child: const Center(
                      child: Icon(Icons.pie_chart_rounded, color: seruputNavy, size: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    children: categorySummary.map((item) => _DistributionRow(data: item)).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _OwnerSectionCard(
            title: 'Top 5 Menu Terlaris',
            child: topMenus.isEmpty
                ? const _MiniEmpty(text: 'Belum ada menu terjual.')
                : Column(
              children: List.generate(topMenus.length, (index) {
                final item = topMenus[index];
                return _TopMenuTile(rank: index + 1, data: item);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuManagementPage extends StatelessWidget {
  final List<_OwnerMenuEntry> menus;
  final TextEditingController searchController;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<_OwnerMenuEntry> onToggle;
  final VoidCallback onAdd;
  final ValueChanged<_OwnerMenuEntry> onEdit;
  final ValueChanged<_OwnerMenuEntry> onDelete;
  final String searchQuery;

  const _MenuManagementPage({
    required this.menus,
    required this.searchController,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onToggle,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = menus.where((menu) {
      final matchCategory = selectedCategory == 'Semua' || menu.category == selectedCategory;
      final matchSearch = searchQuery.isEmpty || menu.name.toLowerCase().contains(searchQuery);
      return matchCategory && matchSearch;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: seruputNavy, fontWeight: FontWeight.w700, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Cari menu...',
                    hintStyle: TextStyle(color: seruputNavy.withOpacity(0.42), fontWeight: FontWeight.w600, fontSize: 12),
                    prefixIcon: const Icon(Icons.search_rounded, color: seruputNavy, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: seruputNavy.withOpacity(0.10))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: seruputNavy.withOpacity(0.10))),
                    focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(18)), borderSide: BorderSide(color: seruputNavy, width: 1.3)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: seruputNavy,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Tambah', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SegmentedTabs(
            values: const ['Semua', 'Minuman', 'Makanan', 'Dessert'],
            selected: selectedCategory,
            onChanged: onCategoryChanged,
          ),
          const SizedBox(height: 14),
          if (filtered.isEmpty)
            const _MiniEmpty(text: 'Menu tidak ditemukan.')
          else
            ...filtered.map((menu) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OwnerMenuTile(menu: menu, onToggle: () => onToggle(menu), onEdit: () => onEdit(menu), onDelete: () => onDelete(menu)),
            )),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: seruputSoftPurple.withOpacity(0.62),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: seruputNavy.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: seruputNavy, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tips: Nonaktifkan menu jika stok sedang habis.',
                    style: TextStyle(color: seruputNavy.withOpacity(0.72), fontSize: 11.5, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationalPage extends StatelessWidget {
  final List<KasirOrder> orders;

  const _OperationalPage({required this.orders});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, DapurProgress>>(
      valueListenable: DapurProgressStore.progress,
      builder: (context, progress, child) {
        final waitingCashier = orders.where((order) => order.status == KasirOrderStatus.menunggu).length;
        final inKitchen = orders.where((order) => order.status == KasirOrderStatus.diproses).length;
        final acceptedKitchen = orders.where((order) => order.status == KasirOrderStatus.diproses && DapurProgressStore.stage(order.id) != DapurProgress.baru).length;
        final done = orders.where((order) => order.status == KasirOrderStatus.selesai).length;
        final activeTables = orders.where((order) => order.status != KasirOrderStatus.selesai).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OwnerSectionCard(
                title: 'Alur Pesanan Aktif',
                badgeText: '${orders.length}',
                child: Column(
                  children: [
                    _FlowStepTile(
                      icon: Icons.point_of_sale_rounded,
                      title: 'Menunggu Kasir',
                      subtitle: 'Pesanan baru dari customer',
                      count: waitingCashier,
                      color: const Color(0xFFE9E7FF),
                    ),
                    _FlowConnector(color: const Color(0xFFFFC86B)),
                    _FlowStepTile(
                      icon: Icons.soup_kitchen_rounded,
                      title: 'Masuk Dapur',
                      subtitle: 'Siap untuk disiapkan',
                      count: inKitchen,
                      color: const Color(0xFFFFF4D9),
                    ),
                    _FlowConnector(color: const Color(0xFF8EA4FF)),
                    _FlowStepTile(
                      icon: Icons.restaurant_rounded,
                      title: 'Lagi Dibuat',
                      subtitle: 'Sedang dalam proses',
                      count: acceptedKitchen,
                      color: const Color(0xFFE9F0FF),
                    ),
                    _FlowConnector(color: const Color(0xFF7BCB8E)),
                    _FlowStepTile(
                      icon: Icons.check_circle_rounded,
                      title: 'Siap Diseruput',
                      subtitle: 'Siap diambil/diantar',
                      count: done,
                      color: const Color(0xFFE9F9EE),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _OwnerSectionCard(
                title: 'Meja Aktif',
                actionText: 'Lihat semua',
                child: activeTables.isEmpty
                    ? const _MiniEmpty(text: 'Belum ada meja aktif.')
                    : Column(
                  children: activeTables.take(8).map((order) => _ActiveTableTile(order: order)).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AccountPage extends StatelessWidget {
  final int totalMenus;
  final int activeMenus;

  const _AccountPage({required this.totalMenus, required this.activeMenus});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: seruputNavy.withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 10))],
            ),
            child: Column(
              children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: seruputSoftPurple.withOpacity(0.75),
                    shape: BoxShape.circle,
                    border: Border.all(color: seruputNavy.withOpacity(0.08)),
                  ),
                  child: const Icon(Icons.business_center_rounded, color: seruputNavy, size: 42),
                ),
                const SizedBox(height: 12),
                Text(
                  'Owner Seruput',
                  style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 5),
                Text(
                  'Portal pemilik bisnis Seruput Coffee',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: seruputNavy.withOpacity(0.62), fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                _CredentialBox(label: 'Email Owner', value: 'owner@seruput.com', icon: Icons.email_outlined),
                const SizedBox(height: 10),
                _CredentialBox(label: 'Kata Sandi Demo', value: 'owner123', icon: Icons.lock_outline_rounded),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _SmallInfoCard(title: 'Total Menu', value: '$totalMenus', icon: Icons.restaurant_menu_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _SmallInfoCard(title: 'Menu Aktif', value: '$activeMenus', icon: Icons.toggle_on_rounded)),
            ],
          ),
          const SizedBox(height: 16),
          _OwnerSectionCard(
            title: 'Keamanan Akses',
            child: Column(
              children: const [
                _SecurityRow(icon: Icons.verified_user_outlined, title: 'Role owner terverifikasi', subtitle: 'Hanya akun owner yang bisa membuka dashboard ini.'),
                _SecurityRow(icon: Icons.storage_rounded, title: 'Data masih demo lokal', subtitle: 'Pesanan tersimpan sementara di aplikasi.'),
                _SecurityRow(icon: Icons.cloud_queue_rounded, title: 'Siap dihubungkan ke database', subtitle: 'Gunakan Firebase/Supabase agar real-time di banyak perangkat.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: seruputNavy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text('Keluar dari Owner', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _OwnerBottomNav({required this.selectedIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = const [
      _NavItem(icon: Icons.home_rounded, label: 'Dashboard'),
      _NavItem(icon: Icons.insert_chart_outlined_rounded, label: 'Laporan'),
      _NavItem(icon: Icons.local_cafe_rounded, label: 'Menu'),
      _NavItem(icon: Icons.radar_rounded, label: 'Operasional'),
      _NavItem(icon: Icons.person_rounded, label: 'Akun'),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: seruputNavy.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, -8))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (index) {
            final selected = index == selectedIndex;
            final item = items[index];
            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    color: selected ? seruputSoftPurple.withOpacity(0.62) : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.icon, color: selected ? seruputNavy : seruputNavy.withOpacity(0.42), size: 21),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: selected ? seruputNavy : seruputNavy.withOpacity(0.45),
                          fontSize: 9.3,
                          fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}

class _OwnerSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final String? actionText;
  final VoidCallback? onAction;
  final String? badgeText;

  const _OwnerSectionCard({
    required this.title,
    required this.child,
    this.actionText,
    this.onAction,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: seruputNavy.withOpacity(0.055), blurRadius: 18, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 15.5, fontWeight: FontWeight.w900),
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: seruputSoftPurple.withOpacity(0.62), borderRadius: BorderRadius.circular(18)),
                  child: Text(badgeText!, style: const TextStyle(color: seruputNavy, fontSize: 11, fontWeight: FontWeight.w900)),
                )
              else if (actionText != null)
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(foregroundColor: seruputNavy, padding: EdgeInsets.zero, minimumSize: const Size(52, 30)),
                  child: Text(actionText!, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _OwnerMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final IconData icon;
  final String? imagePath;
  final bool compactValue;

  const _OwnerMetricCard({
    required this.title,
    required this.value,
    required this.trend,
    required this.icon,
    this.imagePath,
    this.compactValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: seruputNavy.withOpacity(0.06)),
        boxShadow: [BoxShadow(color: seruputNavy.withOpacity(0.045), blurRadius: 14, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: seruputSoftPurple.withOpacity(0.72), borderRadius: BorderRadius.circular(13)),
                child: Icon(icon, color: seruputNavy, size: 19),
              ),
              const Spacer(),
              if (imagePath != null)
                SizedBox(
                  width: 38,
                  height: 38,
                  child: Image.asset(imagePath!, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                ),
            ],
          ),
          const Spacer(),
          Text(title, style: TextStyle(color: seruputNavy.withOpacity(0.62), fontSize: 11, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: compactValue ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: seruputNavy, fontSize: compactValue ? 15.5 : 17, fontWeight: FontWeight.w900, height: 1.05),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Icon(Icons.arrow_upward_rounded, color: seruputGreen, size: 14),
              const SizedBox(width: 3),
              Expanded(
                child: Text(trend, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: seruputGreen, fontSize: 10.3, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  final List<_BarData> data;

  const _WeeklyBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxValue = data.map((item) => item.value).fold<int>(1, math.max);

    return SizedBox(
      height: 132,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((item) {
          final percent = item.value / maxValue;
          final isToday = item.label == 'Hari Ini';
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  width: 18,
                  height: 22 + (72 * percent),
                  decoration: BoxDecoration(
                    color: isToday ? seruputNavy : seruputSoftPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: seruputNavy.withOpacity(0.62), fontSize: 9.8, fontWeight: FontWeight.w800)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  final String label;
  final IconData trailingIcon;
  final VoidCallback? onTap;

  const _DatePill({required this.label, this.trailingIcon = Icons.calendar_today_rounded, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: seruputNavy.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Expanded(child: Text(label, textAlign: TextAlign.center, style: const TextStyle(color: seruputNavy, fontSize: 12.5, fontWeight: FontWeight.w900))),
              Icon(trailingIcon, color: seruputNavy, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  final List<String> values;
  final String selected;
  final ValueChanged<String> onChanged;

  const _SegmentedTabs({required this.values, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: values.map((value) {
          final isSelected = value == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => onChanged(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? seruputNavy : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: seruputNavy.withOpacity(0.10)),
                ),
                child: Text(
                  value,
                  style: TextStyle(color: isSelected ? Colors.white : seruputNavy, fontSize: 11.5, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SmallInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SmallInfoCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: seruputNavy.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 8))]),
      child: Row(
        children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(color: seruputSoftPurple.withOpacity(0.65), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: seruputNavy, size: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: seruputNavy, fontSize: 18, fontWeight: FontWeight.w900)),
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: seruputNavy.withOpacity(0.58), fontSize: 10.8, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentOrdersCard extends StatelessWidget {
  final List<KasirOrder> orders;

  const _RecentOrdersCard({required this.orders});

  @override
  Widget build(BuildContext context) {
    return _OwnerSectionCard(
      title: 'Pesanan Terbaru',
      child: orders.isEmpty
          ? const _MiniEmpty(text: 'Belum ada pesanan masuk.')
          : Column(children: orders.map((order) => _OwnerOrderRow(order: order)).toList()),
    );
  }
}

class _OwnerOrderRow extends StatelessWidget {
  final KasirOrder order;

  const _OwnerOrderRow({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: statusBackground(order.status), shape: BoxShape.circle),
            child: Icon(_statusIcon(order.status), color: statusColor(order.status), size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${order.id} • Meja ${order.tableNumber.toString().padLeft(2, '0')}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: seruputNavy, fontSize: 12.8, fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text('${statusText(order)} • ${order.totalItem} item', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: seruputNavy.withOpacity(0.58), fontSize: 10.8, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Text(formatRupiah(order.totalPayment), style: const TextStyle(color: seruputNavy, fontSize: 11.5, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _PaymentMiniCard extends StatelessWidget {
  final _SummaryData data;
  final int total;

  const _PaymentMiniCard({required this.data, required this.total});

  @override
  Widget build(BuildContext context) {
    final percent = ((data.value / total) * 100).clamp(0, 100).toStringAsFixed(1);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: seruputCream, borderRadius: BorderRadius.circular(17), border: Border.all(color: seruputNavy.withOpacity(0.06))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: seruputNavy, size: 18),
          const SizedBox(height: 7),
          Text(data.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: seruputNavy, fontSize: 10.5, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(formatRupiah(data.value), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: seruputNavy.withOpacity(0.68), fontSize: 9.8, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text('$percent%', style: TextStyle(color: seruputNavy.withOpacity(0.55), fontSize: 9.5, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _DistributionRow extends StatelessWidget {
  final _SummaryData data;

  const _DistributionRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(width: 9, height: 9, decoration: BoxDecoration(color: data.color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(data.title, style: const TextStyle(color: seruputNavy, fontSize: 12, fontWeight: FontWeight.w900))),
          Text(formatRupiah(data.value), style: TextStyle(color: seruputNavy.withOpacity(0.58), fontSize: 10.5, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _TopMenuTile extends StatelessWidget {
  final int rank;
  final _TopMenuData data;

  const _TopMenuTile({required this.rank, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(width: 22, child: Text('$rank', style: TextStyle(color: seruputNavy.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w900))),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(data.imagePath, width: 36, height: 36, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 36, height: 36, color: seruputCream, child: const Icon(Icons.local_cafe_rounded, color: seruputNavy, size: 18))),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(data.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: seruputNavy, fontSize: 12.5, fontWeight: FontWeight.w900))),
          Text('${data.quantity}', style: TextStyle(color: seruputNavy.withOpacity(0.62), fontSize: 11.3, fontWeight: FontWeight.w800)),
          const SizedBox(width: 14),
          Text(formatRupiah(data.total), style: const TextStyle(color: seruputNavy, fontSize: 11.5, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _OwnerMenuTile extends StatelessWidget {
  final _OwnerMenuEntry menu;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _OwnerMenuTile({required this.menu, required this.onToggle, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: seruputNavy.withOpacity(0.048), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              menu.imagePath,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: seruputCream, child: const Icon(Icons.local_cafe_rounded, color: seruputNavy)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(menu.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: seruputNavy, fontSize: 13.5, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(formatRupiah(menu.price), style: TextStyle(color: seruputNavy.withOpacity(0.68), fontSize: 11.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(menu.isAvailable ? Icons.arrow_upward_rounded : Icons.block_rounded, color: menu.isAvailable ? seruputGreen : const Color(0xFFFF6B6B), size: 14),
                    const SizedBox(width: 3),
                    Text(menu.isAvailable ? 'Tersedia' : 'Nonaktif', style: TextStyle(color: menu.isAvailable ? seruputGreen : const Color(0xFFFF6B6B), fontSize: 10.5, fontWeight: FontWeight.w900)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    InkWell(onTap: onEdit, child: _MenuAction(icon: Icons.edit_outlined, label: 'Edit')),
                    const SizedBox(width: 12),
                    InkWell(onTap: onDelete, child: const _MenuAction(icon: Icons.delete_outline_rounded, label: 'Hapus', danger: true)),
                  ],
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: menu.isAvailable,
            activeColor: seruputNavy,
            onChanged: (_) => onToggle(),
          ),
        ],
      ),
    );
  }
}

class _MenuAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool danger;

  const _MenuAction({required this.icon, required this.label, this.danger = false});

  @override
  Widget build(BuildContext context) {
    final color = danger ? const Color(0xFFFF6B6B) : seruputNavy;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _FlowStepTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int count;
  final Color color;

  const _FlowStepTile({required this.icon, required this.title, required this.subtitle, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 46, height: 46, decoration: BoxDecoration(color: color, shape: BoxShape.circle), child: Icon(icon, color: seruputNavy, size: 22)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: seruputNavy, fontSize: 13, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(subtitle, style: TextStyle(color: seruputNavy.withOpacity(0.58), fontSize: 11, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: color.withOpacity(0.82), borderRadius: BorderRadius.circular(16)),
          child: Center(child: Text('$count', style: const TextStyle(color: seruputNavy, fontSize: 16, fontWeight: FontWeight.w900))),
        ),
      ],
    );
  }
}

class _FlowConnector extends StatelessWidget {
  final Color color;

  const _FlowConnector({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22),
      child: Container(width: 2, height: 22, color: color.withOpacity(0.72)),
    );
  }
}

class _ActiveTableTile extends StatelessWidget {
  final KasirOrder order;

  const _ActiveTableTile({required this.order});

  @override
  Widget build(BuildContext context) {
    final minutes = DateTime.now().difference(order.createdAt).inMinutes.clamp(1, 999);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: seruputCream, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.table_bar_rounded, color: seruputNavy, size: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Meja ${order.tableNumber.toString().padLeft(2, '0')}', style: const TextStyle(color: seruputNavy, fontSize: 12.5, fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text('${order.totalItem} item • $minutes menit • ${statusText(order)}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: seruputNavy.withOpacity(0.58), fontSize: 10.8, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: statusBackground(order.status), borderRadius: BorderRadius.circular(16)),
            child: Text('${order.totalItem} pesanan', style: TextStyle(color: statusColor(order.status), fontSize: 10.5, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

class _CredentialBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _CredentialBox({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: seruputCream, borderRadius: BorderRadius.circular(18), border: Border.all(color: seruputNavy.withOpacity(0.08))),
      child: Row(
        children: [
          Icon(icon, color: seruputNavy, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: seruputNavy.withOpacity(0.55), fontSize: 10.8, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(value, style: const TextStyle(color: seruputNavy, fontSize: 12.5, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SecurityRow({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: seruputSoftPurple.withOpacity(0.62), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: seruputNavy, size: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: seruputNavy, fontSize: 12.5, fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(subtitle, style: TextStyle(color: seruputNavy.withOpacity(0.58), fontSize: 10.8, height: 1.25, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniEmpty extends StatelessWidget {
  final String text;

  const _MiniEmpty({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: seruputCream, borderRadius: BorderRadius.circular(18)),
      child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: seruputNavy.withOpacity(0.58), fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  final String text;

  const _TrendBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(color: seruputGreenSoft, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_upward_rounded, color: seruputGreen, size: 13),
          const SizedBox(width: 2),
          Text(text, style: const TextStyle(color: seruputGreen, fontSize: 10.5, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> values;

  const _DonutPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (sum, value) => sum + value);
    final colors = const [seruputNavy, Color(0xFF5CC0A8), Color(0xFFFFC857), Color(0xFFFF8A8A)];
    final rect = Offset.zero & size;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    double start = -math.pi / 2;
    if (total <= 0) {
      stroke.color = seruputSoftPurple;
      canvas.drawArc(rect.deflate(12), start, math.pi * 2, false, stroke);
      return;
    }

    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * math.pi * 2;
      stroke.color = colors[i % colors.length];
      canvas.drawArc(rect.deflate(12), start, math.max(0.05, sweep - 0.05), false, stroke);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => oldDelegate.values != values;
}


class _OwnerSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const _OwnerSheet({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(color: seruputNavy.withOpacity(0.15), borderRadius: BorderRadius.circular(99)),
                  ),
                ),
                const SizedBox(height: 14),
                Text(title, style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 14),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _NotificationTile({required this.icon, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: seruputCream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: seruputNavy.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: seruputNavy, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: seruputNavy, fontSize: 13, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: seruputNavy.withOpacity(0.62), fontSize: 11.5, height: 1.3, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _OwnerFormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: seruputNavy, fontSize: 13, fontWeight: FontWeight.w800),
      decoration: _ownerInputDecoration(label, icon).copyWith(hintText: hint),
    );
  }
}

InputDecoration _ownerInputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: seruputNavy.withOpacity(0.62), fontWeight: FontWeight.w800),
    hintStyle: TextStyle(color: seruputNavy.withOpacity(0.38), fontWeight: FontWeight.w700),
    prefixIcon: Icon(icon, color: seruputNavy, size: 21),
    filled: true,
    fillColor: seruputCream,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: seruputNavy.withOpacity(0.10))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: seruputNavy.withOpacity(0.10))),
    focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(18)), borderSide: BorderSide(color: seruputNavy, width: 1.3)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Color(0xFFFF6B6B))),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.3)),
  );
}

class _OwnerMenuEntry {
  final String name;
  final int price;
  final String category;
  final String imagePath;
  final bool isAvailable;

  const _OwnerMenuEntry({
    required this.name,
    required this.price,
    required this.category,
    required this.imagePath,
    required this.isAvailable,
  });

  _OwnerMenuEntry copyWith({bool? isAvailable}) {
    return _OwnerMenuEntry(
      name: name,
      price: price,
      category: category,
      imagePath: imagePath,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  static List<_OwnerMenuEntry> demoMenus() {
    return const [
      _OwnerMenuEntry(name: 'Cappuccino', price: 20000, category: 'Minuman', imagePath: 'assets/images/menu_cappuccino.png', isAvailable: true),
      _OwnerMenuEntry(name: 'Kopi Hitam', price: 10000, category: 'Minuman', imagePath: 'assets/images/menu_kopi_hitam.png', isAvailable: true),
      _OwnerMenuEntry(name: 'Sparkling Tea', price: 15000, category: 'Minuman', imagePath: 'assets/images/menu_sparkling_tea.png', isAvailable: true),
      _OwnerMenuEntry(name: 'Matcha Latte', price: 22000, category: 'Minuman', imagePath: 'assets/images/menu_matcha_latte.png', isAvailable: true),
      _OwnerMenuEntry(name: 'Batagor Bandung', price: 25000, category: 'Makanan', imagePath: 'assets/images/menu_batagor.png', isAvailable: true),
      _OwnerMenuEntry(name: 'Chicken Katsu', price: 28000, category: 'Makanan', imagePath: 'assets/images/menu_chicken_katsu.png', isAvailable: true),
      _OwnerMenuEntry(name: 'Nasi Goreng', price: 23000, category: 'Makanan', imagePath: 'assets/images/menu_nasi_goreng.png', isAvailable: true),
      _OwnerMenuEntry(name: 'French Fries', price: 16000, category: 'Makanan', imagePath: 'assets/images/menu_french_fries.png', isAvailable: true),
      _OwnerMenuEntry(name: 'Cheese Cake', price: 30000, category: 'Dessert', imagePath: 'assets/images/menu_cheesecake.png', isAvailable: true),
      _OwnerMenuEntry(name: 'Brownies', price: 18000, category: 'Dessert', imagePath: 'assets/images/menu_brownies.png', isAvailable: true),
      _OwnerMenuEntry(name: 'Pancake', price: 24000, category: 'Dessert', imagePath: 'assets/images/menu_pancake.png', isAvailable: true),
      _OwnerMenuEntry(name: 'Banana Split', price: 28000, category: 'Dessert', imagePath: 'assets/images/menu_banana_split.png', isAvailable: false),
    ];
  }
}

class _SummaryData {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const _SummaryData({required this.title, required this.value, required this.icon, required this.color});
}

class _TopMenuData {
  final String name;
  final String imagePath;
  final int quantity;
  final int total;

  const _TopMenuData({required this.name, required this.imagePath, required this.quantity, required this.total});
}

class _BarData {
  final String label;
  final int value;

  const _BarData({required this.label, required this.value});
}

int _sumOrders(List<KasirOrder> orders) {
  return orders.fold(0, (total, order) => total + order.totalPayment);
}

int _activeTableCount(List<KasirOrder> orders) {
  return orders.where((order) => order.status != KasirOrderStatus.selesai).map((order) => order.tableNumber).toSet().length;
}


String _dateLabel(DateTime date) {
  final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  final months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
  return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
}

List<KasirOrder> _filterOrdersByReport(List<KasirOrder> orders, String report, DateTime selectedDate) {
  if (report == 'Mingguan') {
    return orders.where((order) => _isSameWeek(order.createdAt, selectedDate)).toList();
  }
  if (report == 'Bulanan') {
    return orders.where((order) => order.createdAt.year == selectedDate.year && order.createdAt.month == selectedDate.month).toList();
  }
  return orders.where((order) => _isSameDay(order.createdAt, selectedDate)).toList();
}

bool _isSameWeek(DateTime a, DateTime b) {
  final startA = DateTime(a.year, a.month, a.day).subtract(Duration(days: a.weekday - 1));
  final startB = DateTime(b.year, b.month, b.day).subtract(Duration(days: b.weekday - 1));
  return _isSameDay(startA, startB);
}

String _defaultMenuImage(String category) {
  if (category == 'Makanan') return 'assets/images/menu_batagor.png';
  if (category == 'Dessert') return 'assets/images/menu_cheesecake.png';
  return 'assets/images/menu_kopi_hitam.png';
}

String _todayLabel() {
  return _dateLabel(DateTime.now());
}

IconData _statusIcon(KasirOrderStatus status) {
  switch (status) {
    case KasirOrderStatus.menunggu:
      return Icons.schedule_rounded;
    case KasirOrderStatus.diproses:
      return Icons.soup_kitchen_rounded;
    case KasirOrderStatus.selesai:
      return Icons.check_rounded;
  }
}

String _topMenuName(List<KasirOrder> orders) {
  final top = _topMenus(orders, limit: 1);
  if (top.isEmpty) return 'Belum ada';
  return top.first.name;
}

int _topMenuQty(List<KasirOrder> orders) {
  final top = _topMenus(orders, limit: 1);
  if (top.isEmpty) return 0;
  return top.first.quantity;
}

List<_TopMenuData> _topMenus(List<KasirOrder> orders, {required int limit}) {
  final Map<String, _TopMenuData> map = {};
  for (final order in orders) {
    for (final item in order.items) {
      final existing = map[item.name];
      map[item.name] = _TopMenuData(
        name: item.name,
        imagePath: item.imagePath,
        quantity: (existing?.quantity ?? 0) + item.quantity,
        total: (existing?.total ?? 0) + item.totalPrice,
      );
    }
  }
  final list = map.values.toList()..sort((a, b) => b.quantity.compareTo(a.quantity));
  return list.take(limit).toList();
}

List<_SummaryData> _paymentSummary(List<KasirOrder> orders) {
  int tunai = 0;
  int qris = 0;
  int debit = 0;

  for (final order in orders) {
    final method = order.paymentMethod.toLowerCase();
    if (method.contains('tunai')) {
      tunai += order.totalPayment;
    } else if (method.contains('qris')) {
      qris += order.totalPayment;
    } else {
      debit += order.totalPayment;
    }
  }

  return [
    _SummaryData(title: 'Tunai', value: tunai, icon: Icons.payments_outlined, color: const Color(0xFFFFC857)),
    _SummaryData(title: 'QRIS', value: qris, icon: Icons.qr_code_2_rounded, color: seruputNavy),
    _SummaryData(title: 'Debit/Kredit', value: debit, icon: Icons.credit_card_rounded, color: const Color(0xFF5CC0A8)),
  ];
}

List<_SummaryData> _categorySummary(List<KasirOrder> orders, List<_OwnerMenuEntry> menus) {
  final categoryByName = {for (final menu in menus) menu.name: menu.category};
  int minuman = 0;
  int makanan = 0;
  int dessert = 0;

  for (final order in orders) {
    for (final item in order.items) {
      final category = categoryByName[item.name] ?? 'Makanan';
      if (category == 'Minuman') {
        minuman += item.totalPrice;
      } else if (category == 'Dessert') {
        dessert += item.totalPrice;
      } else {
        makanan += item.totalPrice;
      }
    }
  }

  return [
    _SummaryData(title: 'Minuman', value: minuman, icon: Icons.local_cafe_rounded, color: seruputNavy),
    _SummaryData(title: 'Makanan', value: makanan, icon: Icons.restaurant_rounded, color: const Color(0xFF5CC0A8)),
    _SummaryData(title: 'Dessert', value: dessert, icon: Icons.cake_rounded, color: const Color(0xFFFFC857)),
  ];
}

List<_BarData> _weeklyBars(List<KasirOrder> completed) {
  final now = DateTime.now();
  final labels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Hari Ini'];
  final values = <_BarData>[];

  for (int i = 6; i >= 0; i--) {
    final day = now.subtract(Duration(days: i));
    final total = completed.where((order) => _isSameDay(order.createdAt, day)).fold<int>(0, (sum, order) => sum + order.totalPayment);
    values.add(_BarData(label: labels[6 - i], value: total));
  }

  final allZero = values.every((item) => item.value == 0);
  if (!allZero) return values;

  return const [
    _BarData(label: 'Sen', value: 420000),
    _BarData(label: 'Sel', value: 760000),
    _BarData(label: 'Rab', value: 710000),
    _BarData(label: 'Kam', value: 980000),
    _BarData(label: 'Jum', value: 690000),
    _BarData(label: 'Sab', value: 900000),
    _BarData(label: 'Hari Ini', value: 820000),
  ];
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
