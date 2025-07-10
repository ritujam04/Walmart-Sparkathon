import 'dart:async';
import 'package:demoapp/providers/auth_provider.dart';
import 'package:demoapp/providers/order_provider.dart';
import 'package:demoapp/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    Future.microtask(() {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final userId = auth.user?.id;
      if (userId != null) {
        final orderProvider = Provider.of<OrderProvider>(
          context,
          listen: false,
        );
        orderProvider.fetchOrders(userId);
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final orders = orderProvider.orders;
    final userId = authProvider.user?.id;

    if (userId == null) {
      return _buildNotLoggedInState();
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade600, Colors.blue.shade800],
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildBody(orderProvider, orders, userId),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    OrderProvider orderProvider,
    List<Order> orders,
    int userId,
  ) {
    if (orderProvider.loading) {
      return _buildLoadingState();
    }

    return RefreshIndicator(
      onRefresh: () => orderProvider.fetchOrders(userId),
      color: Colors.blue.shade600,
      backgroundColor: Colors.white,
      child: orders.isEmpty ? _buildEmptyState() : _buildOrdersList(orders),
    );
  }

  Widget _buildOrdersList(List<Order> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOutBack,
          margin: const EdgeInsets.only(bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: OrderCard(
                order: orders[index],
                onOrderDelivered: () {
                  final userId = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  ).user?.id;
                  if (userId != null) {
                    Provider.of<OrderProvider>(
                      context,
                      listen: false,
                    ).fetchOrders(userId);
                    setState(() {});
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No Orders Yet',
        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
      ),
    );
  }

  Widget _buildNotLoggedInState() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Text(
          'Please log in to view your orders.',
          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
        ),
      ),
    );
  }
}
