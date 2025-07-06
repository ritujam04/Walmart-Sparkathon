import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onCardPressed() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onCardPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.grey.shade50],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced Image Container
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 110,
                          height: 110,
                          child: Stack(
                            children: [
                              // Main Image
                              SizedBox.expand(
                                child: widget.product.imageUrl != null
                                    ? Image.network(
                                        widget.product.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey.shade200,
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey.shade400,
                                            size: 40,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        color: Colors.grey.shade200,
                                        child: Icon(
                                          Icons.shopping_bag_outlined,
                                          color: Colors.grey.shade400,
                                          size: 40,
                                        ),
                                      ),
                              ),
                              // Gradient Overlay
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Enhanced Details Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row: Title + Favorite icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.product.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isFavorite = !_isFavorite;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _isFavorite
                                        ? Colors.red.shade50
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _isFavorite
                                        ? Colors.red
                                        : Colors.grey.shade600,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Description
                          Text(
                            widget.product.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 16),

                          // Bottom Row: Price + Add to Cart
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Enhanced Price Tag
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF667eea).withOpacity(0.1),
                                      const Color(0xFF764ba2).withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF667eea,
                                    ).withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '₹${widget.product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF667eea),
                                    fontSize: 16,
                                  ),
                                ),
                              ),

                              // Enhanced Add to Cart Button
                              Consumer<CartProvider>(
                                builder: (context, cart, child) {
                                  final isInCart = cart.items.any(
                                    (item) => item.id == widget.product.id,
                                  );

                                  if (!isInCart) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF667eea),
                                            Color(0xFF764ba2),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF667eea,
                                            ).withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          onTap: () {
                                            cart.addToCart(widget.product);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.check_circle,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      '${widget.product.name} added to cart',
                                                    ),
                                                  ],
                                                ),
                                                backgroundColor: Colors.green,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                duration: const Duration(
                                                  seconds: 2,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.add_shopping_cart,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  'Add',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    final item = cart.items.firstWhere(
                                      (i) => i.id == widget.product.id,
                                    );
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              onTap: () {
                                                cart.decreaseQuantity(
                                                  widget.product.id,
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 18,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            child: Text(
                                              '${item.quantity}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              onTap: () {
                                                cart.increaseQuantity(
                                                  widget.product.id,
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 18,
                                                  color: Color(0xFF667eea),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
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
          ),
        ),
      ),
    );
  }
}
