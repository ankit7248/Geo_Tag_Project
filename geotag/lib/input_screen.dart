import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'loading_screen.dart';
import 'output_screen.dart';


class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  TextEditingController currentLocationController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController bestLocationTypeController = TextEditingController();
  TextEditingController timePreferenceController = TextEditingController();
  TextEditingController ratingPreferenceController = TextEditingController();
  TextEditingController minRatingController = TextEditingController();
  TextEditingController amenitiesController = TextEditingController();

  void fetchRecommendation() async {
    // Show loading screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingScreen()),
    );

    // Prepare request body
    var requestBody = {
      "current_location": currentLocationController.text,
      "city": cityController.text,
      "country": countryController.text,
      "best_location_type": bestLocationTypeController.text,
      "time_preference": int.tryParse(timePreferenceController.text) ?? 1,
      "rating_preference": int.tryParse(ratingPreferenceController.text) ?? 5,
      "min_rating": double.tryParse(minRatingController.text) ?? 4.5,
      "amenities_list": amenitiesController.text.split(',').map((e) => e.trim()).toList(),
    };

    // Send POST request
    String apiUrl = 'http://localhost:5000/find_best_location';
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    // Handle response
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(responseBody: response.body),
        ),
      );
    } else {
      // Handle error scenario
      print('Failed to fetch recommendation');
      // Navigate back to input screen or show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Recommendation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: currentLocationController,
              decoration: InputDecoration(labelText: 'Current Location (latitude,longitude)'),
            ),
            TextFormField(
              controller: cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              controller: countryController,
              decoration: InputDecoration(labelText: 'Country'),
            ),
            TextFormField(
              controller: bestLocationTypeController,
              decoration: InputDecoration(labelText: 'Best Location Type'),
            ),
            TextFormField(
              controller: timePreferenceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Time Preference (1-5)'),
            ),
            TextFormField(
              controller: ratingPreferenceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Rating Preference (1-5)'),
            ),
            TextFormField(
              controller: minRatingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Minimum Rating'),
            ),
            TextFormField(
              controller: amenitiesController,
              decoration: InputDecoration(
                labelText: 'Amenities (comma separated, e.g., hospital, park)',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: fetchRecommendation,
              child: Text('Find Location'),
            ),
          ],
        ),
      ),
    );
  }
}
