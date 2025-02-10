

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrentlyPlayingTile extends StatefulWidget {
  const CurrentlyPlayingTile({super.key});

  @override
  State<CurrentlyPlayingTile> createState() => _CurrentlyPlayingTileState();
}

class _CurrentlyPlayingTileState extends State<CurrentlyPlayingTile> {

  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF282828),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Player header
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Album art
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 56,
                    height: 56,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Track info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Track Title',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Artist Name',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Control buttons
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.devices_outlined, color: Colors.white70),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.white70),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Progress bar
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LinearProgressIndicator(
                value: 0.3,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0:30',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '3:05',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}