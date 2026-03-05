import 'package:flutter/material.dart';
import '../models/folder.dart';
import '../models/card_item.dart';
import '../repositories/card_repository.dart';

class CardsScreen extends StatefulWidget {
  final Folder folder;

  const CardsScreen({super.key, required this.folder});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final CardRepository _cardRepo = CardRepository();
  List<PlayingCard> _cards = [];
  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards = await _cardRepo.getCardsByFolder(widget.folder.id!);
    setState(() {
      _cards = cards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.folder.folderName)),
      body: _cards.isEmpty
      ? const Center(child: Text("No cards in this folder"))
      : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
        return GestureDetector(
          onTap: () {},
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (card.imageUrl != null)
                Image.asset(
                  card.imageUrl!,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                Text(
                  card.cardName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(card.suit),
              ],
            ),
          ),
        );
      },
      ),
    );
  }
}