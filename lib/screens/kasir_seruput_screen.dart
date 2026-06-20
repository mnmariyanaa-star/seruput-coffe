import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'seruput_order_store.dart';

// GANTI kalau nama/path gambar kucing kamu beda.
// Contoh: assets/images/cat_login.png atau assets/images/kucing_kasir.jpg
const String kasirCatAsset = 'assets/images/kucing_kasir.png';

// =====================================================
// FILE: kasir_seruput_screen.dart
// Fungsi file ini:
// 1. Login staf kasir.
// 2. Menampilkan antrian pembayaran/pesanan customer.
// 3. Menampilkan detail verifikasi pesanan.
// 4. Konfirmasi lunas dan kirim pesanan ke dapur.
// 5. Membaca dan mengubah pesanan dari SeruputOrderStore pusat.
//
// Catatan:
// Data pesanan sekarang dipusatkan di seruput_order_store.dart.
// Untuk real antar HP/staf, nanti ganti store tersebut ke Firebase/Firestore.
// =====================================================


// =====================================================
// 1. LOGIN KASIR - REVISI TOTAL MIRIP REFERENSI KUCING
// =====================================================

class KasirLoginScreen extends StatefulWidget {
  const KasirLoginScreen({super.key});

  @override
  State<KasirLoginScreen> createState() => _KasirLoginScreenState();
}

class _KasirLoginScreenState extends State<KasirLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: seruputNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  void _login() {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Email dan kata sandi wajib diisi.');
      return;
    }

    if (email != 'kasir@seruput.com' || password != 'kasir123') {
      _showSnack('Email atau kata sandi Kasir salah.');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const KasirQueueScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool smallScreen = size.height < 760;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: seruputCream,
        systemNavigationBarColor: seruputCream,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: seruputCream,
        body: SafeArea(
          child: Stack(
            children: [
              const _KasirLoginBackground(),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(22, smallScreen ? 6 : 12, 22, 22),
                child: Column(
                  children: [
                    _KasirCatLoginHero(compact: smallScreen),
                    Transform.translate(
                      offset: Offset(0, smallScreen ? -12 : -20),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(18, smallScreen ? 18 : 22, 18, 18),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.96),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: seruputNavy.withOpacity(0.08),
                              blurRadius: 26,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Login Staf Kasir',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserratAlternates(
                                color: seruputNavy,
                                fontSize: smallScreen ? 20 : 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Staf login terlebih dahulu\nmenggunakan akun yang terdaftar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: seruputNavy.withOpacity(0.62),
                                fontSize: 12,
                                height: 1.35,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 18),
                            _KasirTextField(
                              controller: _emailController,
                              hintText: 'Email staf',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 12),
                            _KasirTextField(
                              controller: _passwordController,
                              hintText: 'Kata sandi',
                              icon: Icons.lock_outline_rounded,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: seruputNavy,
                                  size: 20,
                                ),
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                onPressed: _login,
                                icon: const Icon(Icons.person_rounded, size: 22),
                                label: const Text(
                                  'Masuk sebagai Kasir',
                                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, smallScreen ? -4 : -10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            color: seruputNavy.withOpacity(0.48),
                            size: 17,
                          ),
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              'Akses hanya untuk staf yang berwenang',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: seruputNavy.withOpacity(0.55),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KasirCatLoginHero extends StatelessWidget {
  final bool compact;

  const _KasirCatLoginHero({required this.compact});

  @override
  Widget build(BuildContext context) {
    final heroHeight = compact ? 310.0 : 365.0;
    final catHeight = compact ? 150.0 : 190.0;

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 4,
            child: Column(
              children: [
                const Icon(Icons.local_cafe_rounded, color: seruputNavy, size: 34),
                Text(
                  'Seruput',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserratAlternates(
                    color: seruputNavy,
                    fontSize: compact ? 30 : 36,
                    fontWeight: FontWeight.w900,
                    height: 0.95,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Every sip, every story',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: seruputNavy.withOpacity(0.72),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: compact ? 92 : 104,
            left: 0,
            right: 0,
            child: Container(
              height: compact ? 210 : 246,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.72),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: seruputNavy.withOpacity(0.045)),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 16,
                    bottom: 48,
                    child: _TinyBoard(compact: compact),
                  ),
                  Positioned(
                    right: 18,
                    bottom: 50,
                    child: _TinyCoffeeTools(compact: compact),
                  ),
                  Positioned(
                    left: 46,
                    right: 46,
                    bottom: 38,
                    child: _KasirCounter(compact: compact),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 44,
                    child: _KasirCatImage(height: catHeight),
                  ),
                  Positioned(
                    left: 22,
                    right: 22,
                    bottom: 20,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: seruputNavy.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 46,
                    top: 18,
                    child: Icon(Icons.favorite_rounded, size: 18, color: const Color(0xFFE76565).withOpacity(0.75)),
                  ),
                  Positioned(
                    left: 42,
                    top: 28,
                    child: Icon(Icons.star_rounded, size: 16, color: seruputNavy.withOpacity(0.25)),
                  ),
                  Positioned(
                    right: 16,
                    top: 50,
                    child: Icon(Icons.star_rounded, size: 13, color: seruputNavy.withOpacity(0.25)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KasirCatImage extends StatelessWidget {
  final double height;

  const _KasirCatImage({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Image.asset(
        kasirCatAsset,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: seruputSoftPurple.withOpacity(0.62),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pets_rounded, color: seruputNavy, size: 58),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    'Cek path\ngambar kucing',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: seruputNavy.withOpacity(0.65),
                      fontSize: 10.5,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TinyBoard extends StatelessWidget {
  final bool compact;

  const _TinyBoard({required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? 48 : 56,
      height: compact ? 48 : 58,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF6F513D),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: seruputNavy.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 6)),
        ],
      ),
      child: const FittedBox(
        child: Text(
          'Good\nCoffee\nGood\nDay',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _TinyCoffeeTools extends StatelessWidget {
  final bool compact;

  const _TinyCoffeeTools({required this.compact});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_cafe_rounded, color: seruputNavy.withOpacity(0.58), size: compact ? 24 : 30),
        const SizedBox(width: 8),
        Container(
          width: compact ? 34 : 40,
          height: compact ? 48 : 58,
          decoration: BoxDecoration(
            color: seruputSoftPurple.withOpacity(0.55),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.local_cafe_rounded, color: seruputNavy.withOpacity(0.70), size: compact ? 22 : 27),
        ),
      ],
    );
  }
}

class _KasirCounter extends StatelessWidget {
  final bool compact;

  const _KasirCounter({required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 42 : 48,
      decoration: BoxDecoration(
        color: const Color(0xFFC99C73).withOpacity(0.58),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: seruputNavy.withOpacity(0.06)),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Icon(Icons.desktop_mac_rounded, color: seruputNavy.withOpacity(0.72), size: compact ? 26 : 32),
        ),
      ),
    );
  }
}

class _KasirLoginBackground extends StatelessWidget {
  const _KasirLoginBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 70,
          right: -36,
          child: Container(
            width: 92,
            height: 130,
            decoration: BoxDecoration(
              color: seruputSoftPurple.withOpacity(0.60),
              borderRadius: BorderRadius.circular(60),
            ),
          ),
        ),
        Positioned(
          top: 250,
          left: -30,
          child: Container(
            width: 60,
            height: 96,
            decoration: BoxDecoration(
              color: seruputSoftPurple.withOpacity(0.42),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: 22,
          child: Icon(Icons.favorite_rounded, color: seruputNavy.withOpacity(0.13), size: 22),
        ),
      ],
    );
  }
}

class _KasirTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const _KasirTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: seruputNavy,
      style: const TextStyle(
        color: seruputNavy,
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: seruputNavy.withOpacity(0.38),
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        prefixIcon: Icon(icon, color: seruputNavy.withOpacity(0.82), size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: seruputCream,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: seruputNavy.withOpacity(0.11)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: seruputNavy.withOpacity(0.11)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: seruputNavy, width: 1.4),
        ),
      ),
    );
  }
}

// =====================================================
// 2. ANTRIAN PEMBAYARAN KASIR
// =====================================================

class KasirQueueScreen extends StatefulWidget {
  const KasirQueueScreen({super.key});

  @override
  State<KasirQueueScreen> createState() => _KasirQueueScreenState();
}

class _KasirQueueScreenState extends State<KasirQueueScreen> {
  KasirOrderStatus selectedStatus = KasirOrderStatus.menunggu;

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 550));
  }

  List<KasirOrder> _filteredOrders(List<KasirOrder> orders) {
    return orders.where((order) => order.status == selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: seruputCream,
        systemNavigationBarColor: seruputCream,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: seruputCream,
        body: SafeArea(
          child: ValueListenableBuilder<List<KasirOrder>>(
            valueListenable: SeruputOrderStore.orders,
            builder: (context, orders, child) {
              final pendingCount = orders
                  .where((order) => order.status == KasirOrderStatus.menunggu)
                  .length;
              final processCount = orders
                  .where((order) => order.status == KasirOrderStatus.diproses)
                  .length;
              final doneCount = orders
                  .where((order) => order.status == KasirOrderStatus.selesai)
                  .length;
              final shownOrders = _filteredOrders(orders);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                    child: Row(
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: seruputNavy,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Antrian Pembayaran',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserratAlternates(
                                  color: seruputNavy,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Pesanan yang menunggu konfirmasi kasir',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: seruputNavy.withOpacity(0.58),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                color: seruputNavy,
                              ),
                            ),
                            if (pendingCount > 0)
                              Positioned(
                                top: -5,
                                right: -4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE76565),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '$pendingCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        _QueueTab(
                          title: 'Menunggu',
                          count: pendingCount,
                          selected: selectedStatus == KasirOrderStatus.menunggu,
                          onTap: () {
                            setState(() {
                              selectedStatus = KasirOrderStatus.menunggu;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _QueueTab(
                          title: 'Diproses',
                          count: processCount,
                          selected: selectedStatus == KasirOrderStatus.diproses,
                          onTap: () {
                            setState(() {
                              selectedStatus = KasirOrderStatus.diproses;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _QueueTab(
                          title: 'Selesai',
                          count: doneCount,
                          selected: selectedStatus == KasirOrderStatus.selesai,
                          onTap: () {
                            setState(() {
                              selectedStatus = KasirOrderStatus.selesai;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: seruputSoftPurple.withOpacity(0.58),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: seruputNavy.withOpacity(0.10)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: seruputNavy,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Pelanggan sudah memilih “Pesan & Bayar ke Kasir”. Mohon arahkan ke kasir atau bantu konfirmasi pesanan.',
                              style: TextStyle(
                                color: seruputNavy.withOpacity(0.76),
                                fontSize: 11.5,
                                height: 1.35,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: RefreshIndicator(
                      color: seruputNavy,
                      onRefresh: _refresh,
                      child: shownOrders.isEmpty
                          ? ListView(
                        padding: const EdgeInsets.fromLTRB(18, 36, 18, 20),
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            color: seruputNavy.withOpacity(0.30),
                            size: 86,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada antrian',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserratAlternates(
                              color: seruputNavy,
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pesanan customer akan muncul di sini setelah checkout.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: seruputNavy.withOpacity(0.62),
                              fontSize: 13,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                          : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
                        itemCount: shownOrders.length + 1,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12);
                        },
                        itemBuilder: (context, index) {
                          if (index == shownOrders.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: seruputNavy.withOpacity(0.45),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Tarik ke bawah untuk refresh',
                                    style: TextStyle(
                                      color: seruputNavy.withOpacity(0.45),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final order = shownOrders[index];
                          return OrderQueueCard(
                            order: order,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      KasirOrderDetailScreen(orderId: order.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _QueueTab extends StatelessWidget {
  final String title;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _QueueTab({
    required this.title,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: selected ? seruputNavy : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: seruputNavy.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: selected ? Colors.white : seruputNavy.withOpacity(0.66),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 7),
              Container(
                constraints: const BoxConstraints(minWidth: 24),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withOpacity(0.18)
                      : seruputNavy.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.white : seruputNavy.withOpacity(0.72),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class OrderQueueCard extends StatelessWidget {
  final KasirOrder order;
  final VoidCallback onTap;

  const OrderQueueCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final tableText = "Meja ${order.tableNumber.toString().padLeft(2, '0')}";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: seruputNavy.withOpacity(0.07),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: Container(
                  width: 82,
                  height: 82,
                  color: seruputCream,
                  child: firstItem == null
                      ? const Icon(Icons.receipt_long_rounded, color: seruputNavy)
                      : Image.asset(
                    firstItem.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.local_cafe_rounded, color: seruputNavy, size: 34);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(color: seruputNavy, shape: BoxShape.circle),
                          child: const Icon(Icons.table_restaurant_rounded, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tableText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserratAlternates(
                                  color: seruputNavy,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                order.id,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: seruputNavy.withOpacity(0.50),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 88),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${order.totalItem} item',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: seruputNavy.withOpacity(0.65),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  formatRupiah(order.totalPayment),
                                  style: const TextStyle(
                                    color: seruputNavy,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time_rounded, color: seruputNavy.withOpacity(0.42), size: 16),
                            const SizedBox(width: 5),
                            Text(
                              formatTime(order.createdAt),
                              style: TextStyle(
                                color: seruputNavy.withOpacity(0.50),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusBackground(order.status),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            statusText(order),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: statusColor(order.status),
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// =====================================================
// 3. DETAIL VERIFIKASI PESANAN
// =====================================================


class KasirOrderDetailScreen extends StatefulWidget {
  final String orderId;

  const KasirOrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<KasirOrderDetailScreen> createState() => _KasirOrderDetailScreenState();
}

class _KasirOrderDetailScreenState extends State<KasirOrderDetailScreen> {
  late String selectedPayment;

  @override
  void initState() {
    super.initState();
    selectedPayment = SeruputOrderStore.findById(widget.orderId)?.paymentMethod ?? 'Tunai';
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: seruputNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
    );
  }

  void _changeQuantity(KasirOrder order, int index, int delta) {
    if (order.status != KasirOrderStatus.menunggu) return;

    final currentItem = order.items[index];
    final newQuantity = currentItem.quantity + delta;
    final updatedItems = [...order.items];

    if (newQuantity <= 0) {
      if (updatedItems.length == 1) {
        _showSnack('Pesanan minimal memiliki 1 item.');
        return;
      }
      updatedItems.removeAt(index);
    } else {
      updatedItems[index] = currentItem.copyWith(quantity: newQuantity);
    }

    SeruputOrderStore.updateOrder(order.copyWith(items: updatedItems));
  }

  void _confirmOrder(KasirOrder order) {
    final updatedOrder = order.copyWith(
      paymentMethod: selectedPayment,
      status: KasirOrderStatus.diproses,
    );

    SeruputOrderStore.updateOrder(updatedOrder);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => KasirPaymentSuccessScreen(order: updatedOrder)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: seruputCream,
        systemNavigationBarColor: seruputCream,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: seruputCream,
        body: SafeArea(
          child: ValueListenableBuilder<List<KasirOrder>>(
            valueListenable: SeruputOrderStore.orders,
            builder: (context, orders, child) {
              final order = SeruputOrderStore.findById(widget.orderId);

              if (order == null) {
                return const Center(
                  child: Text(
                    'Pesanan tidak ditemukan.',
                    style: TextStyle(color: seruputNavy, fontWeight: FontWeight.w800),
                  ),
                );
              }

              final tableText = "Meja ${order.tableNumber.toString().padLeft(2, '0')}";

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                    child: Row(
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(backgroundColor: Colors.white),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: seruputNavy, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Detail Verifikasi\nPesanan',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserratAlternates(
                              color: seruputNavy,
                              fontSize: 18,
                              height: 1.1,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          style: IconButton.styleFrom(backgroundColor: Colors.white),
                          onPressed: () => showKasirReceiptDialog(context, order),
                          icon: const Icon(Icons.print_outlined, color: seruputNavy, size: 22),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: seruputNavy.withOpacity(0.07),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: const BoxDecoration(color: seruputNavy, shape: BoxShape.circle),
                                  child: const Icon(Icons.table_restaurant_rounded, color: Colors.white, size: 28),
                                ),
                                const SizedBox(width: 13),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tableText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserratAlternates(
                                          color: seruputNavy,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        order.id,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: seruputNavy.withOpacity(0.50),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.access_time_rounded, color: seruputNavy.withOpacity(0.52), size: 16),
                                        const SizedBox(width: 5),
                                        Text(
                                          formatTime(order.createdAt),
                                          style: TextStyle(
                                            color: seruputNavy.withOpacity(0.58),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${order.totalItem} item',
                                      style: const TextStyle(color: seruputNavy, fontSize: 14, fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          _SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _SectionTitle(title: 'Daftar Pesanan'),
                                const SizedBox(height: 12),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: order.items.length,
                                  separatorBuilder: (context, index) => Divider(height: 22, color: seruputNavy.withOpacity(0.08)),
                                  itemBuilder: (context, index) {
                                    final item = order.items[index];
                                    return DetailOrderItemRow(
                                      item: item,
                                      enabled: order.status == KasirOrderStatus.menunggu,
                                      onMinus: () => _changeQuantity(order, index, -1),
                                      onPlus: () => _changeQuantity(order, index, 1),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _SectionCard(
                            backgroundColor: seruputSoftPurple.withOpacity(0.50),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.sticky_note_2_outlined, color: seruputNavy, size: 21),
                                const SizedBox(width: 9),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Catatan dari Pelanggan',
                                        style: TextStyle(color: seruputNavy, fontSize: 12.5, fontWeight: FontWeight.w900),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        order.customerNote.trim().isEmpty ? 'Tidak ada catatan tambahan.' : order.customerNote,
                                        style: TextStyle(
                                          color: seruputNavy.withOpacity(0.70),
                                          fontSize: 11.5,
                                          height: 1.35,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _SectionCard(
                            child: Column(
                              children: [
                                _PaymentRow(title: 'Subtotal', value: formatRupiah(order.subtotal)),
                                const SizedBox(height: 8),
                                _PaymentRow(title: 'Biaya Layanan (5%)', value: formatRupiah(order.serviceFee)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(color: seruputNavy.withOpacity(0.12)),
                                ),
                                _PaymentRow(title: 'Total Pembayaran', value: formatRupiah(order.totalPayment), isTotal: true),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _SectionTitle(title: 'Metode Pembayaran'),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _PaymentMethodButton(
                                      title: 'Tunai',
                                      icon: Icons.payments_outlined,
                                      selected: selectedPayment == 'Tunai',
                                      enabled: order.status == KasirOrderStatus.menunggu,
                                      onTap: () => setState(() => selectedPayment = 'Tunai'),
                                    ),
                                    const SizedBox(width: 8),
                                    _PaymentMethodButton(
                                      title: 'QRIS',
                                      icon: Icons.qr_code_rounded,
                                      selected: selectedPayment == 'QRIS',
                                      enabled: order.status == KasirOrderStatus.menunggu,
                                      onTap: () => setState(() => selectedPayment = 'QRIS'),
                                    ),
                                    const SizedBox(width: 8),
                                    _PaymentMethodButton(
                                      title: 'Debit',
                                      icon: Icons.credit_card_rounded,
                                      selected: selectedPayment == 'Debit',
                                      enabled: order.status == KasirOrderStatus.menunggu,
                                      onTap: () => setState(() => selectedPayment = 'Debit'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: seruputCream,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: seruputNavy.withOpacity(0.10)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        selectedPayment == 'Tunai'
                                            ? Icons.payments_outlined
                                            : selectedPayment == 'QRIS'
                                            ? Icons.qr_code_rounded
                                            : Icons.credit_card_rounded,
                                        color: seruputNavy,
                                        size: 19,
                                      ),
                                      const SizedBox(width: 9),
                                      Expanded(
                                        child: Text(
                                          selectedPayment == 'Tunai'
                                              ? 'Terima uang tunai dari pelanggan.'
                                              : selectedPayment == 'QRIS'
                                              ? 'Pastikan pembayaran QRIS pelanggan sudah berhasil.'
                                              : 'Pastikan transaksi debit berhasil diproses.',
                                          style: TextStyle(
                                            color: seruputNavy.withOpacity(0.67),
                                            fontSize: 11.5,
                                            height: 1.3,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                    decoration: BoxDecoration(
                      color: seruputCream,
                      boxShadow: [
                        BoxShadow(color: seruputNavy.withOpacity(0.07), blurRadius: 16, offset: const Offset(0, -8)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: order.status == KasirOrderStatus.menunggu ? seruputNavy : Colors.grey,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                            ),
                            onPressed: order.status == KasirOrderStatus.menunggu ? () => _confirmOrder(order) : null,
                            icon: const Icon(Icons.check_rounded),
                            label: const FittedBox(
                              child: Text(
                                'Konfirmasi Lunas & Kirim ke Dapur',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: seruputNavy,
                              side: BorderSide(color: seruputNavy.withOpacity(0.28)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                            ),
                            onPressed: () => showKasirReceiptDialog(context, order),
                            icon: const Icon(Icons.print_outlined),
                            label: const Text('Cetak Struk', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const _SectionCard({
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: seruputNavy.withOpacity(0.06)),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.montserratAlternates(
        color: seruputNavy,
        fontSize: 14,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}


class DetailOrderItemRow extends StatelessWidget {
  final KasirOrderItem item;
  final bool enabled;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const DetailOrderItemRow({
    super.key,
    required this.item,
    required this.enabled,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 66,
                height: 66,
                color: seruputCream,
                child: Image.asset(
                  item.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.local_cafe_rounded, color: seruputNavy, size: 30);
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: seruputNavy, fontSize: 13.5, height: 1.15, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.detail,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: seruputNavy.withOpacity(0.56),
                      fontSize: 10.8,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: seruputNavy.withOpacity(0.10)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SmallQtyButton(icon: Icons.remove_rounded, enabled: enabled, onTap: onMinus),
                  SizedBox(
                    width: 36,
                    child: Center(
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(color: seruputNavy, fontSize: 13, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  _SmallQtyButton(icon: Icons.add_rounded, enabled: enabled, onTap: onPlus),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item.quantity} x ${formatRupiah(item.price)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: seruputNavy.withOpacity(0.55),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      formatRupiah(item.totalPrice),
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: seruputNavy, fontSize: 14, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _SmallQtyButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _SmallQtyButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 30,
        height: 34,
        child: Icon(
          icon,
          size: 17,
          color: enabled ? seruputNavy : Colors.grey,
        ),
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const _PaymentRow({
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isTotal ? seruputNavy : seruputNavy.withOpacity(0.62),
              fontSize: isTotal ? 14 : 12,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: seruputNavy,
            fontSize: isTotal ? 18 : 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _PaymentMethodButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: enabled ? onTap : null,
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: selected ? seruputNavy : seruputCream,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: seruputNavy.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : seruputNavy,
                size: 19,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: selected ? Colors.white : seruputNavy,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


void showKasirReceiptDialog(BuildContext context, KasirOrder order) {
  final tableText = "Meja ${order.tableNumber.toString().padLeft(2, '0')}";
  final itemLines = order.items.map((item) {
    return '${item.quantity}x ${item.name}  ${formatRupiah(item.totalPrice)}';
  }).join('\n');

  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        contentPadding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(color: seruputNavy, shape: BoxShape.circle),
              child: const Icon(Icons.print_outlined, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Preview Struk',
                style: GoogleFonts.montserratAlternates(
                  color: seruputNavy,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: seruputCream,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: seruputNavy.withOpacity(0.10)),
            ),
            child: Text(
              'SERUPUT CAFE\n'
                  'Every sip, every story\n\n'
                  'Pesanan : ${order.id}\n'
                  'Meja    : $tableText\n'
                  'Waktu   : ${formatTime(order.createdAt)}\n'
                  'Metode  : ${order.paymentMethod}\n'
                  '--------------------------\n'
                  '$itemLines\n'
                  '--------------------------\n'
                  'Subtotal   : ${formatRupiah(order.subtotal)}\n'
                  'Layanan 5% : ${formatRupiah(order.serviceFee)}\n'
                  'TOTAL      : ${formatRupiah(order.totalPayment)}\n\n'
                  'Pesanan dikirim ke dapur.',
              style: TextStyle(
                color: seruputNavy.withOpacity(0.82),
                height: 1.45,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: seruputNavy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: seruputNavy,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    content: const Text(
                      'Struk berhasil dicetak secara demo.',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.print_outlined),
              label: const Text('Cetak Demo', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      );
    },
  );
}

// =====================================================
// 4. SUKSES KONFIRMASI KASIR - MIRIP REFERENSI PEMBAYARAN
// =====================================================

class KasirPaymentSuccessScreen extends StatelessWidget {
  final KasirOrder order;

  const KasirPaymentSuccessScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final tableText = "Meja ${order.tableNumber.toString().padLeft(2, '0')}";

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: seruputCream,
        systemNavigationBarColor: seruputCream,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: seruputCream,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 40,
                left: 38,
                child: Icon(Icons.star_rounded, color: seruputNavy.withOpacity(0.22), size: 16),
              ),
              Positioned(
                top: 72,
                right: 52,
                child: Icon(Icons.favorite_rounded, color: const Color(0xFFE76565).withOpacity(0.75), size: 28),
              ),
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(22, 8, 22, 18),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 170,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Positioned(
                                  top: 0,
                                  child: _KasirCatImage(height: 150),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 26,
                                  right: 26,
                                  child: Container(
                                    height: 9,
                                    decoration: BoxDecoration(
                                      color: seruputNavy.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: seruputNavy.withOpacity(0.07),
                                  blurRadius: 22,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 92,
                                  height: 92,
                                  decoration: const BoxDecoration(color: seruputGreenSoft, shape: BoxShape.circle),
                                  child: const Icon(Icons.check_rounded, color: seruputGreen, size: 58),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'Pembayaran\nBerhasil!',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserratAlternates(
                                    color: seruputNavy,
                                    fontSize: 28,
                                    height: 1.05,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Terima kasih, pesanan telah dikonfirmasi.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: seruputNavy.withOpacity(0.62),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: seruputCream,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: seruputNavy.withOpacity(0.08)),
                                  ),
                                  child: Column(
                                    children: [
                                      _SuccessRow(icon: Icons.receipt_long_outlined, title: 'Nomor Pesanan', value: order.id),
                                      _SuccessRow(icon: Icons.table_restaurant_outlined, title: 'Meja', value: tableText),
                                      _SuccessRow(icon: Icons.payments_outlined, title: 'Total Dibayar', value: formatRupiah(order.totalPayment), isBold: true),
                                      _SuccessRow(icon: Icons.credit_card_rounded, title: 'Metode', value: order.paymentMethod),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: seruputGreenSoft,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: seruputGreen.withOpacity(0.14)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.room_service_outlined, color: seruputGreen, size: 24),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Pesanan dikirim ke dapur',
                                              style: TextStyle(color: seruputGreen, fontSize: 12.5, fontWeight: FontWeight.w900),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              'Mohon tunggu, pesanan sedang disiapkan.',
                                              style: TextStyle(
                                                color: seruputGreen.withOpacity(0.78),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.restaurant_menu_rounded, color: seruputGreen, size: 24),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            '♡  Every sip, every story  ♡',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: seruputNavy.withOpacity(0.55),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
                    decoration: BoxDecoration(
                      color: seruputCream,
                      boxShadow: [
                        BoxShadow(color: seruputNavy.withOpacity(0.07), blurRadius: 18, offset: const Offset(0, -9)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: seruputNavy,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const KasirQueueScreen()),
                                    (route) => route.isFirst,
                              );
                            },
                            icon: const Icon(Icons.list_alt_rounded),
                            label: const Text('Kembali ke Antrian', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: seruputNavy,
                              side: BorderSide(color: seruputNavy.withOpacity(0.28)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            onPressed: () => showKasirReceiptDialog(context, order),
                            icon: const Icon(Icons.print_outlined),
                            label: const Text('Cetak Struk', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isBold;

  const _SuccessRow({
    required this.icon,
    required this.title,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: seruputNavy, size: 21),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: seruputNavy.withOpacity(0.58),
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: seruputNavy,
                fontSize: isBold ? 17 : 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
