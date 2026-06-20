import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'menu_seruput_screen.dart';
import 'seruput_order_store.dart';
import 'kasir_seruput_screen.dart';
import 'dapur_seruput_screen.dart';
import 'owner_seruput_screen.dart';

class PilihAksesScreen extends StatelessWidget {
  const PilihAksesScreen({super.key});

  static const Color navy = Color(0xFF3B3D84);
  static const Color cream = Color(0xFFFFFAF6);
  static const Color softPurple = Color(0xFFEDE9FF);

  void _goToCustomerMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MenuSeruputScreen(),
      ),
    );
  }

  void _goToStaffLogin(BuildContext context, StaffLoginData data) {
    // PENTING:
    // Sebelumnya Kasir juga masuk ke StaffLoginScreen di file ini.
    // Karena itu, tampilan login Kasir tidak berubah walaupun file
    // kasir_seruput_screen.dart sudah diganti.
    // Sekarang khusus Kasir diarahkan ke KasirLoginScreen dari
    // kasir_seruput_screen.dart supaya UI kucing/referensi baru terbaca.
    if (data.role.toLowerCase() == 'kasir') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const KasirLoginScreen(),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StaffLoginScreen(data: data),
      ),
    );
  }

  StaffLoginData get _kasirLoginData {
    return StaffLoginData(
      role: 'Kasir',
      subtitle: 'Kelola transaksi dan pembayaran pesanan customer.',
      icon: Icons.point_of_sale_rounded,
      email: 'kasir@seruput.com',
      password: 'kasir123',
      homeBuilder: (context) => const KasirQueueScreen(),
    );
  }

  StaffLoginData get _dapurLoginData {
    return StaffLoginData(
      role: 'Dapur',
      subtitle: 'Kelola pesanan yang sudah dikonfirmasi kasir.',
      icon: Icons.soup_kitchen_rounded,
      email: 'dapur@seruput.com',
      password: 'dapur123',
      homeBuilder: (context) => const DapurSeruputScreen(),
    );
  }

  StaffLoginData get _ownerLoginData {
    return StaffLoginData(
      role: 'Owner',
      subtitle: 'Pantau laporan, pemasukan, dan status operasional.',
      icon: Icons.insights_rounded,
      email: 'owner@seruput.com',
      password: 'owner123',
      homeBuilder: (context) => const OwnerSeruputScreen(),
    );
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final bool layarKecil = height < 760;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: cream,
        systemNavigationBarColor: cream,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: cream,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                SizedBox(height: layarKecil ? 14 : 22),

                Text(
                  'Pilih Akses',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserratAlternates(
                    color: navy,
                    fontSize: layarKecil ? 29 : 32,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Masuk sebagai siapa hari ini?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: navy.withOpacity(0.75),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: layarKecil ? 18 : 26),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double spacing = layarKecil ? 14 : 16;

                      final double cardWidth =
                          (constraints.maxWidth - spacing) / 2;

                      final double targetCardHeight =
                      layarKecil ? 218 : 248;

                      final double maxCardHeight =
                          (constraints.maxHeight - spacing) / 2;

                      final double cardHeight = math.max(
                        198,
                        math.min(targetCardHeight, maxCardHeight),
                      );

                      final double gridHeight = (cardHeight * 2) + spacing;

                      return Center(
                        child: SizedBox(
                          height: gridHeight,
                          child: GridView.count(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: spacing,
                            crossAxisSpacing: spacing,
                            childAspectRatio: cardWidth / cardHeight,
                            children: [
                              AccessCard(
                                title: 'Customer',
                                subtitle: 'Pesan & nikmati\nmenu favorit',
                                imagePath: 'assets/images/akses_customer.png',
                                delay: 0,
                                onTap: () => _goToCustomerMenu(context),
                              ),
                              AccessCard(
                                title: 'Kasir',
                                subtitle: 'Kelola transaksi\ndan pembayaran',
                                imagePath: 'assets/images/akses_kasir.png',
                                delay: 180,
                                onTap: () => _goToStaffLogin(
                                  context,
                                  _kasirLoginData,
                                ),
                              ),
                              AccessCard(
                                title: 'Dapur',
                                subtitle: 'Kelola pesanan\ndan produksi',
                                imagePath: 'assets/images/akses_dapur.png',
                                delay: 360,
                                onTap: () => _goToStaffLogin(
                                  context,
                                  _dapurLoginData,
                                ),
                              ),
                              AccessCard(
                                title: 'Owner',
                                subtitle: 'Pantau laporan &\nkinerja bisnis',
                                imagePath: 'assets/images/akses_owner.png',
                                delay: 540,
                                onTap: () => _goToStaffLogin(
                                  context,
                                  _ownerLoginData,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: layarKecil ? 14 : 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: softPurple.withOpacity(0.78),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: navy.withOpacity(0.14),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: navy.withOpacity(0.9),
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Customer bisa langsung masuk tanpa login. Kasir, Dapur, dan Owner wajib login.',
                          style: TextStyle(
                            color: navy.withOpacity(0.82),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: layarKecil ? 18 : 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccessCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;
  final int delay;

  const AccessCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
    required this.delay,
  });

  @override
  State<AccessCard> createState() => _AccessCardState();
}

class _AccessCardState extends State<AccessCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotateAnimation;

  static const Color navy = Color(0xFF3B3D84);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2300),
    );

    _floatAnimation = Tween<double>(
      begin: -4,
      end: 4,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.985,
      end: 1.025,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(
      begin: -0.018,
      end: 0.018,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (!mounted) return;
      _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.78),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: widget.onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.70),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: navy.withOpacity(0.24),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: navy.withOpacity(0.055),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(11, 12, 11, 13),
            child: Column(
              children: [
                Expanded(
                  flex: 8,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: Transform.rotate(
                          angle: _rotateAnimation.value,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported_rounded,
                          color: navy.withOpacity(0.5),
                          size: 52,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserratAlternates(
                    color: navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: navy.withOpacity(0.72),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    height: 1.22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class StaffLoginData {
  final String role;
  final String subtitle;
  final IconData icon;
  final String email;
  final String password;
  final WidgetBuilder homeBuilder;

  const StaffLoginData({
    required this.role,
    required this.subtitle,
    required this.icon,
    required this.email,
    required this.password,
    required this.homeBuilder,
  });
}

class StaffLoginScreen extends StatefulWidget {
  final StaffLoginData data;

  const StaffLoginScreen({
    super.key,
    required this.data,
  });

  @override
  State<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  static const Color navy = Color(0xFF3B3D84);
  static const Color cream = Color(0xFFFFFAF6);
  static const Color softPurple = Color(0xFFEDE9FF);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: navy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _fillDemoAccount() {
    _emailController.text = widget.data.email;
    _passwordController.text = widget.data.password;
    setState(() {});
  }

  void _login() {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email dan kata sandi wajib diisi.');
      return;
    }

    final validEmail = email == widget.data.email.toLowerCase();
    final validPassword = password == widget.data.password;

    if (!validEmail || !validPassword) {
      _showMessage('Email atau kata sandi ${widget.data.role} salah.');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: widget.data.homeBuilder,
      ),
    );
  }

  Widget _buildDapurLogin(BuildContext context) {
    final bool smallScreen = MediaQuery.of(context).size.height < 760;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: cream,
        systemNavigationBarColor: cream,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: cream,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 82,
                right: -42,
                child: Container(
                  width: 116,
                  height: 170,
                  decoration: BoxDecoration(
                    color: softPurple.withOpacity(0.58),
                    borderRadius: BorderRadius.circular(70),
                  ),
                ),
              ),
              Positioned(
                left: -54,
                bottom: 130,
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: softPurple.withOpacity(0.42),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(18, smallScreen ? 8 : 14, 18, 22),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            fixedSize: const Size(46, 46),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navy, size: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: smallScreen ? 4 : 8),
                    Container(
                      width: smallScreen ? 58 : 68,
                      height: smallScreen ? 58 : 68,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: navy.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: const Icon(Icons.soup_kitchen_rounded, color: navy, size: 35),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Seruput',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserratAlternates(
                        color: navy,
                        fontSize: smallScreen ? 32 : 38,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Every sip, every story',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: navy.withOpacity(0.72), fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: smallScreen ? 14 : 18),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(16, smallScreen ? 12 : 16, 16, smallScreen ? 12 : 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.82),
                        borderRadius: BorderRadius.circular(34),
                        boxShadow: [
                          BoxShadow(color: navy.withOpacity(0.065), blurRadius: 25, offset: const Offset(0, 14)),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: smallScreen ? 150 : 205,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  left: 2,
                                  top: 22,
                                  child: Icon(Icons.local_florist_rounded, color: navy.withOpacity(0.16), size: 34),
                                ),
                                Positioned(
                                  right: 8,
                                  bottom: 18,
                                  child: Icon(Icons.coffee_maker_rounded, color: navy.withOpacity(0.18), size: 42),
                                ),
                                Image.asset(
                                  'assets/images/akses_dapur.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.pets_rounded,
                                    color: navy.withOpacity(0.68),
                                    size: smallScreen ? 96 : 126,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: smallScreen ? 8 : 10),
                          Text(
                            'Login Staff Dapur',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserratAlternates(
                              color: navy,
                              fontSize: smallScreen ? 20 : 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Masuk untuk mengelola pesanan dari pelanggan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: navy.withOpacity(0.60),
                              fontSize: smallScreen ? 11.5 : 12.5,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: smallScreen ? 14 : 18),
                          StaffTextField(controller: _emailController, hintText: 'Email Dapur', icon: Icons.mail_outline_rounded),
                          const SizedBox(height: 10),
                          StaffTextField(
                            controller: _passwordController,
                            hintText: 'Kata Sandi Dapur',
                            icon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: navy,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: Checkbox(
                                  value: _rememberMe,
                                  activeColor: navy,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  onChanged: (value) => setState(() => _rememberMe = value ?? false),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Ingat saya',
                                style: TextStyle(color: navy.withOpacity(0.58), fontSize: 11.5, fontWeight: FontWeight.w700),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () => _showMessage('Demo: dapur@seruput.com / dapur123'),
                                child: Text(
                                  'Lupa kata sandi?',
                                  style: TextStyle(color: navy.withOpacity(0.68), fontSize: 11.5, fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: _fillDemoAccount,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: cream,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: navy.withOpacity(0.10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Akun demo Dapur',
                                    style: TextStyle(color: navy, fontSize: 12, fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'dapur@seruput.com / dapur123',
                                    style: TextStyle(color: navy.withOpacity(0.68), fontSize: 12, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: smallScreen ? 14 : 18),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: navy,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              ),
                              onPressed: _login,
                              icon: const Icon(Icons.person_rounded, size: 21),
                              label: const Text(
                                'Masuk sebagai Dapur',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_user_outlined, color: navy.withOpacity(0.55), size: 18),
                        const SizedBox(width: 7),
                        Text(
                          'Hanya untuk staf dapur',
                          style: TextStyle(color: navy.withOpacity(0.58), fontSize: 12, fontWeight: FontWeight.w700),
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

  Widget _buildOwnerLogin(BuildContext context) {
    final bool smallScreen = MediaQuery.of(context).size.height < 760;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: cream,
        systemNavigationBarColor: cream,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: cream,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(top: -36, right: -42, child: _OwnerBlob(size: 145, opacity: 0.60)),
              Positioned(bottom: -44, left: -42, child: _OwnerBlob(size: 130, opacity: 0.54)),
              Positioned(top: 115, right: 48, child: Icon(Icons.auto_awesome_rounded, color: navy.withOpacity(0.16), size: 22)),
              Positioned(bottom: 62, right: 42, child: Icon(Icons.eco_rounded, color: navy.withOpacity(0.15), size: 22)),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
                child: Column(
                  children: [
                    Row(children: [
                      IconButton(
                        style: IconButton.styleFrom(backgroundColor: Colors.white, fixedSize: const Size(46, 46), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navy, size: 18),
                      ),
                    ]),
                    SizedBox(height: smallScreen ? 6 : 16),
                    const Icon(Icons.local_cafe_rounded, color: navy, size: 62),
                    const SizedBox(height: 8),
                    Text('Seruput', textAlign: TextAlign.center, style: GoogleFonts.montserratAlternates(color: navy, fontSize: 42, fontWeight: FontWeight.w900, height: 1)),
                    const SizedBox(height: 6),
                    Text('Every sip, every story', textAlign: TextAlign.center, style: TextStyle(color: navy.withOpacity(0.72), fontSize: 13, fontWeight: FontWeight.w700)),
                    SizedBox(height: smallScreen ? 18 : 26),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.96),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [BoxShadow(color: navy.withOpacity(0.08), blurRadius: 28, offset: const Offset(0, 14))],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: smallScreen ? 96 : 128,
                            child: Image.asset(
                              'assets/images/akses_owner.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(Icons.business_center_rounded, color: navy.withOpacity(0.90), size: smallScreen ? 72 : 92),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Portal Owner', textAlign: TextAlign.center, style: GoogleFonts.montserratAlternates(color: navy, fontSize: 18, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Text('Kelola bisnis dengan mudah', textAlign: TextAlign.center, style: TextStyle(color: navy.withOpacity(0.62), fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 18),
                          StaffTextField(controller: _emailController, hintText: 'Email Owner', icon: Icons.person_outline_rounded),
                          const SizedBox(height: 12),
                          StaffTextField(
                            controller: _passwordController,
                            hintText: 'Kata Sandi',
                            icon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: navy, size: 20),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(onPressed: () => _showMessage('Demo: owner@seruput.com / owner123'), child: Text('Lupa kata sandi?', style: TextStyle(color: navy.withOpacity(0.62), fontSize: 11, fontWeight: FontWeight.w700))),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: navy, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                              onPressed: _login,
                              child: const Text('Masuk sebagai Owner', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.verified_user_outlined, color: navy.withOpacity(0.55), size: 18),
                      const SizedBox(width: 7),
                      Text('Aman & terlindungi', style: TextStyle(color: navy.withOpacity(0.58), fontSize: 12, fontWeight: FontWeight.w700)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final String role = widget.data.role.toLowerCase();

    if (role == 'owner') {
      return _buildOwnerLogin(context);
    }

    if (role == 'dapur') {
      return _buildDapurLogin(context);
    }

    final bool smallScreen = MediaQuery.of(context).size.height < 760;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: cream,
        systemNavigationBarColor: cream,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: cream,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 70,
                right: -28,
                child: Container(
                  width: 90,
                  height: 130,
                  decoration: BoxDecoration(
                    color: softPurple.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              ),
              Positioned(
                top: 360,
                left: -20,
                child: Icon(
                  Icons.favorite_rounded,
                  color: navy.withOpacity(0.15),
                  size: 28,
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: navy,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: smallScreen ? 8 : 16),
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: navy.withOpacity(0.08),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.data.icon,
                        color: navy,
                        size: 46,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Seruput',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserratAlternates(
                        color: navy,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Every sip, every story',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: navy.withOpacity(0.75),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: smallScreen ? 24 : 34),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: navy.withOpacity(0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Login Staf ${widget.data.role}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserratAlternates(
                              color: navy,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.data.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: navy.withOpacity(0.62),
                              fontSize: 12.5,
                              height: 1.35,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          StaffTextField(
                            controller: _emailController,
                            hintText: 'Email ${widget.data.role.toLowerCase()}',
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 12),
                          StaffTextField(
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
                                color: navy,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cream,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: navy.withOpacity(0.10),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Akun demo ${widget.data.role}',
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${widget.data.email} / ${widget.data.password}',
                                  style: TextStyle(
                                    color: navy.withOpacity(0.68),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: navy,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: _login,
                              icon: const Icon(Icons.person_rounded, size: 22),
                              label: Text(
                                'Masuk sebagai ${widget.data.role}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          color: navy.withOpacity(0.55),
                          size: 18,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'Akses hanya untuk staf yang berwenang',
                          style: TextStyle(
                            color: navy.withOpacity(0.58),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
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


class _OwnerBlob extends StatelessWidget {
  final double size;
  final double opacity;

  const _OwnerBlob({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FF).withOpacity(opacity),
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }
}

class StaffTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;

  const StaffTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
  });

  static const Color navy = Color(0xFF3B3D84);
  static const Color cream = Color(0xFFFFFAF6);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: navy,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: navy.withOpacity(0.42),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(icon, color: navy, size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: cream,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: navy.withOpacity(0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: navy.withOpacity(0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: navy, width: 1.4),
        ),
      ),
    );
  }
}

class DapurDashboardScreen extends StatelessWidget {
  const DapurDashboardScreen({super.key});

  static const Color navy = Color(0xFF3B3D84);
  static const Color cream = Color(0xFFFFFAF6);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: cream,
        systemNavigationBarColor: cream,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: cream,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                child: Row(
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: navy,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard Dapur',
                            style: GoogleFonts.montserratAlternates(
                              color: navy,
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Pesanan yang sudah dikirim dari kasir',
                            style: TextStyle(
                              color: navy.withOpacity(0.62),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<List<KasirOrder>>(
                  valueListenable: SeruputOrderStore.orders,
                  builder: (context, orders, child) {
                    final dapurOrders = orders
                        .where((order) => order.status == KasirOrderStatus.diproses)
                        .toList();

                    if (dapurOrders.isEmpty) {
                      return EmptyDashboardState(
                        icon: Icons.soup_kitchen_outlined,
                        title: 'Belum ada pesanan ke dapur',
                        subtitle:
                        'Pesanan akan muncul setelah kasir menekan tombol konfirmasi lunas dan kirim ke dapur.',
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                      itemCount: dapurOrders.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final order = dapurOrders[index];
                        return DapurOrderCard(order: order);
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

class DapurOrderCard extends StatelessWidget {
  final KasirOrder order;

  const DapurOrderCard({
    super.key,
    required this.order,
  });

  static const Color navy = Color(0xFF3B3D84);
  static const Color cream = Color(0xFFFFFAF6);

  void _finishOrder(BuildContext context) {
    SeruputOrderStore.updateOrder(
      order.copyWith(status: KasirOrderStatus.selesai),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: navy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Text(
          '${order.id} ditandai selesai.',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: navy,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.table_restaurant_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Meja ${order.tableNumber.toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        color: navy,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${order.id} • ${formatTime(order.createdAt)}',
                      style: TextStyle(
                        color: navy.withOpacity(0.55),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBackground(order.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Masak',
                  style: TextStyle(
                    color: statusColor(order.status),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: cream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${item.quantity}x',
                        style: const TextStyle(
                          color: navy,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            color: navy,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.detail,
                          style: TextStyle(
                            color: navy.withOpacity(0.62),
                            fontSize: 11.2,
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          if (order.customerNote.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Catatan: ${order.customerNote}',
                style: TextStyle(
                  color: navy.withOpacity(0.72),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => _finishOrder(context),
              icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
              label: const Text(
                'Tandai Pesanan Selesai',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  static const Color navy = Color(0xFF3B3D84);
  static const Color cream = Color(0xFFFFFAF6);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: cream,
        systemNavigationBarColor: cream,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: cream,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                child: Row(
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: navy,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard Owner',
                            style: GoogleFonts.montserratAlternates(
                              color: navy,
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Ringkasan transaksi Seruput',
                            style: TextStyle(
                              color: navy.withOpacity(0.62),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<List<KasirOrder>>(
                  valueListenable: SeruputOrderStore.orders,
                  builder: (context, orders, child) {
                    final menunggu = orders
                        .where((order) => order.status == KasirOrderStatus.menunggu)
                        .length;
                    final diproses = orders
                        .where((order) => order.status == KasirOrderStatus.diproses)
                        .length;
                    final selesai = orders
                        .where((order) => order.status == KasirOrderStatus.selesai)
                        .length;
                    final omzet = orders
                        .where((order) => order.status == KasirOrderStatus.selesai)
                        .fold<int>(0, (total, order) => total + order.totalPayment);

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.42,
                            children: [
                              OwnerStatCard(
                                title: 'Total Pesanan',
                                value: '${orders.length}',
                                icon: Icons.receipt_long_rounded,
                              ),
                              OwnerStatCard(
                                title: 'Omzet Selesai',
                                value: formatRupiah(omzet),
                                icon: Icons.payments_rounded,
                              ),
                              OwnerStatCard(
                                title: 'Menunggu Kasir',
                                value: '$menunggu',
                                icon: Icons.hourglass_top_rounded,
                              ),
                              OwnerStatCard(
                                title: 'Diproses Dapur',
                                value: '$diproses',
                                icon: Icons.soup_kitchen_rounded,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Pesanan Terbaru',
                                  style: GoogleFonts.montserratAlternates(
                                    color: navy,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9F9EE),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '$selesai selesai',
                                  style: const TextStyle(
                                    color: Color(0xFF2E8B57),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (orders.isEmpty)
                            EmptyDashboardState(
                              icon: Icons.receipt_long_outlined,
                              title: 'Belum ada data pesanan',
                              subtitle: 'Data akan muncul setelah customer membuat pesanan.',
                            )
                          else
                            ...orders.take(8).map((order) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: OwnerOrderTile(order: order),
                              );
                            }),
                        ],
                      ),
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

class OwnerStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const OwnerStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  static const Color navy = Color(0xFF3B3D84);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.055),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: navy, size: 25),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: navy,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: navy.withOpacity(0.60),
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class OwnerOrderTile extends StatelessWidget {
  final KasirOrder order;

  const OwnerOrderTile({
    super.key,
    required this.order,
  });

  static const Color navy = Color(0xFF3B3D84);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: navy.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: statusBackground(order.status),
              shape: BoxShape.circle,
            ),
            child: Icon(
              order.status == KasirOrderStatus.selesai
                  ? Icons.check_rounded
                  : order.status == KasirOrderStatus.diproses
                  ? Icons.soup_kitchen_rounded
                  : Icons.schedule_rounded,
              color: statusColor(order.status),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${order.id} • Meja ${order.tableNumber.toString().padLeft(2, '0')}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${order.totalItem} item • ${order.paymentMethod} • ${formatTime(order.createdAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: navy.withOpacity(0.58),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            formatRupiah(order.totalPayment),
            style: const TextStyle(
              color: navy,
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyDashboardState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyDashboardState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  static const Color navy = Color(0xFF3B3D84);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: navy.withOpacity(0.35),
              size: 88,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserratAlternates(
                color: navy,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: navy.withOpacity(0.62),
                fontSize: 13,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
