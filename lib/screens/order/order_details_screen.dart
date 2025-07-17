import 'package:demoapp/constants.dart';
import 'package:demoapp/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/champion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color walmartBlue = Color(0xFF0071CE);
const Color walmartYellow = Color(0xFFFFB400);

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final TextEditingController pincodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Champion> champions = [];
  Champion? selectedChampion;
  bool isPlacingOrder = false;
  bool isLoadingChampions = false;
  bool hasSearched = false;

  @override
  void dispose() {
    pincodeController.dispose();
    super.dispose();
  }

  Future<void> fetchChampionsByAddress(String address) async {
    setState(() {
      isLoadingChampions = true;
      hasSearched = false;
    });

    try {
      final apiKey = dotenv.env['OPENCAGE_API_KEY'];
      final url =
          'https://api.opencagedata.com/geocode/v1/json?q=${Uri.encodeComponent(address)}&key=$apiKey';

      final geoResponse = await http.get(Uri.parse(url));
      final geoData = json.decode(geoResponse.body);

      if (geoData['results'] == null || geoData['results'].isEmpty) {
        _showErrorSnackBar("Address not found. Please try again.");
        return;
      }

      final lat = geoData['results'][0]['geometry']['lat'];
      final lng = geoData['results'][0]['geometry']['lng'];

      final championUrl = Uri.parse(
        '$BASE_URL/champions/nearby?lat=$lat&lng=$lng',
      );
      final championResponse = await http.get(championUrl);

      if (championResponse.statusCode == 200) {
        final data = json.decode(championResponse.body);
        setState(() {
          champions = (data as List)
              .map((json) => Champion.fromJson(json))
              .toList();
          selectedChampion = null;
          hasSearched = true;
        });
      } else {
        _showErrorSnackBar("Failed to fetch champions");
      }
    } catch (e) {
      _showErrorSnackBar("Something went wrong. Check your internet.");
    } finally {
      setState(() {
        isLoadingChampions = false;
      });
    }
  }

  Future<void> placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cart = Provider.of<CartProvider>(context, listen: false);

    if (selectedChampion == null) {
      _showErrorSnackBar("Please select a champion");
      return;
    }

    setState(() => isPlacingOrder = true);
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user == null) {
      _showErrorSnackBar("User not logged in");
      return;
    }
    final orderPayload = {
      'user_id': user.id,
      'champion_id': selectedChampion!.id,
      'total_amount': cart.totalPrice,
      'order_items': cart.items
          .map(
            (item) => {
              'product_id': item.id,
              'name': item.name,
              'quantity': item.quantity,
              'unit_price': item.price,
              'subtotal': item.quantity * item.price,
            },
          )
          .toList(),
    };

    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/place-order'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderPayload),
      );

      if (response.statusCode == 200) {
        cart.clearCart();
        Navigator.pushReplacementNamed(context, '/order-confirmation');
      } else {
        _showErrorSnackBar('Order placement failed. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('Network error. Please check your connection.');
    } finally {
      setState(() => isPlacingOrder = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          'Confirm Your Order',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: walmartBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderSummaryCard(cart),
              const SizedBox(height: 24),
              _buildAddressSection(),
              const SizedBox(height: 24),
              _buildChampionSection(),
              const SizedBox(height: 32),
              _buildPlaceOrderButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard(CartProvider cart) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_cart, color: walmartBlue),
                const SizedBox(width: 10),
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: walmartBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...cart.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(child: Text('${item.name} (x${item.quantity})')),
                    Text('₹${(item.price * item.quantity).toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: walmartBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController addressController = TextEditingController();

  Widget _buildAddressSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: walmartBlue),
                const SizedBox(width: 8),
                const Text(
                  'Enter Delivery Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: "E.g. 123 Main Street, Mumbai",
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Please enter address';
                return null;
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: isLoadingChampions
                  ? CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    )
                  : Icon(Icons.search),
              label: Text(
                isLoadingChampions ? 'Searching...' : 'Find Champions',
              ),
              onPressed: () {
                final addr = addressController.text.trim();
                if (addr.isNotEmpty) fetchChampionsByAddress(addr);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: walmartBlue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChampionSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: walmartBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person, color: walmartBlue, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Select Champion',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (!hasSearched && champions.isEmpty)
              _infoCard(
                Icons.info_outline,
                'Please enter your pincode to find available champions',
                Colors.grey[600],
              )
            else if (hasSearched && champions.isEmpty)
              _infoCard(
                Icons.warning_amber,
                'No champions available in your area. Please try a different pincode.',
                Colors.orange[800],
              )
            else if (champions.isNotEmpty)
              Column(
                children: champions
                    .map((champ) => _buildChampionCard(champ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icon, String message, Color? color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color ?? Colors.grey),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: TextStyle(color: color, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildChampionCard(Champion champ) {
    final isSelected = selectedChampion?.id == champ.id;
    final isAvailable = champ.status;

    return GestureDetector(
      onTap: isAvailable
          ? () => setState(() => selectedChampion = champ)
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? walmartBlue.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? walmartBlue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isAvailable ? Colors.green[100] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.person,
                color: isAvailable ? Colors.green : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    champ.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isAvailable ? Colors.black : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    champ.address,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        isAvailable ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: isAvailable ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isAvailable ? 'Available' : 'Unavailable',
                        style: TextStyle(
                          fontSize: 12,
                          color: isAvailable ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: walmartBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: isPlacingOrder
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.shopping_cart_checkout),
        label: Text(
          isPlacingOrder ? 'Placing Order...' : 'Place Order',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: walmartBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        onPressed: isPlacingOrder ? null : placeOrder,
      ),
    );
  }
}
