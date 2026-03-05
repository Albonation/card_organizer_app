import 'package:flutter/material.dart';
import '../models/folder.dart';
import '../models/card_item.dart';
import '../repositories/card_repository.dart';
import 'add_edit_card_screen.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //TODO: Navigate to AddEditCardScreen in "add" mode
           await Navigator.push(context, MaterialPageRoute(
             builder: (_) => AddEditCardScreen(folder: widget.folder),
           ));
           _loadCards();

          //ScaffoldMessenger.of(context).showSnackBar(
            //const SnackBar(content: Text('TODO: Add new card')),
          //);
        },
        child: const Icon(Icons.add),
      ),
      body: _cards.isEmpty
          ? const Center(child: Text("No cards in this folder"))
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 310,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];

          return Card(
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 6),

                  // Buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        tooltip: 'Edit',
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          //TODO: Navigate to AddEditCardScreen in "edit" mode
                           await Navigator.push(context, MaterialPageRoute(
                             builder: (_) => AddEditCardScreen(card: card),
                           ));
                           _loadCards();

                          //ScaffoldMessenger.of(context).showSnackBar(
                          //  const SnackBar(content: Text('TODO: Edit card')),
                          //);
                        },
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Card?'),
                              content: Text(
                                'Delete "${card.cardName} of ${card.suit}"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            await _cardRepo.deleteCard(card.id!);
                            await _loadCards();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Card deleted')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}