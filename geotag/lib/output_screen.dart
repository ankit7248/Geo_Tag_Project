import 'package:flutter/material.dart';
import 'dart:convert';

class ResultScreen extends StatelessWidget {
  final String responseBody;

  ResultScreen({required this.responseBody});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> parsedJson = jsonDecode(responseBody);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendation Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Best Location Address:'),
              subtitle: Text(parsedJson['best_location_address'] ?? 'Not available'),
            ),
            ListTile(
              title: Text('Best Location Score:'),
              subtitle: Text(parsedJson['best_location_score'].toString()),
            ),
            ListTile(
              title: Text('Distances to Amenities from Best Location:'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: parsedJson['distances_to_amenities'].map<Widget>((amenity) {
                  return ListTile(
                    title: Text('Closest ${amenity['amenity']}: ${amenity['distance_km'].toStringAsFixed(2)} km'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${amenity['name']}'),
                        Text('Address: ${amenity['address']}'),
                        Text('Rating: ${amenity['rating'].toString()}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: Text('Chosen Best Location:'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${parsedJson['chosen_best_location']['name']}'),
                  Text('Address: ${parsedJson['chosen_best_location']['address']}'),
                  Text('Rating: ${parsedJson['chosen_best_location']['rating'].toString()}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
