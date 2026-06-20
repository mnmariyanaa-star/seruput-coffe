import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'seruput_order_store.dart';

class MenuSeruputScreen extends StatefulWidget {
  const MenuSeruputScreen({super.key});

  @override
  State<MenuSeruputScreen> createState() => _MenuSeruputScreenState();
}

class _MenuSeruputScreenState extends State<MenuSeruputScreen> {
  static const Color navy = Color(0xFF3B3D84);
  static const Color cream = Color(0xFFFFFAF6);

  final TextEditingController _searchController = TextEditingController();

  String selectedCategory = 'Minuman';
  String searchQuery = '';

  final List<CartItem> cartItems = [];

  final List<MenuItem> menus = const [
    // =========================
    // MINUMAN
    // =========================
    MenuItem(
      name: 'Kopi Hitam',
      price: 10000,
      category: 'Minuman',
      imagePath: 'assets/images/menu_kopi_hitam.jpg',
      description: 'Kopi hitam klasik dengan aroma kuat dan rasa bold.',
      ingredients: 'Biji kopi robusta pilihan dan air panas.',
      isFavorite: true,
    ),
    MenuItem(
      name: 'Cappuccino',
      price: 20000,
      category: 'Minuman',
      imagePath: 'assets/images/menu_cappuccino.jpg',
      description: 'Kopi susu creamy dengan foam lembut di atasnya.',
      ingredients: 'Espresso, susu steamed, dan milk foam.',
      isFavorite: true,
    ),
    MenuItem(
      name: 'Sparkling Tea',
      price: 15000,
      category: 'Minuman',
      imagePath: 'assets/images/menu_sparkling_tea.jpg',
      description: 'Teh segar dengan sensasi sparkling yang ringan.',
      ingredients: 'Tea base, soda, lemon, simple syrup, dan es batu.',
      isFavorite: false,
    ),
    MenuItem(
      name: 'Matcha Latte',
      price: 22000,
      category: 'Minuman',
      imagePath: 'assets/images/menu_matcha_latte.jpg',
      description: 'Matcha latte lembut dengan rasa earthy dan creamy.',
      ingredients: 'Matcha powder, susu segar, gula, dan es batu.',
      isFavorite: true,
    ),
    MenuItem(
      name: 'Chocolate Milk',
      price: 18000,
      category: 'Minuman',
      imagePath: 'assets/images/menu_chocolate_milk.jpg',
      description: 'Minuman coklat manis creamy yang cocok diminum dingin.',
      ingredients: 'Coklat bubuk, susu segar, gula, dan es batu.',
      isFavorite: false,
    ),
    MenuItem(
      name: 'Lemon Tea',
      price: 14000,
      category: 'Minuman',
      imagePath: 'assets/images/menu_lemon_tea.jpg',
      description: 'Teh lemon segar dengan rasa manis asam seimbang.',
      ingredients: 'Teh hitam, lemon, simple syrup, dan es batu.',
      isFavorite: false,
    ),
    MenuItem(
      name: 'Caramel Macchiato',
      price: 25000,
      category: 'Minuman',
      imagePath: 'assets/images/menu_caramel_macchiato.jpg',
      description: 'Kopi susu dengan caramel manis dan aroma espresso.',
      ingredients: 'Espresso, susu, caramel syrup, dan foam lembut.',
      isFavorite: true,
    ),

    // =========================
    // MAKANAN
    // =========================
    MenuItem(
      name: 'Batagor Bandung',
      price: 25000,
      category: 'Makanan',
      imagePath: 'assets/images/menu_batagor.jpg',
      description: 'Batagor gurih dengan saus kacang khas Bandung.',
      ingredients: 'Ikan, tepung tapioka, tahu, pangsit, dan saus kacang.',
      isFavorite: true,
    ),
    MenuItem(
      name: 'Cireng',
      price: 10000,
      category: 'Makanan',
      imagePath: 'assets/images/menu_cireng.jpg',
      description: 'Cireng renyah di luar dan kenyal di dalam.',
      ingredients: 'Tepung aci, bawang putih, bumbu gurih, dan saus cocol.',
      isFavorite: false,
    ),
    MenuItem(
      name: 'Nasi Goreng',
      price: 23000,
      category: 'Makanan',
      imagePath: 'assets/images/menu_nasi_goreng.jpg',
      description: 'Nasi goreng rumahan dengan rasa gurih dan wangi.',
      ingredients: 'Nasi, telur, bawang, kecap, ayam suwir, dan kerupuk.',
      isFavorite: true,
    ),
    MenuItem(
      name: 'Mie Goreng',
      price: 22000,
      category: 'Makanan',
      imagePath: 'assets/images/menu_mie_goreng.jpg',
      description: 'Mie goreng manis gurih dengan topping lengkap.',
      ingredients: 'Mie, telur, sayur, kecap, ayam, dan bawang goreng.',
      isFavorite: false,
    ),
    MenuItem(
      name: 'Chicken Katsu',
      price: 28000,
      category: 'Makanan',
      imagePath: 'assets/images/menu_chicken_katsu.jpg',
      description: 'Ayam katsu crispy dengan nasi hangat dan saus.',
      ingredients: 'Dada ayam, tepung roti, nasi, salad, dan saus katsu.',
      isFavorite: true,
    ),
    MenuItem(
      name: 'French Fries',
      price: 16000,
      category: 'Makanan',
      imagePath: 'assets/images/menu_french_fries.jpg',
      description: 'Kentang goreng renyah cocok untuk camilan.',
      ingredients: 'Kentang pilihan, garam, bumbu tabur, dan saus.',
      isFavorite: false,
    ),
    MenuItem(
      name: 'Dimsum Ayam',
      price: 24000,
      category: 'Makanan',
      imagePath: 'assets/images/menu_dimsum.jpg',
      description: 'Dimsum ayam lembut dengan saus pedas manis.',
      ingredients: 'Ayam cincang, kulit dimsum, wortel, dan saus.',
      isFavorite: true,
    ),

    // =========================
    // DESSERT
    // =========================
    MenuItem(
      name: 'Cheese Cake',
      price: 30000,
      category: 'Dessert',
      imagePath: 'assets/images/menu_cheesecake.jpg',
      description: 'Cheese cake lembut dengan rasa manis creamy.',
      ingredients: 'Cream cheese, biskuit, gula, butter, dan topping berry.',
      isFavorite: true,
    ),
    MenuItem(
      name: 'Brownies',
      price: 18000,
      category: 'Dessert',
      imagePath: 'assets/images/menu_brownies.jpg',
      description: 'Brownies coklat padat dengan tekstur fudgy.',
      ingredients: 'Coklat, tepung, telur, butter, gula, dan cocoa powder.',
      isFavorite: true,
    ),
    MenuItem(
      name: 'Pancake',
      price: 22000,
      category: 'Dessert',
      imagePath: 'assets/images/menu_pancake.jpg',
      description: 'Pancake fluffy dengan topping manis.',
      ingredients: 'Tepung, telur, susu, butter, madu, dan topping buah.',
      isFavorite: false,
    ),
    MenuItem(
      name: 'Waffle Ice Cream',
      price: 26000,
      category: 'Dessert',
      imagePath: 'assets/images/menu_waffle.jpg',
      description: 'Waffle hangat dengan es krim lembut.',
      ingredients: 'Adonan waffle, es krim vanilla, syrup, dan topping.',
      isFavorite: true,
    ),
    MenuItem(
      name: 'Donat Gula',
      price: 12000,
      category: 'Dessert',
      imagePath: 'assets/images/menu_donat.jpg',
      description: 'Donat empuk dengan taburan gula halus.',
      ingredients: 'Tepung terigu, ragi, gula, telur, susu, dan butter.',
      isFavorite: false,
    ),
    MenuItem(
      name: 'Pudding Coklat',
      price: 15000,
      category: 'Dessert',
      imagePath: 'assets/images/menu_pudding.jpg',
      description: 'Pudding coklat lembut dengan vla manis.',
      ingredients: 'Coklat, susu, agar-agar, gula, dan vla vanilla.',
      isFavorite: false,
    ),
    MenuItem(
      name: 'Banana Split',
      price: 25000,
      category: 'Dessert',
      imagePath: 'assets/images/menu_banana_split.jpg',
      description: 'Pisang dengan es krim dan topping manis.',
      ingredients: 'Pisang, es krim, whipped cream, syrup, dan cherry.',
      isFavorite: true,
    ),
  ];

  int get cartCount {
    return cartItems.fold(0, (total, item) => total + item.quantity);
  }

  List<MenuItem> get filteredMenus {
    final query = searchQuery.trim().toLowerCase();

    return menus.where((item) {
      final bool matchCategory =
      query.isEmpty ? item.category == selectedCategory : true;

      final bool matchSearch = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.ingredients.toLowerCase().contains(query);

      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String rupiah(int value) {
    return 'Rp ${value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
    )}';
  }

  void addToCart(CartItem newItem) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.isSameOrder(newItem));

      if (index >= 0) {
        cartItems[index] = cartItems[index].copyWith(
          quantity: cartItems[index].quantity + newItem.quantity,
        );
      } else {
        cartItems.add(newItem);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: navy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Text(
          '${newItem.item.name} masuk ke keranjang',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          cartItems: cartItems,
          onCartUpdated: () {
            setState(() {});
          },
          rupiah: rupiah,
        ),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                SizedBox(height: smallScreen ? 14 : 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Menu Seruput',
                        style: GoogleFonts.montserratAlternates(
                          color: navy,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: openCart,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: navy.withOpacity(0.08),
                                  blurRadius: 14,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: navy,
                            ),
                          ),
                          Positioned(
                            top: -5,
                            right: -3,
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: const BoxDecoration(
                                color: navy,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$cartCount',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: navy.withOpacity(0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: navy.withOpacity(0.55),
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                          style: const TextStyle(
                            color: navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Cari minuman, makanan, dessert...',
                            hintStyle: TextStyle(
                              color: navy.withOpacity(0.45),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (searchQuery.isNotEmpty)
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            setState(() {
                              searchQuery = '';
                              _searchController.clear();
                            });
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: navy.withOpacity(0.55),
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    CategoryChipSeruput(
                      title: 'Minuman',
                      icon: Icons.local_drink_rounded,
                      isSelected: selectedCategory == 'Minuman',
                      onTap: () {
                        setState(() {
                          selectedCategory = 'Minuman';
                          searchQuery = '';
                          _searchController.clear();
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    CategoryChipSeruput(
                      title: 'Makanan',
                      icon: Icons.restaurant_rounded,
                      isSelected: selectedCategory == 'Makanan',
                      onTap: () {
                        setState(() {
                          selectedCategory = 'Makanan';
                          searchQuery = '';
                          _searchController.clear();
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    CategoryChipSeruput(
                      title: 'Dessert',
                      icon: Icons.cake_rounded,
                      isSelected: selectedCategory == 'Dessert',
                      onTap: () {
                        setState(() {
                          selectedCategory = 'Dessert';
                          searchQuery = '';
                          _searchController.clear();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filteredMenus.isEmpty
                      ? Center(
                    child: Text(
                      'Menu tidak ditemukan',
                      style: GoogleFonts.montserratAlternates(
                        color: navy.withOpacity(0.65),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                      : GridView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: filteredMenus.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      mainAxisExtent: 238,
                    ),
                    itemBuilder: (context, index) {
                      final item = filteredMenus[index];

                      return MenuCard(
                        item: item,
                        priceText: rupiah(item.price),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                item: item,
                                onAddToCart: addToCart,
                              ),
                            ),
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
      ),
    );
  }
}

class CategoryChipSeruput extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChipSeruput({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  static const Color navy = Color(0xFF3B3D84);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isSelected ? navy : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: navy.withOpacity(0.18),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: isSelected ? Colors.white : navy,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final MenuItem item;
  final String priceText;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.item,
    required this.priceText,
    required this.onTap,
  });

  static const Color navy = Color(0xFF3B3D84);
  static const Color softImageBg = Color(0xFFF8F7FF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: navy.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
                child: item.isFavorite
                    ? Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEFE0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Fav',
                      style: TextStyle(
                        color: Color(0xFFB56A2B),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 4),
              Center(
                child: Hero(
                  tag: item.name,
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    padding: EdgeInsets.all(
                      item.category == 'Minuman' ? 9 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: softImageBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        item.imagePath,
                        fit: item.category == 'Minuman'
                            ? BoxFit.contain
                            : BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: softImageBg,
                            child: Icon(
                              item.category == 'Minuman'
                                  ? Icons.local_drink_rounded
                                  : item.category == 'Makanan'
                                  ? Icons.restaurant_rounded
                                  : Icons.cake_rounded,
                              color: navy.withOpacity(0.45),
                              size: 44,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: navy,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                priceText,
                style: TextStyle(
                  color: navy.withOpacity(0.78),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 30,
                decoration: BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Pilih Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                    ),
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

class ProductDetailScreen extends StatefulWidget {
  final MenuItem item;
  final ValueChanged<CartItem> onAddToCart;

  const ProductDetailScreen({
    super.key,
    required this.item,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const Color navy = Color(0xFF3B3D84);
  static const Color cream = Color(0xFFFFFAF6);

  final TextEditingController _noteController = TextEditingController();

  String selectedCup = 'Medium';
  String selectedTemperature = 'Dingin';
  String selectedSweetness = 'Normal';
  String selectedIce = 'Normal';

  int quantity = 1;

  bool get isDrink => widget.item.category == 'Minuman';

  @override
  void initState() {
    super.initState();

    if (widget.item.name == 'Kopi Hitam') {
      selectedTemperature = 'Panas';
      selectedIce = 'No Ice';
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String rupiah(int value) {
    return 'Rp ${value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
    )}';
  }

  int get totalPrice => widget.item.price * quantity;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

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
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: item.isFavorite
                                ? const Color(0xFFE76565)
                                : navy,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            item.isFavorite ? 'Favorit' : 'Menu',
                            style: const TextStyle(
                              color: navy,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Hero(
                          tag: item.name,
                          child: Image.asset(
                            item.imagePath,
                            height: 210,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                item.category == 'Minuman'
                                    ? Icons.local_drink_rounded
                                    : item.category == 'Makanan'
                                    ? Icons.restaurant_rounded
                                    : Icons.cake_rounded,
                                color: navy.withOpacity(0.45),
                                size: 120,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
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
                            if (item.isFavorite)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEFE0),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Paling Favorit',
                                  style: TextStyle(
                                    color: Color(0xFFB56A2B),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            if (item.isFavorite) const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: GoogleFonts.montserratAlternates(
                                      color: navy,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Text(
                                  rupiah(item.price),
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.description,
                              style: TextStyle(
                                color: navy.withOpacity(0.75),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const OptionTitle(title: 'Terbuat dari'),
                            const SizedBox(height: 6),
                            Text(
                              item.ingredients,
                              style: TextStyle(
                                color: navy.withOpacity(0.70),
                                fontSize: 12.5,
                                height: 1.4,
                              ),
                            ),
                            if (isDrink) ...[
                              const SizedBox(height: 18),
                              const OptionTitle(title: 'Pilihan Cup'),
                              const SizedBox(height: 8),
                              OptionWrap(
                                options: const ['Small', 'Medium', 'Large'],
                                selected: selectedCup,
                                onSelected: (value) {
                                  setState(() {
                                    selectedCup = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              const OptionTitle(title: 'Suhu Minuman'),
                              const SizedBox(height: 8),
                              OptionWrap(
                                options: const ['Panas', 'Dingin'],
                                selected: selectedTemperature,
                                onSelected: (value) {
                                  setState(() {
                                    selectedTemperature = value;

                                    if (value == 'Panas') {
                                      selectedIce = 'No Ice';
                                    } else {
                                      selectedIce = 'Normal';
                                    }
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              const OptionTitle(title: 'Level Manis'),
                              const SizedBox(height: 8),
                              OptionWrap(
                                options: const [
                                  'Tidak Manis',
                                  'Less Sugar',
                                  'Normal',
                                  'Extra Sweet',
                                ],
                                selected: selectedSweetness,
                                onSelected: (value) {
                                  setState(() {
                                    selectedSweetness = value;
                                  });
                                },
                              ),
                              if (selectedTemperature == 'Dingin') ...[
                                const SizedBox(height: 16),
                                const OptionTitle(title: 'Level Es'),
                                const SizedBox(height: 8),
                                OptionWrap(
                                  options: const [
                                    'No Ice',
                                    'Less Ice',
                                    'Normal',
                                    'Extra Ice',
                                  ],
                                  selected: selectedIce,
                                  onSelected: (value) {
                                    setState(() {
                                      selectedIce = value;
                                    });
                                  },
                                ),
                              ],
                            ],
                            const SizedBox(height: 16),
                            const OptionTitle(title: 'Catatan Tambahan'),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _noteController,
                              maxLines: 3,
                              style: const TextStyle(
                                color: navy,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                'Contoh: gula sedikit, takeaway, tanpa topping...',
                                hintStyle: TextStyle(
                                  color: navy.withOpacity(0.45),
                                  fontSize: 12,
                                ),
                                filled: true,
                                fillColor: cream,
                                contentPadding: const EdgeInsets.all(14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: navy.withOpacity(0.12),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: navy.withOpacity(0.12),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: navy,
                                    width: 1.4,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: cream,
                                    foregroundColor: navy,
                                  ),
                                  onPressed: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      color: navy,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: navy,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                                const Spacer(),
                                Text(
                                  rupiah(totalPrice),
                                  style: const TextStyle(
                                    color: navy,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
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
              Container(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
                decoration: BoxDecoration(
                  color: cream,
                  boxShadow: [
                    BoxShadow(
                      color: navy.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      final note = _noteController.text.trim();

                      final cartItem = CartItem(
                        item: item,
                        quantity: quantity,
                        cup: isDrink ? selectedCup : null,
                        temperature: isDrink ? selectedTemperature : null,
                        sweetness: isDrink ? selectedSweetness : null,
                        ice: isDrink
                            ? selectedTemperature == 'Dingin'
                            ? selectedIce
                            : 'No Ice'
                            : null,
                        note: note,
                      );

                      widget.onAddToCart(cartItem);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Tambah ke Keranjang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final VoidCallback onCartUpdated;
  final String Function(int value) rupiah;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onCartUpdated,
    required this.rupiah,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const Color navy = Color(0xFF3B3D84);
  static const Color cream = Color(0xFFFFFAF6);

  final TextEditingController _orderNoteController = TextEditingController();

  int selectedTable = 1;
  String selectedPayment = 'QRIS';

  int get subtotalPrice {
    return widget.cartItems.fold(0, (total, item) => total + item.totalPrice);
  }

  int get serviceFee {
    return (subtotalPrice * 0.05).round();
  }

  int get totalPrice {
    return subtotalPrice + serviceFee;
  }

  int get totalQuantity {
    return widget.cartItems.fold(0, (total, item) => total + item.quantity);
  }

  @override
  void dispose() {
    _orderNoteController.dispose();
    super.dispose();
  }

  void updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        widget.cartItems.removeAt(index);
      } else {
        widget.cartItems[index] = widget.cartItems[index].copyWith(
          quantity: newQuantity,
        );
      }
    });

    widget.onCartUpdated();
  }

  void removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });

    widget.onCartUpdated();
  }

  void clearCart() {
    setState(() {
      widget.cartItems.clear();
    });

    widget.onCartUpdated();
  }

  List<KasirOrderItem> _buildKasirOrderItems() {
    return widget.cartItems.map((cartItem) {
      return KasirOrderItem(
        name: cartItem.item.name,
        price: cartItem.item.price,
        quantity: cartItem.quantity,
        imagePath: cartItem.item.imagePath,
        detail: cartItem.optionSummary,
      );
    }).toList();
  }

  String _generateOrderId() {
    final now = DateTime.now();

    final yy = (now.year % 100).toString().padLeft(2, '0');
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    final serial = (now.millisecondsSinceEpoch % 1000).toString().padLeft(3, '0');

    return '#ORD-$yy$mm$dd-$serial';
  }

  void _sendOrderToKasir(String paymentMethod, {String? orderId}) {
    final note = _orderNoteController.text.trim();

    final order = KasirOrder(
      id: orderId ?? _generateOrderId(),
      tableNumber: selectedTable,
      items: _buildKasirOrderItems(),
      customerNote: note.isEmpty ? 'Tidak ada catatan tambahan.' : note,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
      status: KasirOrderStatus.menunggu,
    );

    SeruputOrderStore.addOrder(order);
  }

  void showPaymentSheet() {
    final note = _orderNoteController.text.trim();
    final rootContext = context;

    if (selectedPayment == 'QRIS') {
      final orderId = _generateOrderId();

      Navigator.push(
        rootContext,
        MaterialPageRoute(
          builder: (context) => QrisPaymentScreen(
            orderId: orderId,
            totalPrice: totalPrice,
            totalQuantity: totalQuantity,
            selectedTable: selectedTable,
            note: note,
            rupiah: widget.rupiah,
          ),
        ),
      ).then((paid) {
        if (paid == true) {
          _sendOrderToKasir('QRIS', orderId: orderId);
          clearCart();

          if (mounted) {
            Navigator.pop(rootContext);
          }
        }
      });

      return;
    }

    // =========================
    // TUNAI DI KASIR
    // =========================
    // Nomor pesanan dibuat sebelum popup tampil,
    // jadi nomor yang dilihat customer sama dengan yang masuk ke kasir.
    final cashOrderId = _generateOrderId();

    showModalBottomSheet(
      context: rootContext,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                22,
                22,
                22,
                22 + MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: navy.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: navy,
                      size: 46,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Pesanan Dicatat',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserratAlternates(
                      color: navy,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tunjukkan nomor pesanan ini ke kasir untuk pembayaran tunai.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: navy.withOpacity(0.65),
                      fontSize: 12.8,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cream,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: navy.withOpacity(0.12),
                      ),
                    ),
                    child: Column(
                      children: [
                        _ReceiptRow(
                          title: 'Nomor Pesanan',
                          value: cashOrderId,
                          isBold: true,
                        ),
                        _ReceiptRow(
                          title: 'Jumlah Item',
                          value: '$totalQuantity item',
                        ),
                        _ReceiptRow(
                          title: 'Nomor Meja',
                          value: 'Meja $selectedTable',
                        ),
                        const _ReceiptRow(
                          title: 'Pembayaran',
                          value: 'Tunai di Kasir',
                        ),
                        const _ReceiptRow(
                          title: 'Status',
                          value: 'Belum Dibayar',
                        ),
                        _ReceiptRow(
                          title: 'Subtotal',
                          value: widget.rupiah(subtotalPrice),
                        ),
                        _ReceiptRow(
                          title: 'Biaya Layanan',
                          value: widget.rupiah(serviceFee),
                        ),
                        _ReceiptRow(
                          title: 'Total Bayar',
                          value: widget.rupiah(totalPrice),
                          isBold: true,
                        ),
                        if (note.isNotEmpty)
                          _ReceiptRow(
                            title: 'Catatan',
                            value: note,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4E3),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFFB56A2B),
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Pesanan akan masuk ke kasir dengan status menunggu pembayaran. Kasir akan konfirmasi setelah pembayaran tunai diterima.',
                            style: TextStyle(
                              color: navy.withOpacity(0.70),
                              fontSize: 11.8,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: navy,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(sheetContext);

                        _sendOrderToKasir('Tunai', orderId: cashOrderId);

                        ScaffoldMessenger.of(rootContext).showSnackBar(
                          SnackBar(
                            backgroundColor: navy,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            content: Text(
                              'Pesanan $cashOrderId masuk ke kasir',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );

                        clearCart();

                        if (mounted) {
                          Navigator.pop(rootContext);
                        }
                      },
                      child: const Text(
                        'Selesai',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = widget.cartItems.isEmpty;

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
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Keranjang',
                        style: GoogleFonts.montserratAlternates(
                          color: navy,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (!isEmpty)
                      TextButton(
                        onPressed: clearCart,
                        child: const Text(
                          'Hapus',
                          style: TextStyle(
                            color: navy,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: isEmpty
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          color: navy.withOpacity(0.35),
                          size: 92,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Keranjang masih kosong',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserratAlternates(
                            color: navy,
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pilih minuman, makanan, atau dessert dulu, nanti pesanannya masuk ke sini.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: navy.withOpacity(0.65),
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.cartItems.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12);
                        },
                        itemBuilder: (context, index) {
                          final cartItem = widget.cartItems[index];

                          return CartItemCard(
                            cartItem: cartItem,
                            rupiah: widget.rupiah,
                            onMinus: () {
                              updateQuantity(
                                index,
                                cartItem.quantity - 1,
                              );
                            },
                            onPlus: () {
                              updateQuantity(
                                index,
                                cartItem.quantity + 1,
                              );
                            },
                            onRemove: () {
                              removeItem(index);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
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
                            const OptionTitle(title: 'Nomor Meja'),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: List.generate(10, (index) {
                                final table = index + 1;
                                final selected = selectedTable == table;

                                return InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () {
                                    setState(() {
                                      selectedTable = table;
                                    });
                                  },
                                  child: Container(
                                    width: 42,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: selected ? navy : cream,
                                      borderRadius:
                                      BorderRadius.circular(14),
                                      border: Border.all(
                                        color: navy.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$table',
                                        style: TextStyle(
                                          color: selected
                                              ? Colors.white
                                              : navy,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 16),
                            const OptionTitle(title: 'Lokasi'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: cream,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: navy.withOpacity(0.12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: navy,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Seruput Coffee - Dine In, Meja $selectedTable',
                                      style: TextStyle(
                                        color: navy.withOpacity(0.75),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const OptionTitle(title: 'Catatan Pesanan'),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _orderNoteController,
                              maxLines: 3,
                              style: const TextStyle(
                                color: navy,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                'Contoh: antar ke meja dekat jendela...',
                                hintStyle: TextStyle(
                                  color: navy.withOpacity(0.45),
                                  fontSize: 12,
                                ),
                                filled: true,
                                fillColor: cream,
                                contentPadding: const EdgeInsets.all(14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: navy.withOpacity(0.12),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: navy.withOpacity(0.12),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: navy,
                                    width: 1.4,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const OptionTitle(title: 'Pembayaran'),
                            const SizedBox(height: 8),
                            OptionWrap(
                              options: const ['QRIS', 'Tunai di Kasir'],
                              selected: selectedPayment,
                              onSelected: (value) {
                                setState(() {
                                  selectedPayment = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isEmpty)
                Container(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
                  decoration: BoxDecoration(
                    color: cream,
                    boxShadow: [
                      BoxShadow(
                        color: navy.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, -8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total $totalQuantity item',
                              style: TextStyle(
                                color: navy.withOpacity(0.65),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              widget.rupiah(totalPrice),
                              style: const TextStyle(
                                color: navy,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: showPaymentSheet,
                          child: Text(
                            selectedPayment == 'QRIS' ? 'Bayar QRIS' : 'Bayar',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
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

class QrisPaymentScreen extends StatefulWidget {
  final String orderId;
  final int totalPrice;
  final int totalQuantity;
  final int selectedTable;
  final String note;
  final String Function(int value) rupiah;

  const QrisPaymentScreen({
    super.key,
    required this.orderId,
    required this.totalPrice,
    required this.totalQuantity,
    required this.selectedTable,
    required this.note,
    required this.rupiah,
  });

  @override
  State<QrisPaymentScreen> createState() => _QrisPaymentScreenState();
}

class _QrisPaymentScreenState extends State<QrisPaymentScreen> {
  static const Color navy = Color(0xFF3B3D84);
  static const Color cream = Color(0xFFFFFAF6);

  late final String orderId;
  late final String qrData;

  Timer? _timer;
  int remainingSeconds = 300;
  bool isPaid = false;

  @override
  void initState() {
    super.initState();

    orderId = widget.orderId;

    qrData =
    'SERUPUT-QRIS-DEMO|ORDER:$orderId|TOTAL:${widget.totalPrice}|MEJA:${widget.selectedTable}';

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds <= 0 || isPaid) {
        timer.cancel();
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get timerText {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void confirmPayment() {
    setState(() {
      isPaid = true;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSuccessScreen(
              orderId: orderId,
              totalPrice: widget.totalPrice,
              totalQuantity: widget.totalQuantity,
              selectedTable: widget.selectedTable,
              note: widget.note,
              rupiah: widget.rupiah,
            ),
          ),
        ).then((value) {
          if (value == true && mounted) {
            Navigator.pop(context, true);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isExpired = remainingSeconds <= 0;

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
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: navy,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Pembayaran QRIS',
                        style: GoogleFonts.montserratAlternates(
                          color: navy,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: navy.withOpacity(0.07),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: isPaid
                                    ? const Color(0xFFE9F9EE)
                                    : isExpired
                                    ? const Color(0xFFFFE9E9)
                                    : const Color(0xFFFFF4E3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isPaid
                                    ? 'Pembayaran Berhasil'
                                    : isExpired
                                    ? 'QRIS Kedaluwarsa'
                                    : 'Menunggu Pembayaran',
                                style: TextStyle(
                                  color: isPaid
                                      ? const Color(0xFF2E8B57)
                                      : isExpired
                                      ? const Color(0xFFC94B4B)
                                      : const Color(0xFFB56A2B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.rupiah(widget.totalPrice),
                              style: GoogleFonts.montserratAlternates(
                                color: navy,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${widget.totalQuantity} item • Meja ${widget.selectedTable}',
                              style: TextStyle(
                                color: navy.withOpacity(0.65),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: cream,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: navy.withOpacity(0.12),
                                ),
                              ),
                              child: QrImageView(
                                data: qrData,
                                version: QrVersions.auto,
                                size: 230,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Order ID: $orderId',
                              style: TextStyle(
                                color: navy.withOpacity(0.55),
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: cream,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Scan QR ini pakai mobile banking atau e-wallet.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: navy.withOpacity(0.72),
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Waktu pembayaran: $timerText',
                                    style: const TextStyle(
                                      color: navy,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.note.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                'Catatan: ${widget.note}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: navy.withOpacity(0.65),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: navy.withOpacity(0.7),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Ini QRIS demo untuk tampilan aplikasi. Untuk uang asli perlu payment gateway/merchant QRIS.',
                                style: TextStyle(
                                  color: navy.withOpacity(0.65),
                                  fontSize: 11.8,
                                  height: 1.35,
                                  fontWeight: FontWeight.w600,
                                ),
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
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
                decoration: BoxDecoration(
                  color: cream,
                  boxShadow: [
                    BoxShadow(
                      color: navy.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPaid
                          ? const Color(0xFF2E8B57)
                          : isExpired
                          ? Colors.grey
                          : navy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: isExpired || isPaid ? null : confirmPayment,
                    child: Text(
                      isPaid
                          ? 'Pembayaran Berhasil'
                          : isExpired
                          ? 'QRIS Kedaluwarsa'
                          : 'Saya Sudah Bayar',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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

class PaymentSuccessScreen extends StatelessWidget {
  final String orderId;
  final int totalPrice;
  final int totalQuantity;
  final int selectedTable;
  final String note;
  final String Function(int value) rupiah;

  const PaymentSuccessScreen({
    super.key,
    required this.orderId,
    required this.totalPrice,
    required this.totalQuantity,
    required this.selectedTable,
    required this.note,
    required this.rupiah,
  });

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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: navy.withOpacity(0.07),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 92,
                            height: 92,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE9F9EE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Color(0xFF2E8B57),
                              size: 58,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Pembayaran Berhasil',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserratAlternates(
                              color: navy,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pesanan kamu sedang disiapkan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: navy.withOpacity(0.65),
                              fontSize: 13,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _ReceiptRow(
                            title: 'Order ID',
                            value: orderId,
                          ),
                          _ReceiptRow(
                            title: 'Jumlah Item',
                            value: '$totalQuantity item',
                          ),
                          _ReceiptRow(
                            title: 'Nomor Meja',
                            value: 'Meja $selectedTable',
                          ),
                          _ReceiptRow(
                            title: 'Pembayaran',
                            value: 'QRIS',
                          ),
                          _ReceiptRow(
                            title: 'Total',
                            value: rupiah(totalPrice),
                            isBold: true,
                          ),
                          if (note.isNotEmpty)
                            _ReceiptRow(
                              title: 'Catatan',
                              value: note,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      'Kembali ke Menu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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

class _ReceiptRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;

  const _ReceiptRow({
    required this.title,
    required this.value,
    this.isBold = false,
  });

  static const Color navy = Color(0xFF3B3D84);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: navy.withOpacity(0.60),
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: navy,
                fontSize: isBold ? 14.5 : 12.5,
                fontWeight: isBold ? FontWeight.w900 : FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final String Function(int value) rupiah;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.rupiah,
    required this.onMinus,
    required this.onPlus,
    required this.onRemove,
  });

  static const Color navy = Color(0xFF3B3D84);
  static const Color cream = Color(0xFFFFFAF6);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 78,
            height: 78,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Image.asset(
              cartItem.item.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  cartItem.item.category == 'Minuman'
                      ? Icons.local_drink_rounded
                      : cartItem.item.category == 'Makanan'
                      ? Icons.restaurant_rounded
                      : Icons.cake_rounded,
                  color: navy.withOpacity(0.45),
                  size: 40,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        cartItem.item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: onRemove,
                      child: Icon(
                        Icons.close_rounded,
                        color: navy.withOpacity(0.55),
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  cartItem.optionSummary,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: navy.withOpacity(0.62),
                    fontSize: 11.5,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      rupiah(cartItem.totalPrice),
                      style: const TextStyle(
                        color: navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: onMinus,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: cream,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: navy,
                          size: 17,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      child: Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(
                          color: navy,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: onPlus,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: navy,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 17,
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
    );
  }
}

class OptionTitle extends StatelessWidget {
  final String title;

  const OptionTitle({
    super.key,
    required this.title,
  });

  static const Color navy = Color(0xFF3B3D84);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.montserratAlternates(
        color: navy,
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class OptionWrap extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const OptionWrap({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  static const Color navy = Color(0xFF3B3D84);
  static const Color cream = Color(0xFFFFFAF6);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final bool isSelected = option == selected;

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            onSelected(option);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isSelected ? navy : cream,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: navy.withOpacity(0.18),
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.white : navy,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class MenuItem {
  final String name;
  final int price;
  final String category;
  final String imagePath;
  final String description;
  final String ingredients;
  final bool isFavorite;

  const MenuItem({
    required this.name,
    required this.price,
    required this.category,
    required this.imagePath,
    required this.description,
    required this.ingredients,
    required this.isFavorite,
  });
}

class CartItem {
  final MenuItem item;
  final int quantity;
  final String? cup;
  final String? temperature;
  final String? sweetness;
  final String? ice;
  final String note;

  const CartItem({
    required this.item,
    required this.quantity,
    this.cup,
    this.temperature,
    this.sweetness,
    this.ice,
    required this.note,
  });

  int get totalPrice => item.price * quantity;

  bool get isDrink => item.category == 'Minuman';

  String get optionSummary {
    final List<String> parts = [];

    if (isDrink) {
      if (cup != null) parts.add('Cup: $cup');
      if (temperature != null) parts.add('Suhu: $temperature');
      if (sweetness != null) parts.add('Manis: $sweetness');
      if (ice != null) parts.add('Es: $ice');
    }

    if (note.trim().isNotEmpty) {
      parts.add('Catatan: $note');
    }

    if (parts.isEmpty) {
      return 'Tanpa catatan tambahan';
    }

    return parts.join(' • ');
  }

  bool isSameOrder(CartItem other) {
    return item.name == other.item.name &&
        cup == other.cup &&
        temperature == other.temperature &&
        sweetness == other.sweetness &&
        ice == other.ice &&
        note.trim() == other.note.trim();
  }

  CartItem copyWith({
    int? quantity,
    String? note,
  }) {
    return CartItem(
      item: item,
      quantity: quantity ?? this.quantity,
      cup: cup,
      temperature: temperature,
      sweetness: sweetness,
      ice: ice,
      note: note ?? this.note,
    );
  }
}
