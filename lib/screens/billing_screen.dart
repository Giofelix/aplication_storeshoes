import 'package:flutter/material.dart';

class BillingScreen extends StatelessWidget {
  final List<String> cart;

  const BillingScreen({super.key, required this.cart});

  double calculateTotal() {
    return cart.fold(0.0, (sum, item) {
      List<String> productInfo = item.split('|');
      double price = double.tryParse(productInfo[2].replaceAll('\$', '')) ?? 0.0;
      int quantity = int.tryParse(productInfo[1]) ?? 1;
      if (quantity <= 0) return sum;
      return sum + (price * quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Factura'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fecha de Compra: ${DateTime.now().toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final productInfo = cart[index].split('|');
                  return ListTile(
                    title: Text(productInfo[0]),
                    subtitle: Text('Cantidad: ${productInfo[1]}'),
                    trailing: Text(productInfo[2]),
                  );
                },
              ),
            ),
            const Divider(height: 32, thickness: 1),
            Text(
              'Total: \$${calculateTotal().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pago confirmado exitosamente.')),
                  );
                },
                child: const Text('Confirmar Pago'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}