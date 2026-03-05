import 'package:card_organizer_app/models/card_item.dart';
import 'package:flutter/material.dart';

class CardsScreen extends State {
  late PlayingCard playingCard;
  CardsScreen({super.key, required this.playingCard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              playingCard.imageUrl!,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 16),

            Text(
              playingCard.cardName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )
          ],)
      ))
  }
}