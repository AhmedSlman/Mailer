// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:location/location.dart';
// class LocationService {
//   Location location = Location();
  
//   Future<LocationData?> requestLocationPermission(BuildContext context) async {
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//     LocationData locationData;
    
//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         await _showExitDialog(context, 'خدمة الموقع مطلوبة', 
//           'هذا التطبيق يحتاج إلى تفعيل خدمة الموقع للعمل بشكل صحيح.');
//         return null;
//       }
//     }
    
//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         await _showExitDialog(context, 'إذن الموقع مطلوب', 
//           'هذا التطبيق يحتاج إلى إذن الوصول إلى موقعك للعمل بشكل صحيح.');
//         return null;
//       }
//     }
    
//     try {
//       locationData = await location.getLocation();
//       return locationData;
//     } catch (e) {
//       print("Error getting location data: $e");
//       return null;
//     }
//   }
  
//   Future<void> _showExitDialog(BuildContext context, String title, String message) async {
//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext);
//                 SystemNavigator.pop();
//               },
//               child: const Text('خروج'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }