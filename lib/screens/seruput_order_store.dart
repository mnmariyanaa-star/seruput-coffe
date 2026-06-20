import 'package:flutter/material.dart';

// =====================================================
// FILE: seruput_order_store.dart
// Fungsi:
// 1. Menjadi pusat data pesanan sementara untuk 4 role.
// 2. Customer menambahkan pesanan ke sini.
// 3. Kasir, Dapur, dan Owner membaca data yang sama dari sini.
// 4. Nanti saat Firebase siap, isi class SeruputOrderStore ini bisa diganti
//    menjadi query Firestore tanpa mengubah banyak UI.
//
// Catatan:
// Data masih lokal dalam 1 aplikasi. Data akan hilang saat aplikasi ditutup.
// Untuk real-time antar device/HP, gunakan Firebase Firestore.
// =====================================================

const Color seruputNavy = Color(0xFF3B3D84);
const Color seruputCream = Color(0xFFFFFAF6);
const Color seruputSoftPurple = Color(0xFFEDE9FF);
const Color seruputOrangeSoft = Color(0xFFFFF4E3);
const Color seruputGreenSoft = Color(0xFFE9F9EE);
const Color seruputGreen = Color(0xFF2E8B57);

enum KasirOrderStatus { menunggu, diproses, selesai }

class KasirOrderItem {
  final String name;
  final int price;
  final int quantity;
  final String imagePath;
  final String detail;

  const KasirOrderItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imagePath,
    required this.detail,
  });

  int get totalPrice => price * quantity;

  KasirOrderItem copyWith({
    String? name,
    int? price,
    int? quantity,
    String? imagePath,
    String? detail,
  }) {
    return KasirOrderItem(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imagePath: imagePath ?? this.imagePath,
      detail: detail ?? this.detail,
    );
  }
}

class KasirOrder {
  final String id;
  final int tableNumber;
  final List<KasirOrderItem> items;
  final String customerNote;
  final String paymentMethod;
  final DateTime createdAt;
  final KasirOrderStatus status;

  const KasirOrder({
    required this.id,
    required this.tableNumber,
    required this.items,
    required this.customerNote,
    required this.paymentMethod,
    required this.createdAt,
    required this.status,
  });

  int get totalItem {
    return items.fold(0, (total, item) => total + item.quantity);
  }

  int get subtotal {
    return items.fold(0, (total, item) => total + item.totalPrice);
  }

  int get serviceFee {
    return (subtotal * 0.05).round();
  }

  int get totalPayment {
    return subtotal + serviceFee;
  }

  KasirOrder copyWith({
    String? id,
    int? tableNumber,
    List<KasirOrderItem>? items,
    String? customerNote,
    String? paymentMethod,
    DateTime? createdAt,
    KasirOrderStatus? status,
  }) {
    return KasirOrder(
      id: id ?? this.id,
      tableNumber: tableNumber ?? this.tableNumber,
      items: items ?? this.items,
      customerNote: customerNote ?? this.customerNote,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}

class SeruputOrderStore {
  // Ubah ke true kalau kamu masih mau melihat contoh data saat aplikasi dibuka.
  static const bool useDemoOrders = false;

  static final ValueNotifier<List<KasirOrder>> orders =
  ValueNotifier<List<KasirOrder>>(useDemoOrders ? _dummyOrders() : []);

  static void addOrder(KasirOrder order) {
    final alreadyExists = orders.value.any((item) => item.id == order.id);

    if (alreadyExists) {
      updateOrder(order);
      return;
    }

    orders.value = [order, ...orders.value];
  }

  static void updateOrder(KasirOrder updatedOrder) {
    orders.value = orders.value.map((order) {
      if (order.id == updatedOrder.id) return updatedOrder;
      return order;
    }).toList();
  }

  static KasirOrder? findById(String id) {
    for (final order in orders.value) {
      if (order.id == id) return order;
    }
    return null;
  }

  static void clearAllOrders() {
    orders.value = [];
  }

  static List<KasirOrder> _dummyOrders() {
    return [
      KasirOrder(
        id: '#ORD-250511-005',
        tableNumber: 5,
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
        paymentMethod: 'Tunai',
        status: KasirOrderStatus.menunggu,
        customerNote: 'Tolong es tehnya kurang manis ya, terima kasih! 😊',
        items: const [
          KasirOrderItem(
            name: 'Cappuccino',
            price: 20000,
            quantity: 1,
            imagePath: 'assets/images/menu_cappuccino.jpg',
            detail: 'Cup: Medium • Suhu: Dingin • Manis: Normal • Es: Normal',
          ),
          KasirOrderItem(
            name: 'Sparkling Tea',
            price: 15000,
            quantity: 1,
            imagePath: 'assets/images/menu_sparkling_tea.jpg',
            detail: 'Cup: Medium • Suhu: Dingin • Manis: Less Sugar • Es: Normal',
          ),
          KasirOrderItem(
            name: 'Batagor Bandung',
            price: 25000,
            quantity: 1,
            imagePath: 'assets/images/menu_batagor.jpg',
            detail: 'Tanpa catatan tambahan',
          ),
        ],
      ),
      KasirOrder(
        id: '#ORD-250511-004',
        tableNumber: 3,
        createdAt: DateTime.now().subtract(const Duration(minutes: 6)),
        paymentMethod: 'QRIS',
        status: KasirOrderStatus.menunggu,
        customerNote: 'Takeaway untuk satu minuman.',
        items: const [
          KasirOrderItem(
            name: 'Chicken Katsu',
            price: 28000,
            quantity: 1,
            imagePath: 'assets/images/menu_chicken_katsu.jpg',
            detail: 'Tanpa catatan tambahan',
          ),
          KasirOrderItem(
            name: 'Matcha Latte',
            price: 22000,
            quantity: 1,
            imagePath: 'assets/images/menu_matcha_latte.jpg',
            detail: 'Cup: Large • Suhu: Dingin • Manis: Normal • Es: Less Ice',
          ),
          KasirOrderItem(
            name: 'French Fries',
            price: 16000,
            quantity: 1,
            imagePath: 'assets/images/menu_french_fries.jpg',
            detail: 'Saus dipisah',
          ),
        ],
      ),
      KasirOrder(
        id: '#ORD-250511-003',
        tableNumber: 7,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        paymentMethod: 'Tunai',
        status: KasirOrderStatus.diproses,
        customerNote: 'Pesanan dine in.',
        items: const [
          KasirOrderItem(
            name: 'Brownies',
            price: 18000,
            quantity: 1,
            imagePath: 'assets/images/menu_brownies.jpg',
            detail: 'Tanpa catatan tambahan',
          ),
        ],
      ),
      KasirOrder(
        id: '#ORD-250511-002',
        tableNumber: 1,
        createdAt: DateTime.now().subtract(const Duration(minutes: 14)),
        paymentMethod: 'QRIS',
        status: KasirOrderStatus.selesai,
        customerNote: 'Tanpa catatan tambahan.',
        items: const [
          KasirOrderItem(
            name: 'Lemon Tea',
            price: 14000,
            quantity: 1,
            imagePath: 'assets/images/menu_lemon_tea.jpg',
            detail: 'Cup: Medium • Suhu: Dingin • Manis: Normal • Es: Normal',
          ),
          KasirOrderItem(
            name: 'Kopi Hitam',
            price: 10000,
            quantity: 1,
            imagePath: 'assets/images/menu_kopi_hitam.jpg',
            detail: 'Cup: Small • Suhu: Panas • Manis: Tidak Manis • Es: No Ice',
          ),
        ],
      ),
    ];
  }
}

String formatRupiah(int value) {
  return 'Rp ${value.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]}.',
  )}';
}

String formatTime(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute WIB';
}

String statusText(KasirOrder order) {
  if (order.status == KasirOrderStatus.diproses) return 'Diproses Dapur';
  if (order.status == KasirOrderStatus.selesai) return 'Selesai';
  if (order.paymentMethod.toLowerCase().contains('tunai')) {
    return 'Menunggu Pembayaran Kasir';
  }
  return 'Menunggu Konfirmasi Kasir';
}

Color statusBackground(KasirOrderStatus status) {
  switch (status) {
    case KasirOrderStatus.menunggu:
      return seruputOrangeSoft;
    case KasirOrderStatus.diproses:
      return const Color(0xFFE9F0FF);
    case KasirOrderStatus.selesai:
      return seruputGreenSoft;
  }
}

Color statusColor(KasirOrderStatus status) {
  switch (status) {
    case KasirOrderStatus.menunggu:
      return const Color(0xFFB56A2B);
    case KasirOrderStatus.diproses:
      return seruputNavy;
    case KasirOrderStatus.selesai:
      return seruputGreen;
  }
}
