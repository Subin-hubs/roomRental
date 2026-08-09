import 'package:flutter/material.dart';
import 'package:room_rental/models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(room.roomImage[0].url),
          Text(room.title),

          Row(
            children: [
              Text(room.location),
              Text(room.city),
            ],
          ),

          Text(room.price),

          Text(room.isAvailable.toString()),
        ],
      ),
    );
  }
}