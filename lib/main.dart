import 'package:flutter/material.dart';

void main() => runApp(const HujaifaBakeryApp());

const brand = Color(0xFF7B2D43);
const cream = Color(0xFFFFF8F1);

class HujaifaBakeryApp extends StatelessWidget {
  const HujaifaBakeryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hujaifa Bakery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: brand, surface: cream),
      ),
      home: const BakeryHomePage(),
    );
  }
}

class BakeryProduct {
  final String name, description, emoji, category;
  final int price;
  const BakeryProduct(this.name, this.description, this.price, this.emoji, this.category);
}

const products = <BakeryProduct>[
  BakeryProduct('চকলেট কেক', 'সমৃদ্ধ চকলেট ক্রিমে তৈরি', 650, '🍫', 'কেক'),
  BakeryProduct('ভ্যানিলা কেক', 'নরম স্পঞ্জ ও ভ্যানিলা ক্রিম', 550, '🍰', 'কেক'),
  BakeryProduct('রেড ভেলভেট', 'বিশেষ দিনের জন্য', 850, '❤️', 'কেক'),
  BakeryProduct('চিকেন পেটিস', 'মচমচে ও মজাদার', 35, '🥐', 'পেস্ট্রি'),
  BakeryProduct('ভেজিটেবল প্যাটিস', 'সবজির পুরে তৈরি', 30, '🥟', 'পেস্ট্রি'),
  BakeryProduct('ক্রিম রোল', 'মিষ্টি ক্রিমে ভরা', 40, '🧁', 'পেস্ট্রি'),
];

class BakeryHomePage extends StatefulWidget {
  const BakeryHomePage({super.key});
  @override
  State<BakeryHomePage> createState() => _BakeryHomePageState();
}

class _BakeryHomePageState extends State<BakeryHomePage> {
  String category = 'সব';
  final Map<BakeryProduct, int> cart = {};
  int get itemCount => cart.values.fold(0, (a, b) => a + b);
  int get total => cart.entries.fold(0, (sum, e) => sum + e.key.price * e.value);

  @override
  Widget build(BuildContext context) {
    final shown = products.where((p) => category == 'সব' || p.category == category).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Hujaifa Bakery', style: TextStyle(fontWeight: FontWeight.w800)),
          Text('তাজা স্বাদ, ভালোবাসার সাথে', style: TextStyle(fontSize: 11, color: Colors.black54)),
        ]),
        actions: [
          IconButton(
            tooltip: 'কার্ট',
            onPressed: _showCart,
            icon: Badge(label: Text('$itemCount'), child: const Icon(Icons.shopping_bag_outlined)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [brand, Color(0xFFB65C70)]),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('প্রতিটি কামড়ে\nআনন্দের ছোঁয়া!', style: TextStyle(color: Colors.white, fontSize: 25, height: 1.35, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('আপনার পছন্দের কেক ও পেস্ট্রি অর্ডার করুন', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 14),
              Row(children: [Icon(Icons.location_on, color: Colors.white, size: 17), SizedBox(width: 4), Text('ডেলিভারি: বগুড়া', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))]),
            ]),
          ),
          const SizedBox(height: 22),
          const Text('আমাদের মেনু', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: brand)),
          const SizedBox(height: 12),
          Wrap(spacing: 8, children: ['সব', 'কেক', 'পেস্ট্রি'].map((c) => ChoiceChip(
            label: Text(c), selected: category == c,
            selectedColor: brand.withValues(alpha: .16),
            onSelected: (_) => setState(() => category = c),
          )).toList()),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            itemCount: shown.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .78,
            ),
            itemBuilder: (context, index) {
              final p = shown[index];
              return Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFF0E5E0))),
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Center(child: Text(p.emoji, style: const TextStyle(fontSize: 58)))),
                  Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 3),
                  Text(p.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54, fontSize: 11)),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: Text('৳ ${p.price}', style: const TextStyle(color: brand, fontWeight: FontWeight.w800, fontSize: 16))),
                    IconButton.filled(
                      visualDensity: VisualDensity.compact,
                      style: IconButton.styleFrom(backgroundColor: brand),
                      onPressed: () => setState(() => cart[p] = (cart[p] ?? 0) + 1),
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ]),
                ]),
              );
            },
          ),
          const SizedBox(height: 20),
          const Center(child: Text('Hujaifa Bakery • বগুড়া', style: TextStyle(color: Colors.black45, fontSize: 12))),
        ],
      ),
      bottomNavigationBar: itemCount == 0 ? null : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: brand, padding: const EdgeInsets.all(15)),
            onPressed: _showCart,
            icon: const Icon(Icons.shopping_bag_outlined),
            label: Text('কার্ট দেখুন • $itemCount টি • ৳ $total'),
          ),
        ),
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet(
      context: context, isScrollControlled: true, showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(builder: (context, refresh) {
        final entries = cart.entries.toList();
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('আপনার কার্ট', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: brand)),
            const SizedBox(height: 12),
            if (entries.isEmpty) const Padding(padding: EdgeInsets.all(20), child: Center(child: Text('কার্ট এখন খালি'))),
            ...entries.map((e) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(e.key.name),
              subtitle: Text('৳ ${e.key.price} × ${e.value}'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(onPressed: () { setState(() { if (e.value <= 1) { cart.remove(e.key); } else { cart[e.key] = e.value - 1; } }); refresh(() {}); }, icon: const Icon(Icons.remove_circle_outline)),
                Text('${e.value}'),
                IconButton(onPressed: () { setState(() => cart[e.key] = e.value + 1); refresh(() {}); }, icon: const Icon(Icons.add_circle_outline)),
              ]),
            )),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('সর্বমোট', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('৳ $total', style: const TextStyle(fontWeight: FontWeight.bold, color: brand, fontSize: 18)),
            ]),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: brand, padding: const EdgeInsets.all(14)),
              onPressed: cart.isEmpty ? null : () {
                Navigator.pop(sheetContext);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('অর্ডার ও OTP সংযোগ পরবর্তী ধাপে যুক্ত হবে।')));
              },
              child: const Text('অর্ডার নিশ্চিত করুন'),
            )),
            const SizedBox(height: 8),
            const Text('নোট: এই প্রাথমিক সংস্করণে অর্ডার এখনো সার্ভারে পাঠানো হয় না।', style: TextStyle(color: Colors.black54, fontSize: 11)),
          ]),
        );
      }),
    );
  }
}
