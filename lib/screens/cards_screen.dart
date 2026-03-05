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
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 260,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              //later: open add/edit card screen
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 2.5 / 3.5,
                        child: card.imageUrl == null
                            ? Container(
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported),
                        )
                            : Image.asset(
                          card.imageUrl!,
                          fit: BoxFit.contain,
                          //fit: BoxFit.cover, nope
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    //text area
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        card.cardName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(card.suit),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}