import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'seruput_order_store.dart';

// Login Dapur dari pilih_akses_screen.dart:
// email: dapur@seruput.com
// password: dapur123
// Alur: Kasir klik Konfirmasi Lunas & Kirim ke Dapur -> status diproses -> muncul di sini.

enum DapurFilter { baru, proses, riwayat }
enum DapurProgress { baru, diterima, dibuat }

class DapurProgressStore {
  static final ValueNotifier<Map<String, DapurProgress>> progress =
  ValueNotifier<Map<String, DapurProgress>>({});

  static DapurProgress stage(String orderId) {
    return progress.value[orderId] ?? DapurProgress.baru;
  }

  static void updateStage(String orderId, DapurProgress stage) {
    progress.value = {...progress.value, orderId: stage};
  }

  static void finish(KasirOrder order) {
    updateStage(order.id, DapurProgress.dibuat);
    SeruputOrderStore.updateOrder(order.copyWith(status: KasirOrderStatus.selesai));
  }
}


const String dapurCatAsset = 'assets/images/kucing_dapur.png';

class DapurLoginScreen extends StatefulWidget {
  const DapurLoginScreen({super.key});

  @override
  State<DapurLoginScreen> createState() => _DapurLoginScreenState();
}

class _DapurLoginScreenState extends State<DapurLoginScreen> {
  final TextEditingController emailController = TextEditingController(text: 'dapur@seruput.com');
  final TextEditingController passwordController = TextEditingController(text: 'dapur123');

  bool obscurePassword = true;
  bool rememberMe = false;
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: seruputNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
    );
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email dan kata sandi wajib diisi.');
      return;
    }

    if (email != 'dapur@seruput.com' || password != 'dapur123') {
      _showMessage('Email atau kata sandi dapur salah.');
      return;
    }

    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 450));

    if (!mounted) return;
    setState(() => loading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DapurSeruputScreen()),
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
          child: Stack(
            children: [
              const _DapurLoginBackground(),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(backgroundColor: Colors.white, fixedSize: const Size(48, 48)),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: seruputNavy, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const _DapurLoginBrand(),
                    const SizedBox(height: 8),
                    _DapurCatHero(imagePath: dapurCatAsset),
                    Transform.translate(
                      offset: const Offset(0, -12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.97),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [BoxShadow(color: seruputNavy.withOpacity(0.08), blurRadius: 28, offset: const Offset(0, 16))],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Login Staf Dapur',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 25, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              'Masuk untuk mengelola pesanan dari pelanggan.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: seruputNavy.withOpacity(0.58), fontSize: 13, height: 1.35, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 22),
                            _DapurLoginTextField(
                              controller: emailController,
                              hint: 'Email Dapur',
                              icon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 12),
                            _DapurLoginTextField(
                              controller: passwordController,
                              hint: 'Kata Sandi Dapur',
                              icon: Icons.lock_outline_rounded,
                              obscureText: obscurePassword,
                              suffix: IconButton(
                                onPressed: () => setState(() => obscurePassword = !obscurePassword),
                                icon: Icon(
                                  obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: seruputNavy.withOpacity(0.82),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Checkbox(
                                    value: rememberMe,
                                    activeColor: seruputNavy,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    onChanged: (value) => setState(() => rememberMe = value ?? false),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text('Ingat saya', style: TextStyle(color: seruputNavy.withOpacity(0.62), fontSize: 12, fontWeight: FontWeight.w700)),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => _showMessage('Hubungi owner untuk reset kata sandi dapur.'),
                                  child: const Text('Lupa kata sandi?', style: TextStyle(color: seruputNavy, fontSize: 12, fontWeight: FontWeight.w900)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton.icon(
                                onPressed: loading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: seruputNavy,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: seruputNavy.withOpacity(0.45),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                                ),
                                icon: loading
                                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
                                    : const Icon(Icons.person_rounded),
                                label: Text(
                                  loading ? 'Memeriksa...' : 'Masuk sebagai Dapur',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_user_outlined, color: seruputNavy.withOpacity(0.50), size: 19),
                        const SizedBox(width: 8),
                        Text('Hanya untuk staf dapur', style: TextStyle(color: seruputNavy.withOpacity(0.50), fontSize: 13, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 22),
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

class _DapurLoginBrand extends StatelessWidget {
  const _DapurLoginBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: seruputNavy.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 10))],
          ),
          child: const Icon(Icons.local_cafe_rounded, color: seruputNavy, size: 32),
        ),
        const SizedBox(height: 8),
        Text('Seruput', style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 31, fontWeight: FontWeight.w900)),
        Text('Every sip, every story', style: TextStyle(color: seruputNavy.withOpacity(0.62), fontSize: 12, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _DapurCatHero extends StatelessWidget {
  final String imagePath;

  const _DapurCatHero({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 285,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 185,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.70),
                borderRadius: BorderRadius.circular(34),
                boxShadow: [BoxShadow(color: seruputNavy.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 16))],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Image.asset(
              imagePath,
              height: 265,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 238,
                  width: 250,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: seruputSoftPurple.withOpacity(0.66), borderRadius: BorderRadius.circular(32)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pets_rounded, color: seruputNavy.withOpacity(0.58), size: 74),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Taruh gambar kucing di assets/images/kucing_dapur.png',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: seruputNavy.withOpacity(0.65), fontSize: 12, height: 1.35, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DapurLoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _DapurLoginTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: seruputNavy,
      style: const TextStyle(color: seruputNavy, fontSize: 14, fontWeight: FontWeight.w800),
      decoration: InputDecoration(
        filled: true,
        fillColor: seruputCream,
        hintText: hint,
        hintStyle: TextStyle(color: seruputNavy.withOpacity(0.38), fontSize: 14, fontWeight: FontWeight.w800),
        prefixIcon: Icon(icon, color: seruputNavy.withOpacity(0.82)),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: seruputNavy.withOpacity(0.10), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: seruputNavy, width: 1.4),
        ),
      ),
    );
  }
}

class _DapurLoginBackground extends StatelessWidget {
  const _DapurLoginBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -70,
          top: 135,
          child: Container(
            width: 145,
            height: 210,
            decoration: BoxDecoration(color: seruputSoftPurple.withOpacity(0.58), borderRadius: BorderRadius.circular(80)),
          ),
        ),
        Positioned(
          left: -65,
          bottom: 80,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(color: seruputSoftPurple.withOpacity(0.42), shape: BoxShape.circle),
          ),
        ),
      ],
    );
  }
}


class DapurSeruputScreen extends StatefulWidget {
  const DapurSeruputScreen({super.key});

  @override
  State<DapurSeruputScreen> createState() => _DapurSeruputScreenState();
}

class _DapurSeruputScreenState extends State<DapurSeruputScreen> {
  DapurFilter filter = DapurFilter.baru;

  List<KasirOrder> _ordersByFilter(List<KasirOrder> orders) {
    if (filter == DapurFilter.riwayat) {
      return orders.where((order) => order.status == KasirOrderStatus.selesai).toList();
    }

    final active = orders.where((order) => order.status == KasirOrderStatus.diproses);

    if (filter == DapurFilter.baru) {
      return active.where((order) => DapurProgressStore.stage(order.id) == DapurProgress.baru).toList();
    }

    return active.where((order) => DapurProgressStore.stage(order.id) != DapurProgress.baru).toList();
  }

  int _newCount(List<KasirOrder> orders) {
    return orders
        .where((order) =>
    order.status == KasirOrderStatus.diproses &&
        DapurProgressStore.stage(order.id) == DapurProgress.baru)
        .length;
  }

  int _processCount(List<KasirOrder> orders) {
    return orders
        .where((order) =>
    order.status == KasirOrderStatus.diproses &&
        DapurProgressStore.stage(order.id) != DapurProgress.baru)
        .length;
  }

  int _historyCount(List<KasirOrder> orders) {
    return orders.where((order) => order.status == KasirOrderStatus.selesai).length;
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
          child: Column(
            children: [
              _DapurHeader(title: filter == DapurFilter.riwayat ? 'Riwayat Dapur' : 'Monitor Dapur'),
              Expanded(
                child: ValueListenableBuilder<List<KasirOrder>>(
                  valueListenable: SeruputOrderStore.orders,
                  builder: (context, orders, child) {
                    return ValueListenableBuilder<Map<String, DapurProgress>>(
                      valueListenable: DapurProgressStore.progress,
                      builder: (context, progress, child) {
                        final shownOrders = _ordersByFilter(orders);

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                              child: _DapurTabs(
                                filter: filter,
                                baru: _newCount(orders),
                                proses: _processCount(orders),
                                riwayat: _historyCount(orders),
                                onChanged: (value) => setState(() => filter = value),
                              ),
                            ),
                            Expanded(
                              child: shownOrders.isEmpty
                                  ? _EmptyDapur(filter: filter)
                                  : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
                                itemCount: shownOrders.length + 1,
                                separatorBuilder: (context, index) => const SizedBox(height: 14),
                                itemBuilder: (context, index) {
                                  if (index == shownOrders.length) {
                                    return const _DapurFooter();
                                  }
                                  final order = shownOrders[index];
                                  return DapurOrderCard(
                                    order: order,
                                    isHistory: filter == DapurFilter.riwayat,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DapurOrderDetailScreen(orderId: order.id),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _DapurHeader extends StatelessWidget {
  final String title;

  const _DapurHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<KasirOrder>>(
      valueListenable: SeruputOrderStore.orders,
      builder: (context, orders, child) {
        final notifOrders = orders
            .where((order) => order.status == KasirOrderStatus.diproses)
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

        final notifCount = notifOrders.length;

        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 2),
          child: Row(
            children: [
              IconButton(
                style: IconButton.styleFrom(backgroundColor: Colors.white, fixedSize: const Size(46, 46)),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.logout_rounded, color: seruputNavy, size: 21),
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
                      style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 23, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      'Kelola pesanan yang dikirim dari kasir',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: seruputNavy.withOpacity(0.62), fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(17),
                      onTap: () => _showDapurNotificationSheet(context, notifOrders),
                      child: Container(
                        width: 46,
                        height: 46,
                        alignment: Alignment.center,
                        child: const Icon(Icons.notifications_none_rounded, color: seruputNavy, size: 25),
                      ),
                    ),
                  ),
                  if (notifCount > 0)
                    Positioned(
                      right: -4,
                      top: -5,
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 21, minHeight: 21),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: Color(0xFFEF6B6B), shape: BoxShape.circle),
                        child: Text(
                          notifCount > 99 ? '99+' : '$notifCount',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

void _showDapurNotificationSheet(BuildContext parentContext, List<KasirOrder> orders) {
  showModalBottomSheet(
    context: parentContext,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return _DapurNotificationSheet(parentContext: parentContext, orders: orders);
    },
  );
}

class _DapurNotificationSheet extends StatelessWidget {
  final BuildContext parentContext;
  final List<KasirOrder> orders;

  const _DapurNotificationSheet({required this.parentContext, required this.orders});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.78),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      decoration: const BoxDecoration(
        color: seruputCream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 5,
            decoration: BoxDecoration(color: seruputNavy.withOpacity(0.22), borderRadius: BorderRadius.circular(99)),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)),
                child: const Icon(Icons.notifications_active_outlined, color: seruputNavy, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifikasi Dapur',
                      style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 21, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      orders.isEmpty ? 'Belum ada pesanan masuk dari kasir' : '${orders.length} pesanan perlu dilihat',
                      style: TextStyle(color: seruputNavy.withOpacity(0.58), fontSize: 12.5, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (orders.isEmpty)
            const _EmptyNotifDapur()
          else
            Flexible(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: orders.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = orders[index];

                  return _DapurNotificationTile(
                    order: order,
                    onTap: () {
                      Navigator.pop(context);
                      Future.microtask(() {
                        Navigator.push(
                          parentContext,
                          MaterialPageRoute(builder: (context) => DapurOrderDetailScreen(orderId: order.id)),
                        );
                      });
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DapurNotificationTile extends StatelessWidget {
  final KasirOrder order;
  final VoidCallback onTap;

  const _DapurNotificationTile({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final priority = _priorityText(order);
    final priorityColor = _priorityColor(priority);
    final previewItems = order.items.take(3).toList();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.98),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: seruputNavy.withOpacity(0.08)),
            boxShadow: [BoxShadow(color: seruputNavy.withOpacity(0.055), blurRadius: 18, offset: const Offset(0, 10))],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TableIconBox(size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Meja ${order.tableNumber.toString().padLeft(2, '0')}",
                      style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.id}  •  ${formatTime(order.createdAt).replaceAll(' WIB', '')}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: seruputNavy.withOpacity(0.55), fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.totalItem} item  •  ${order.paymentMethod}',
                      style: TextStyle(color: seruputNavy.withOpacity(0.60), fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ...previewItems.map((item) => Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: _ItemImage(imagePath: item.imagePath, size: 38),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _PriorityBadge(text: priority, color: priorityColor),
                  const SizedBox(height: 14),
                  const Icon(Icons.chevron_right_rounded, color: seruputNavy, size: 27),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyNotifDapur extends StatelessWidget {
  const _EmptyNotifDapur();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.fromLTRB(18, 36, 18, 36),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: seruputNavy.withOpacity(0.07)),
      ),
      child: Column(
        children: [
          Icon(Icons.soup_kitchen_outlined, color: seruputNavy.withOpacity(0.28), size: 66),
          const SizedBox(height: 14),
          Text(
            'Belum ada notif dapur',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            'Kalau kasir sudah klik Konfirmasi Lunas & Kirim ke Dapur, pesanan akan muncul di sini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: seruputNavy.withOpacity(0.58), fontSize: 12.5, height: 1.45, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}


class _DapurTabs extends StatelessWidget {
  final DapurFilter filter;
  final int baru;
  final int proses;
  final int riwayat;
  final ValueChanged<DapurFilter> onChanged;

  const _DapurTabs({
    required this.filter,
    required this.baru,
    required this.proses,
    required this.riwayat,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: seruputNavy.withOpacity(0.10)),
      ),
      child: Row(
        children: [
          _TabButton(title: 'Pesanan\nBaru', count: baru, selected: filter == DapurFilter.baru, onTap: () => onChanged(DapurFilter.baru)),
          _TabButton(title: 'Sedang\nDibuat', count: proses, selected: filter == DapurFilter.proses, onTap: () => onChanged(DapurFilter.proses)),
          _TabButton(title: 'Riwayat\nDapur', count: riwayat, selected: filter == DapurFilter.riwayat, onTap: () => onChanged(DapurFilter.riwayat)),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({required this.title, required this.count, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? seruputNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: selected ? Colors.white : seruputNavy.withOpacity(0.70),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : seruputSoftPurple.withOpacity(0.70),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text('$count', style: const TextStyle(color: seruputNavy, fontSize: 11, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DapurOrderCard extends StatelessWidget {
  final KasirOrder order;
  final bool isHistory;
  final VoidCallback onTap;

  const DapurOrderCard({super.key, required this.order, required this.isHistory, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = DapurProgressStore.stage(order.id);
    final priority = _priorityText(order);
    final priorityColor = _priorityColor(priority);
    final previewItems = order.items.take(4).toList();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: isHistory ? null : onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.96),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isHistory ? seruputGreen.withOpacity(0.24) : seruputNavy.withOpacity(0.08),
              width: isHistory ? 1.2 : 1,
            ),
            boxShadow: [BoxShadow(color: seruputNavy.withOpacity(0.055), blurRadius: 18, offset: const Offset(0, 10))],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TableIconBox(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Meja ${order.tableNumber.toString().padLeft(2, '0')}",
                          style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 3),
                        Text('${order.id}  •  ${formatTime(order.createdAt).replaceAll(' WIB', '')}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: seruputNavy.withOpacity(0.55), fontSize: 11, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 3),
                        Text('${order.totalItem} item  •  ${order.paymentMethod}',
                            style: TextStyle(color: seruputNavy.withOpacity(0.60), fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  isHistory
                      ? _SmallStatusChip(text: 'Siap Diseruput', color: seruputGreen, background: seruputGreenSoft)
                      : _PriorityBadge(text: priority, color: priorityColor),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ...previewItems.map((item) => Padding(padding: const EdgeInsets.only(right: 8), child: _ItemImage(imagePath: item.imagePath))),
                  const Spacer(),
                  if (!isHistory) _ProgressChip(progress: progress),
                  if (!isHistory) const SizedBox(width: 6),
                  if (!isHistory) const Icon(Icons.chevron_right_rounded, color: seruputNavy),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DapurOrderDetailScreen extends StatelessWidget {
  final String orderId;

  const DapurOrderDetailScreen({super.key, required this.orderId});

  void _message(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: seruputNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
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
              return ValueListenableBuilder<Map<String, DapurProgress>>(
                valueListenable: DapurProgressStore.progress,
                builder: (context, progressMap, child) {
                  final order = SeruputOrderStore.findById(orderId);
                  if (order == null) return const _OrderNotFound();

                  final progress = DapurProgressStore.stage(order.id);
                  final canAccept = progress == DapurProgress.baru;
                  final canStart = progress == DapurProgress.diterima;
                  final canFinish = progress == DapurProgress.dibuat;
                  final priority = _priorityText(order);
                  final priorityColor = _priorityColor(priority);

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 18, 4),
                        child: Row(
                          children: [
                            IconButton(
                              style: IconButton.styleFrom(backgroundColor: Colors.white),
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: seruputNavy, size: 18),
                            ),
                            Expanded(
                              child: Text(
                                'Detail Pesanan Dapur',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 19, fontWeight: FontWeight.w900),
                              ),
                            ),
                            const SizedBox(width: 42),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: seruputNavy.withOpacity(0.08))),
                                child: Row(
                                  children: [
                                    _TableIconBox(size: 48),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Meja ${order.tableNumber.toString().padLeft(2, '0')}",
                                              style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 21, fontWeight: FontWeight.w900)),
                                          const SizedBox(height: 4),
                                          Text('${order.id}  •  ${formatTime(order.createdAt).replaceAll(' WIB', '')}',
                                              style: TextStyle(color: seruputNavy.withOpacity(0.55), fontSize: 11.5, fontWeight: FontWeight.w700)),
                                          const SizedBox(height: 4),
                                          Text('${order.totalItem} item  •  Dine In  •  ${order.paymentMethod}',
                                              style: TextStyle(color: seruputNavy.withOpacity(0.60), fontSize: 11.5, fontWeight: FontWeight.w700)),
                                        ],
                                      ),
                                    ),
                                    _PriorityBadge(text: priority, color: priorityColor),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              const _SectionTitle('Daftar Pesanan'),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: seruputNavy.withOpacity(0.08))),
                                child: Column(
                                  children: List.generate(order.items.length, (index) {
                                    final item = order.items[index];
                                    return Column(
                                      children: [
                                        _DetailItem(item: item),
                                        if (index != order.items.length - 1)
                                          Divider(height: 1, thickness: 1, color: seruputNavy.withOpacity(0.06)),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(height: 14),
                              _NoteBox(note: order.customerNote),
                              const SizedBox(height: 16),
                              _TimelineBox(progress: progress, time: formatTime(order.createdAt).replaceAll(' WIB', '')),
                              const SizedBox(height: 94),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                        decoration: BoxDecoration(color: seruputCream.withOpacity(0.98), boxShadow: [BoxShadow(color: seruputNavy.withOpacity(0.06), blurRadius: 18, offset: const Offset(0, -8))]),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _DapurActionButton(
                              title: 'Terima Pesanan',
                              icon: Icons.check_circle_outline_rounded,
                              filled: true,
                              enabled: canAccept,
                              onTap: () {
                                DapurProgressStore.updateStage(order.id, DapurProgress.diterima);
                                _message(context, 'Pesanan ${order.id} diterima dapur.');
                              },
                            ),
                            const SizedBox(height: 10),
                            _DapurActionButton(
                              title: 'Mulai Dibuat',
                              icon: Icons.play_arrow_rounded,
                              filled: false,
                              enabled: canStart,
                              onTap: () {
                                DapurProgressStore.updateStage(order.id, DapurProgress.dibuat);
                                _message(context, 'Pesanan ${order.id} mulai dibuat.');
                              },
                            ),
                            const SizedBox(height: 10),
                            _DapurActionButton(
                              title: 'Selesai Dibuat',
                              icon: Icons.flag_rounded,
                              filled: false,
                              enabled: canFinish,
                              onTap: () {
                                DapurProgressStore.finish(order);
                                _message(context, 'Pesanan ${order.id} selesai dibuat.');
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final KasirOrderItem item;

  const _DetailItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _ItemImage(imagePath: item.imagePath, size: 54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(color: seruputNavy, fontSize: 13.5, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(item.detail, style: TextStyle(color: seruputNavy.withOpacity(0.58), fontSize: 11.2, height: 1.3, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text('x ${item.quantity}', style: const TextStyle(color: seruputNavy, fontSize: 13, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _NoteBox extends StatelessWidget {
  final String note;

  const _NoteBox({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: seruputSoftPurple.withOpacity(0.62), borderRadius: BorderRadius.circular(20), border: Border.all(color: seruputNavy.withOpacity(0.08))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.sticky_note_2_outlined, color: seruputNavy),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Catatan Khusus dari Pelanggan', style: TextStyle(color: seruputNavy, fontSize: 12.5, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(note.trim().isEmpty ? 'Tidak ada catatan tambahan.' : note,
                    style: TextStyle(color: seruputNavy.withOpacity(0.72), fontSize: 12, height: 1.35, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineBox extends StatelessWidget {
  final DapurProgress progress;
  final String time;

  const _TimelineBox({required this.progress, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TimelineRow(icon: Icons.inventory_2_outlined, title: 'Pesanan dibuat', time: time, active: true),
        _TimelineRow(icon: Icons.check_box_outlined, title: 'Diterima sistem dapur', time: time, active: true),
        _TimelineRow(icon: Icons.restaurant_rounded, title: 'Menunggu / sedang diproses', time: progress == DapurProgress.baru ? '-' : time, active: progress != DapurProgress.baru),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final bool active;

  const _TimelineRow({required this.icon, required this.title, required this.time, required this.active});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: active ? seruputNavy : seruputNavy.withOpacity(0.28), size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: TextStyle(color: active ? seruputNavy : seruputNavy.withOpacity(0.45), fontSize: 12, fontWeight: FontWeight.w700))),
          Text(time, style: TextStyle(color: seruputNavy.withOpacity(0.54), fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _DapurActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool filled;
  final bool enabled;
  final VoidCallback onTap;

  const _DapurActionButton({required this.title, required this.icon, required this.filled, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final background = filled ? seruputNavy : Colors.white;
    final foreground = filled ? Colors.white : seruputNavy;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: filled
          ? ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? background : Colors.grey.shade400,
          foregroundColor: foreground,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        ),
        onPressed: enabled ? onTap : null,
        icon: Icon(icon, size: 20),
        label: Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900)),
      )
          : OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: enabled ? foreground : Colors.grey,
          side: BorderSide(color: enabled ? seruputNavy : Colors.grey.shade300, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        ),
        onPressed: enabled ? onTap : null,
        icon: Icon(icon, size: 20),
        label: Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class _ItemImage extends StatelessWidget {
  final String imagePath;
  final double size;

  const _ItemImage({required this.imagePath, this.size = 47});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: seruputCream, borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.fastfood_rounded, color: seruputNavy.withOpacity(0.45), size: size * 0.48),
      ),
    );
  }
}

class _TableIconBox extends StatelessWidget {
  final double size;

  const _TableIconBox({this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: seruputSoftPurple.withOpacity(0.72), borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.table_restaurant_rounded, color: seruputNavy),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _PriorityBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Text('PRIORITAS', style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _ProgressChip extends StatelessWidget {
  final DapurProgress progress;

  const _ProgressChip({required this.progress});

  @override
  Widget build(BuildContext context) {
    final bool baru = progress == DapurProgress.baru;
    return _SmallStatusChip(
      text: baru ? 'Baru' : progress == DapurProgress.diterima ? 'Diterima' : 'Dibuat',
      color: baru ? const Color(0xFFB56A2B) : seruputNavy,
      background: baru ? seruputOrangeSoft : seruputSoftPurple.withOpacity(0.72),
    );
  }
}

class _SmallStatusChip extends StatelessWidget {
  final String text;
  final Color color;
  final Color background;

  const _SmallStatusChip({required this.text, required this.color, required this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w900)),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 16, fontWeight: FontWeight.w900));
  }
}

class _DapurFooter extends StatelessWidget {
  const _DapurFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: seruputSoftPurple.withOpacity(0.65), borderRadius: BorderRadius.circular(22)),
      child: Row(
        children: [
          const Icon(Icons.campaign_outlined, color: seruputNavy),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Kerjakan pesanan sesuai prioritas untuk layanan terbaik. Pelanggan senang, kita bangga. 💜',
              style: TextStyle(color: seruputNavy.withOpacity(0.72), fontSize: 12, height: 1.35, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDapur extends StatelessWidget {
  final DapurFilter filter;

  const _EmptyDapur({required this.filter});

  @override
  Widget build(BuildContext context) {
    final title = filter == DapurFilter.riwayat ? 'Belum ada riwayat dapur' : 'Belum ada pesanan';
    final subtitle = filter == DapurFilter.baru
        ? 'Pesanan muncul setelah kasir klik Konfirmasi Lunas & Kirim ke Dapur.'
        : filter == DapurFilter.proses
        ? 'Pesanan yang sudah diterima atau sedang dibuat akan tampil di sini.'
        : 'Pesanan yang selesai dibuat akan masuk ke riwayat dapur.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.soup_kitchen_outlined, color: seruputNavy.withOpacity(0.30), size: 88),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center, style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center, style: TextStyle(color: seruputNavy.withOpacity(0.62), fontSize: 13, height: 1.45, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _OrderNotFound extends StatelessWidget {
  const _OrderNotFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Pesanan tidak ditemukan.',
        style: GoogleFonts.montserratAlternates(color: seruputNavy, fontSize: 18, fontWeight: FontWeight.w900),
      ),
    );
  }
}

String _priorityText(KasirOrder order) {
  final age = DateTime.now().difference(order.createdAt).inMinutes;
  if (age >= 10 || order.totalItem >= 4) return 'Tinggi';
  if (age >= 5 || order.totalItem >= 2) return 'Sedang';
  return 'Rendah';
}

Color _priorityColor(String text) {
  if (text == 'Tinggi') return const Color(0xFFE15B5B);
  if (text == 'Sedang') return const Color(0xFFD99637);
  return seruputNavy;
}
