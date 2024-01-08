// my_screen.dart
import 'package:ayna_bloc/screens/posts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../bloc/dog_image_bloc.dart'; // Import DogImageBloc

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final DogImageBloc _dogImageBloc = DogImageBloc();

  @override
  void initState() {
    super.initState();
    _dogImageBloc.add(FetchDogImage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doggies",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<DogImageBloc, DogImageState>(
        bloc: _dogImageBloc,
        builder: (context, state) {
          if (state is DogImageLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DogImageLoaded) {
            return Center(
              child: Image.network(
                state.imageUrl,
                height: MediaQuery.of(context).size.height / 2,
              ),
            );
          } else if (state is DogImageError) {
            return Center(child: Text("Error fetching image"));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_dogImageBloc.state is DogImageLoaded) {
            var box = Hive.box('myBox');
            await box.put(
                'image', (_dogImageBloc.state as DogImageLoaded).imageUrl);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostsScreen()),
            );
          }
        },
        child: Icon(Icons.navigate_next, color: Colors.black, size: 30),
      ),
    );
  }

  @override
  void dispose() {
    _dogImageBloc.close();
    super.dispose();
  }
}
