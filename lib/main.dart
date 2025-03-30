import 'package:flutter/material.dart';

void main() {
  runApp(StockManagerApp());
}

class StockManagerApp extends StatelessWidget {
  const StockManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Stock',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StockScreen(),
    );
  }
}

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final List<Map<String, dynamic>> _stockList = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // Fonction pour ajouter un produit
  void _addProduct() {
    if (_nameController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      // Vérification si la quantité saisie est un nombre valide
      int? quantity = int.tryParse(_quantityController.text);
      if (quantity != null && quantity > 0) {
        setState(() {
          _stockList.add({'name': _nameController.text, 'quantity': quantity});
        });
        _nameController.clear();
        _quantityController.clear();
      } else {
        // Afficher une erreur si la quantité n'est pas un nombre valide
        _showErrorDialog('Veuillez entrer une quantité valide.');
      }
    }
  }

  // Fonction pour supprimer un produit
  void _removeProduct(int index) {
    setState(() {
      _stockList.removeAt(index);
    });
  }

  // Fonction pour mettre à jour la quantité d'un produit
  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      _stockList[index]['quantity'] = newQuantity;
    });
  }

  // Fonction pour afficher une boîte de dialogue pour modifier la quantité
  void _showUpdateDialog(int index) {
    TextEditingController updateController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Modifier la quantité'),
            content: TextField(
              controller: updateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Nouvelle quantité'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (updateController.text.isNotEmpty) {
                    int? newQuantity = int.tryParse(updateController.text);
                    if (newQuantity != null && newQuantity > 0) {
                      _updateQuantity(index, newQuantity);
                      Navigator.pop(context);
                    } else {
                      _showErrorDialog('Veuillez entrer une quantité valide.');
                    }
                  }
                },
                child: Text('Mettre à jour'),
              ),
            ],
          ),
    );
  }

  // Fonction pour afficher un message d'erreur
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Erreur'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Fermer'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestion de Stock')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de texte pour le nom du produit
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom du produit'),
            ),
            SizedBox(height: 10),
            // Champ de texte pour la quantité du produit
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Quantité'),
            ),
            SizedBox(height: 10),
            // Bouton pour ajouter un produit
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Ajouter Produit'),
            ),
            // Affichage des produits dans la liste
            Expanded(
              child: ListView.builder(
                itemCount: _stockList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_stockList[index]['name']),
                      subtitle: Text(
                        'Quantité: ${_stockList[index]['quantity']}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Bouton pour éditer la quantité
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showUpdateDialog(index),
                          ),
                          // Bouton pour supprimer le produit
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeProduct(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
