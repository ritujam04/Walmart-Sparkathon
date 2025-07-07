import 'package:flutter/material.dart';
import '../models/champion_location.dart';

class SummaryScreen extends StatelessWidget {
  final List<ChampionLocation> champions;

  const SummaryScreen({Key? key, required this.champions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary of Champions'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: champions.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                final champ = champions[index];
                return ListTile(
                  leading: Icon(Icons.star, color: Colors.orangeAccent),
                  title: Text(champ.name),
                  subtitle: Text(
                    'Area: ${champ.communityArea}\n'
                    'Lat: ${champ.latitude.toStringAsFixed(4)}, Lng: ${champ.longitude.toStringAsFixed(4)}\n'
                    'Dist: ${champ.distanceFromRoute.toStringAsFixed(2)} m',
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement place action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("📍 Champion request placed!")),
                );
              },
              icon: Icon(Icons.send),
              label: Text("Place Request"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
