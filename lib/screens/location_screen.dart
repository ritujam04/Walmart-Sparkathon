// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import '../services/champion_service.dart'; // ✅ import service
// import '../screens/map_screen.dart';

// class LocationsScreen extends StatefulWidget {
//   const LocationsScreen({super.key});

//   @override
//   State<LocationsScreen> createState() => _LocationsScreenState();
// }

// class _LocationsScreenState extends State<LocationsScreen> {
//   List<Map<String, dynamic>> _champions = []; // ✅ Replaces dummy list
//   final Set<int> _selectedIds = {};
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadChampions(); // ✅ Fetch data on init
//   }

//   Future<void> _loadChampions() async {
//     try {
//       final data = await ChampionService.fetchChampionsRaw();
//       setState(() {
//         _champions = data;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('Select Next‑Truck Stops')),
//       body: ListView.builder(
//         itemCount: _champions.length,
//         itemBuilder: (ctx, i) {
//           final champ = _champions[i];
//           final isSelected = _selectedIds.contains(champ['id']);

//           return Card(
//             color: isSelected ? Colors.green.shade300 : Colors.grey.shade200,
//             child: ListTile(
//               title: Text(champ['name']),
//               subtitle: Text(
//                 '(${champ['latitude'].toStringAsFixed(4)}, '
//                 '${champ['longitude'].toStringAsFixed(4)})\nCommunity: ${champ['community']['area']}',
//               ),
//               trailing: Icon(
//                 isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
//                 color: isSelected ? Colors.white : Colors.black45,
//               ),
//               onTap: () {
//                 setState(() {
//                   isSelected
//                       ? _selectedIds.remove(champ['id'])
//                       : _selectedIds.add(champ['id']);
//                 });
//               },
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(12),
//         child: ElevatedButton.icon(
//           icon: const Icon(Icons.map),
//           label: const Text('Go on Map'),
//           onPressed: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => MapScreen()),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/champion_service.dart'; // ✅ import service
import '../screens/map_screen.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  List<Map<String, dynamic>> _champions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChampions();
  }

  Future<void> _loadChampions() async {
    try {
      final data = await ChampionService.fetchChampionsRaw();

      // ✅ Add `flag: 0` to each champion initially
      final modified = data.map((champ) {
        return {
          ...champ,
          'flag': 0, // Not selected by default
        };
      }).toList();

      setState(() {
        _champions = modified;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _toggleSelection(int id) {
    setState(() {
      final index = _champions.indexWhere((c) => c['id'] == id);
      if (index != -1) {
        _champions[index]['flag'] = _champions[index]['flag'] == 1 ? 0 : 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Select Champions to be delivered')),
      body: ListView.builder(
        itemCount: _champions.length,
        itemBuilder: (ctx, i) {
          final champ = _champions[i];
          final isSelected = champ['flag'] == 1;

          return Card(
            color: isSelected ? Colors.green.shade300 : Colors.grey.shade200,
            child: ListTile(
              title: Text(champ['name']),
              subtitle: Text(
                '(${champ['latitude'].toStringAsFixed(4)}, '
                '${champ['longitude'].toStringAsFixed(4)})\nCommunity: ${champ['community']['area']}',
              ),
              trailing: Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? Colors.white : Colors.black45,
              ),
              onTap: () => _toggleSelection(champ['id']),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.map),
          label: const Text('Go on Map'),
          onPressed: () {
            // ✅ Filter selected champions to pass to map
            final selectedChampions =
                _champions.where((c) => c['flag'] == 1).toList();

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MapScreen(
                  selectedChampions: selectedChampions,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
