import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _error = '';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _animationController;
  late AnimationController _headerAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    fetchProducts();
    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _headerAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.116.163:8000/products'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _products = data.map((item) => Product.fromJson(item)).toList();
          _filteredProducts = _products;
          _isLoading = false;
        });
        _animationController.forward();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    await fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Enhanced Header Section
            AnimatedBuilder(
              animation: _headerAnimationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(-1.0, -1.0),
                          end: Alignment(1.0, 1.0),
                          colors: [
                            Color(0xFF667eea),
                            Color(0xFF764ba2),
                            Color(0xFF6B73FF),
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF667eea).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // App Bar Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.white.withOpacity(
                                                  0.3,
                                                ),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.storefront_rounded,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Text(
                                            'Replenish',
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: Colors.greenAccent,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.greenAccent
                                                      .withOpacity(0.5),
                                                  blurRadius: 4,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Find everything you need',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Enhanced Search Bar
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: _filterProducts,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Search products, brands, categories...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 16,
                                    ),
                                    prefixIcon: Container(
                                      margin: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF667eea),
                                            Color(0xFF764ba2),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.search_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    suffixIcon: _searchQuery.isNotEmpty
                                        ? Container(
                                            margin: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.clear_rounded,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                _searchController.clear();
                                                _filterProducts('');
                                              },
                                            ),
                                          )
                                        : Container(
                                            margin: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.tune_rounded,
                                                color: Colors.grey[600],
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                // Add filter functionality here
                                              },
                                            ),
                                          ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Content Section
            Expanded(
              child: _isLoading
                  ? _buildLoadingWidget()
                  : _error.isNotEmpty
                  ? _buildErrorWidget()
                  : _buildProductsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Loading products...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.red.shade600,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refreshProducts,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667eea),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
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

  Widget _buildProductsList() {
    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.search_off,
                size: 40,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No products found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty
                  ? 'No products available at the moment'
                  : 'Try searching with different keywords',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshProducts,
      color: const Color(0xFF667eea),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ProductCard(product: _filteredProducts[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
