import 'package:flutter/material.dart';
import 'package:prueba/screens/complete_purchase.dart';

class PurchaseConfirmationScreen extends StatelessWidget {
  final List<String> cart;

  const PurchaseConfirmationScreen({super.key, required this.cart});

  double calculateTotal() {
    return cart.fold(0.0, (sum, item) {
      List<String> productInfo = item.split('|');
      double price = double.tryParse(productInfo[2].replaceAll('\$', '')) ?? 0.0;
      return sum + price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Confirmación de Compra',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total a pagar: \$${calculateTotal().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final productInfo = cart[index].split('|');
                  return ListTile(
                    leading: Image.network(productInfo[3], width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(productInfo[0]),
                    subtitle: Text('Cantidad: ${productInfo[1]}'),
                    trailing: Text(productInfo[2]),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompletePurchaseScreen(cart: cart),
                  ),
                );
              },
              child: const Center(
                child: Text('Finalizar Compra', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}