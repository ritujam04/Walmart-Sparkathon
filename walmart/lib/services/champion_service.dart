// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChampionService {
//   static Future<List<Map<String, dynamic>>> fetchChampionsRaw() async {
//     final List<dynamic> result = await Supabase.instance.client
//         .from('champions') // ✅ correct table name
//         .select('id, name, latitude, longitude, community:community_id(area)');

//     // Add 'flag' field to each champion record
//     final List<Map<String, dynamic>> modified = result.map((champ) {
//       return {
//         ...champ,        // keep existing fields
//         'flag': 0,       // add 'flag' field with default value 0 (unselected)
//       };
//     }).toList();

//     return modified;
//   }
// }



// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChampionService {
//   static Future<List<Map<String, dynamic>>> fetchChampionsRaw() async {
//     final List<dynamic> result = await Supabase.instance.client
//         .from('champions')
//         .select('id, name, latitude, longitude, community:community_id(area)');

//     // ✅ Cast each item to Map<String, dynamic> before using it
//     final List<Map<String, dynamic>> modified = result.map((champ) {
//       final Map<String, dynamic> champMap = Map<String, dynamic>.from(champ);
//       champMap['flag'] = 0; // add 'flag' field
//       return champMap;
//     }).toList();

//     return modified;
//   }
// }


import 'package:supabase_flutter/supabase_flutter.dart';

class ChampionService {
  static Future<List<Map<String, dynamic>>> fetchChampionsRaw() async {
    final List<dynamic> result = await Supabase.instance.client
        .from('champions')
        .select('id, name, latitude, longitude, community:community_id(area)');
          
    // ✅ Safely cast and add 'flag'
    final List<Map<String, dynamic>> modified = result.map((champ) {
      final Map<String, dynamic> champMap = Map<String, dynamic>.from(champ);
      print('🔍 Champion fetched: ${champMap['name']} - Community: ${champMap['community']}');
      // 🔒 Make sure 'community' is not null
      champMap['community'] ??= {}; // fallback to empty map if null

      champMap['flag'] = 0;
      return champMap;
    }).toList();

    return modified;
  }
}

