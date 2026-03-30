import 'package:flutter/material.dart';
import 'services/dog_api_service.dart';
import 'models/dog_model.dart';

class DogFinderPage extends StatefulWidget {
  @override
  _DogFinderPageState createState() => _DogFinderPageState();
}

class _DogFinderPageState extends State<DogFinderPage> {
  String imageUrl = '';
  bool isLoading = false;

  Future<void> fetchDogImage() async {
    setState(() {
      isLoading = true;
    });

    try {
      DogModel dog = await DogApiService.fetchRandomDog();
      setState(() {
        imageUrl = dog.message;
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDogImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          width: 320,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Dog Finder',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: isLoading
                    ? Container(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Image.network(
                        imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchDogImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(
                      horizontal: 40, vertical: 12),
                ),
                child: Text('Ambil Foto Baru'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}