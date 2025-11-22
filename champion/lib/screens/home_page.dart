import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String championEmail;
  const HomePage({super.key, required this.championEmail});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  DateTime? _selectedDate;
  DateTime? _cutoffDate;
  String? _message;
  bool _loading = false;
  bool _isDeliveryPending = false; // Track if delivery is pending
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Enhanced community list with more details
  final List<Map<String, dynamic>> _communityMembers = [
    {
      'name': 'John Doe',
      'role': 'Customer',
      'avatar': Icons.person,
      'color': Colors.purple,
      'status': 'Active',
    },
    {
      'name': 'Bob Smith',
      'role': 'Customer',
      'avatar': Icons.person,
      'color': Colors.orange,
      'status': 'Active',
    },
    {
      'name': 'Charlie Davis',
      'role': 'Customer',
      'avatar': Icons.person,
      'color': Colors.green,
      'status': 'Active',
    },
    {
      'name': 'Dana Lee',
      'role': 'Customer',
      'avatar': Icons.person,
      'color': Colors.blue,
      'status': 'Active',
    },
    {
      'name': 'Evan Kim',
      'role': 'Customer',
      'avatar': Icons.person,
      'color': Colors.red,
      'status': 'Active',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();

    // Check if there's a pending delivery
    _checkPendingDelivery();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _checkPendingDelivery() {
    // Check if there's a selected date and it's still in the future
    if (_selectedDate != null) {
      final now = DateTime.now();
      final deliveryDate = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      );
      final today = DateTime(now.year, now.month, now.day);

      if (deliveryDate.isAfter(today)) {
        setState(() {
          _isDeliveryPending = true;
        });
      }
    }
  }

  void _openScanner() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scanner'),
        content: const Text(
          'Scanner functionality will be implemented here.\n\nIntegrate with packages like:\n• qr_code_scanner\n• barcode_scan2\n• mobile_scanner',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final minDate = today.add(const Duration(days: 10)); // 10 days from today
    final maxDate = DateTime(
      today.year,
      today.month + 3,
      today.day,
    ); // 3 months ahead

    final picked = await showDatePicker(
      context: context,
      initialDate: minDate,
      firstDate: minDate,
      lastDate: maxDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B5CF6),
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
      helpText: 'Select delivery date (minimum 10 days from today)',
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _loading = true;
        _message = null;
        _isDeliveryPending = true; // Set delivery as pending
      });
      await _sendAvailability(picked);
      setState(() => _loading = false);
    }
  }

  Future<void> _sendAvailability(DateTime date) async {
    final uri = Uri.parse('http://localhost:8000/availability');
    final body = {
      "champion_email": widget.championEmail,
      "selected_date": date.toIso8601String().split('T').first,
    };

    try {
      final resp = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        setState(() {
          _cutoffDate = DateTime.parse(data['cutoff_at']);
          _message = data['message'];
        });
      } else {
        setState(() => _message = "Server error: ${resp.statusCode}");
      }
    } catch (e) {
      setState(() => _message = "Error: $e");
    }
  }

  bool _canSelectNewDate() {
    if (_selectedDate == null) return true;

    final now = DateTime.now();
    final deliveryDate = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
    );
    final today = DateTime(now.year, now.month, now.day);

    // Allow new selection only if the delivery date has passed
    return deliveryDate.isBefore(today) || deliveryDate.isAtSameMomentAs(today);
  }

  Widget _buildDeliveryTab() {
    final canSelectDate = _canSelectNewDate();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Schedule Delivery',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      canSelectDate
                          ? 'Select your delivery date (minimum 10 days ahead)'
                          : 'Delivery pending - wait until current delivery is completed',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Delivery Status Info (when delivery is pending)
              if (_isDeliveryPending &&
                  _selectedDate != null &&
                  !canSelectDate) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFF59E0B).withOpacity(0.1),
                        const Color(0xFFD97706).withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFF59E0B).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.schedule,
                        color: Color(0xFFD97706),
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Delivery Pending',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD97706),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your delivery is scheduled for ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF92400E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'You can schedule a new delivery after this one is completed.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF92400E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Date Selection Button
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: canSelectDate
                      ? [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [],
                ),
                child: ElevatedButton(
                  onPressed: (_loading || !canSelectDate) ? null : _pickDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canSelectDate
                        ? const Color(0xFF8B5CF6)
                        : const Color(0xFF9CA3AF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              canSelectDate ? Icons.date_range : Icons.lock,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              canSelectDate
                                  ? 'Select Delivery Date'
                                  : 'Delivery Locked',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 32),

              // Date Restriction Info
              if (canSelectDate) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF3B82F6).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFF3B82F6),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Delivery dates must be at least 10 days from today',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF3B82F6).withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Selected Date Display
              if (_selectedDate != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF8B5CF6).withOpacity(0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF10B981),
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Selected Date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Cutoff Information
              if (_cutoffDate != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF10B981).withOpacity(0.1),
                        const Color(0xFF059669).withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color(0xFF059669),
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      if (_message != null)
                        Text(
                          _message!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF059669),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Order Cutoff Time',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${_cutoffDate!.day}/${_cutoffDate!.month}/${_cutoffDate!.year} at ${_cutoffDate!.hour.toString().padLeft(2, '0')}:${_cutoffDate!.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityTab() {
    return Column(
      children: [
        // Community Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Column(
            children: [
              Icon(Icons.group, size: 48, color: Colors.white),
              SizedBox(height: 16),
              Text(
                'My Community',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Connect with fellow champions',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),

        // Community Members List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _communityMembers.length,
            itemBuilder: (context, index) {
              final member = _communityMembers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: member['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      member['avatar'],
                      color: member['color'],
                      size: 28,
                    ),
                  ),
                  title: Text(
                    member['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        member['role'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: member['status'] == 'Active'
                                  ? const Color(0xFF10B981)
                                  : member['status'] == 'Online'
                                  ? const Color(0xFF3B82F6)
                                  : const Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            member['status'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    color: const Color(0xFF6B7280),
                    onPressed: () {
                      // Handle more options
                    },
                  ),
                  onTap: () {
                    // Handle member tap
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [_buildDeliveryTab(), _buildCommunityTab()];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'ChampionHub',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: const Color(0xFF8B5CF6),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _openScanner,
            tooltip: 'Scan QR Code',
          ),
        ],
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF8B5CF6),
          unselectedItemColor: const Color(0xFF6B7280),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Community',
            ),
          ],
        ),
      ),
    );
  }
}
