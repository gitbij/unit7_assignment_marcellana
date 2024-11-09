import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiUrl = 'https://digi-api.com/api/v1/digimon?pageSize=20';

  Future<List<dynamic>> getDigimonList() async {
    var response = await http.get(Uri.parse(apiUrl));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['content']; // assuming the content is in this key
    } else {
      throw Exception("Failed to load Digimon data");
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit 7 - API Calls"),
      ),
      body: FutureBuilder(
        // setup the URL for your API here
        
        future: getDigimonList(),
        builder: (context, snapshot) {

          // Consider 3 cases here
          // when the process is ongoing
          // return CircularProgressIndicator();
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          // when the process is completed:
          
          // successful
          // Use the library here
          if (snapshot.hasData) {
            var digimonList = snapshot.data!;

            return ExpandedTileList.builder(
              itemCount: digimonList.length,
              itemBuilder: (context, index, controller) {
                final digimon = digimonList[index];
                
                return ExpandedTile(
                  title: Text(digimon['name']),
                  leading: digimon['image'] != null && digimon['image'].isNotEmpty
                    ? Image.network(
                        digimon['image'],
                        width: 50,
                        height: 50,
                      )
                    : Icon(Icons.image_not_supported),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Link: ${digimon['href']}"),
                      ),
                    ],
                  ),
                  controller: controller,
                );
              },
            );
          }

          

          // error
          if (snapshot.hasError) {
                  return Text(
                      "An error has occured: ${snapshot.error.toString()}");
                }

                return Container();
        },
      ),
    );
  }
}
