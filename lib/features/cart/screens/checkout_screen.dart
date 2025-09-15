import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawfect_care/core/theme/app_theme.dart';
import 'package:pawfect_care/core/services/user_service.dart';
import 'package:pawfect_care/features/cart/providers/cart_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();
  
  // Shipping Information
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Payment Information
  final _cardNumberController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  
  String _selectedPaymentMethod = 'credit_card';
  String _selectedShippingMethod = 'standard';
  bool _isProcessing = false;
  
  final Map<String, String> _paymentMethods = {
    'credit_card': 'Credit Card',
    'paypal': 'PayPal',
    'apple_pay': 'Apple Pay',
    'google_pay': 'Google Pay',
  };
  
  final Map<String, Map<String, dynamic>> _shippingMethods = {
    'standard': {
      'name': 'Standard Shipping',
      'duration': '5-7 business days',
      'cost': 5.99,
    },
    'express': {
      'name': 'Express Shipping',
      'duration': '2-3 business days',
      'cost': 12.99,
    },
    'overnight': {
      'name': 'Overnight Shipping',
      'duration': 'Next business day',
      'cost': 24.99,
    },
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _userService.currentUser;
    if (user != null) {
      _fullNameController.text = user['name'] ?? '';
      _phoneController.text = user['phone'] ?? '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  double get shippingCost => _shippingMethods[_selectedShippingMethod]!['cost'];
  double get finalTotal => widget.totalAmount + shippingCost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
            } else {
              context.go('/cart');
            }
          },
        ),
      ),
      body: _isProcessing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing your order...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Summary
                    _buildOrderSummary(),
                    const SizedBox(height: 24),
                    
                    // Shipping Information
                    _buildSectionTitle('Shipping Information', Iconsax.location),
                    const SizedBox(height: 16),
                    _buildShippingForm(),
                    const SizedBox(height: 24),
                    
                    // Shipping Method
                    _buildSectionTitle('Shipping Method', Iconsax.truck),
                    const SizedBox(height: 16),
                    _buildShippingMethodSelector(),
                    const SizedBox(height: 24),
                    
                    // Payment Method
                    _buildSectionTitle('Payment Method', Iconsax.card),
                    const SizedBox(height: 16),
                    _buildPaymentMethodSelector(),
                    const SizedBox(height: 16),
                    _buildPaymentForm(),
                    const SizedBox(height: 24),
                    
                    // Order Total
                    _buildOrderTotal(),
                    const SizedBox(height: 24),
                    
                    // Place Order Button
                    _buildPlaceOrderButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          ...widget.cartItems.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.pets, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pet Product ${item['product_id']}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Qty: ${item['quantity']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${(widget.totalAmount / widget.cartItems.length).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildShippingForm() {
    return Column(
      children: [
        TextFormField(
          controller: _fullNameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter your full name',
            prefixIcon: const Icon(Iconsax.user),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) => value?.isEmpty == true ? 'Please enter your full name' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            hintText: 'Enter your street address',
            prefixIcon: const Icon(Iconsax.home),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) => value?.isEmpty == true ? 'Please enter your address' : null,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  hintText: 'Enter city',
                  prefixIcon: const Icon(Iconsax.building),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value?.isEmpty == true ? 'Please enter city' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _stateController,
                decoration: InputDecoration(
                  labelText: 'State',
                  hintText: 'State',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value?.isEmpty == true ? 'Please enter state' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _zipCodeController,
                decoration: InputDecoration(
                  labelText: 'ZIP',
                  hintText: 'ZIP',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value?.isEmpty == true ? 'Please enter ZIP code' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            hintText: 'Enter your phone number',
            prefixIcon: const Icon(Iconsax.call),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) => value?.isEmpty == true ? 'Please enter your phone number' : null,
        ),
      ],
    );
  }

  Widget _buildShippingMethodSelector() {
    return Column(
      children: _shippingMethods.entries.map((entry) {
        final method = entry.value;
        final isSelected = _selectedShippingMethod == entry.key;
        
        return GestureDetector(
          onTap: () => setState(() => _selectedShippingMethod = entry.key),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.radio,
                  color: isSelected ? AppTheme.primaryColor : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppTheme.primaryColor : Colors.black,
                        ),
                      ),
                      Text(
                        method['duration'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${method['cost'].toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppTheme.primaryColor : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: _paymentMethods.entries.map((entry) {
          final isSelected = _selectedPaymentMethod == entry.key;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedPaymentMethod = entry.key),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.radio,
                    color: isSelected ? AppTheme.primaryColor : Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 12),
                  _getPaymentIcon(entry.key),
                  const SizedBox(width: 12),
                  Text(
                    entry.value,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppTheme.primaryColor : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _getPaymentIcon(String method) {
    switch (method) {
      case 'credit_card':
        return const Icon(Iconsax.card, size: 20);
      case 'paypal':
        return Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFF0070BA),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: const Center(
            child: Text(
              'PP',
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        );
      case 'apple_pay':
        return Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: const Icon(Icons.apple, color: Colors.white, size: 16),
        );
      case 'google_pay':
        return Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFF4285F4),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: const Center(
            child: Text(
              'G',
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        );
      default:
        return const Icon(Iconsax.card, size: 20);
    }
  }

  Widget _buildPaymentForm() {
    if (_selectedPaymentMethod == 'credit_card') {
      return Column(
        children: [
          TextFormField(
            controller: _cardNumberController,
            decoration: InputDecoration(
              labelText: 'Card Number',
              hintText: '1234 5678 9012 3456',
              prefixIcon: const Icon(Iconsax.card),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (value) => value?.isEmpty == true ? 'Please enter card number' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cardNameController,
            decoration: InputDecoration(
              labelText: 'Cardholder Name',
              hintText: 'Name on card',
              prefixIcon: const Icon(Iconsax.user),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (value) => value?.isEmpty == true ? 'Please enter cardholder name' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryController,
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    hintText: 'MM/YY',
                    prefixIcon: const Icon(Iconsax.calendar),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Please enter expiry date' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    prefixIcon: const Icon(Iconsax.security_card),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Please enter CVV' : null,
                ),
              ),
            ],
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildOrderTotal() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal'),
              Text('\$${widget.totalAmount.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shipping (${_shippingMethods[_selectedShippingMethod]!['name']})'),
              Text('\$${shippingCost.toStringAsFixed(2)}'),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${finalTotal.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _placeOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Place Order',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      // Simulate order processing
      await Future.delayed(const Duration(seconds: 2));

      // Clear the cart
      ref.read(cartNotifierProvider.notifier).clearCart();

      // Create order data
      final orderData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'items': widget.cartItems,
        'shipping': {
          'name': _fullNameController.text,
          'address': _addressController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'zip': _zipCodeController.text,
          'phone': _phoneController.text,
          'method': _shippingMethods[_selectedShippingMethod]!['name'],
          'cost': shippingCost,
        },
        'payment': {
          'method': _paymentMethods[_selectedPaymentMethod],
          'total': finalTotal,
        },
        'status': 'confirmed',
        'tracking': {
          'number': 'PC${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
          'status': 'processing',
          'estimatedDelivery': DateTime.now().add(const Duration(days: 3)),
        },
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Navigate to order confirmation
      if (mounted) {
        context.go('/order-confirmation', extra: orderData);
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
