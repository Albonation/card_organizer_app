import 'package:flutter/material.dart';
import '../models/folder.dart';
import '../models/card_item.dart';
import '../repositories/folder_repository.dart';
import '../repositories/card_repository.dart';

class AddEditCardScreen extends StatefulWidget {
  final PlayingCard? card;
  final Folder? folder;

  const AddEditCardScreen({
    super.key,
    this.card,
    this.folder,
  });

  @override
  State<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cardRepo = CardRepository();
  final _folderRepo = FolderRepository();

  late final TextEditingController _nameController;
  late final TextEditingController _imageController;

  List<Folder> _folders = [];
  bool _loadingFolders = true;


  String _selectedSuit = 'Hearts';
  int? _selectedFolderId;

  bool get _isEdit => widget.card != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.card?.cardName ?? '');
    _imageController = TextEditingController(text: widget.card?.imageUrl ?? '');


    _selectedSuit = widget.card?.suit ?? widget.folder?.folderName ?? 'Hearts';
    _selectedFolderId = widget.card?.folderId ?? widget.folder?.id;

    _loadFolders();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _loadFolders() async {
    final folders = await _folderRepo.getAllFolders();


    int? folderId = _selectedFolderId;
    if (folderId == null && folders.isNotEmpty) {

      final match = folders.where((f) => f.folderName == _selectedSuit).toList();
      folderId = match.isNotEmpty ? match.first.id : folders.first.id;
    }

    setState(() {
      _folders = folders;
      _selectedFolderId = folderId;
      _loadingFolders = false;
    });
  }

  void _syncFolderToSuitIfPossible(String suit) {

    final match = _folders.where((f) => f.folderName == suit).toList();
    if (match.isNotEmpty) {
      _selectedFolderId = match.first.id;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFolderId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a folder.')),
      );
      return;
    }

    //final now = DateTime.now().toIso8601String();

    final cardToSave = PlayingCard(
      id: widget.card?.id,
      cardName: _nameController.text.trim(),
      suit: _selectedSuit,
      imageUrl: _imageController.text.trim().isEmpty ? null : _imageController.text.trim(),
      folderId: _selectedFolderId!,
    );

    if (_isEdit) {
      await _cardRepo.updateCard(cardToSave);
    } else {
      await _cardRepo.insertCard(cardToSave);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Card' : 'Add Card'),
      ),
      body: _loadingFolders
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Card Name',
                  hintText: 'Ace, 2, 10, Jack, Queen, King...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Card name is required.';
                  return null;
                },
              ),
              const SizedBox(height: 12),


              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Suit',
                  border: OutlineInputBorder(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSuit,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'Hearts', child: Text('Hearts')),
                      DropdownMenuItem(value: 'Diamonds', child: Text('Diamonds')),
                      DropdownMenuItem(value: 'Clubs', child: Text('Clubs')),
                      DropdownMenuItem(value: 'Spades', child: Text('Spades')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedSuit = value;
                        _syncFolderToSuitIfPossible(value);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),


              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Image Path (asset)',
                  hintText: 'assets/card_images/AS.png',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),


              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Folder Assignment',
                  border: OutlineInputBorder(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedFolderId,
                    isExpanded: true,
                    items: _folders
                        .where((f) => f.id != null)
                        .map((f) => DropdownMenuItem<int>(
                      value: f.id!,
                      child: Text(f.folderName),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedFolderId = value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),


              if ((_imageController.text.trim()).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Center(
                    child: SizedBox(
                      height: 160,
                      child: Image.asset(
                        _imageController.text.trim(),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stack) {
                          return const Text(
                            'Image not found (check asset path)',
                            style: TextStyle(color: Colors.red),
                          );
                        },
                      ),
                    ),
                  ),
                ),


              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}