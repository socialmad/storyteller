import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storyteller/utils/images.dart';
import 'package:storyteller/pages/story_page.dart';

class HomePage extends StatelessWidget {
  List<String> images = [
    ImageResources.sweetGrapes,
    ImageResources.lionAndMouse,
    ImageResources.freeBird,
    ImageResources.lostAndFound,
    ImageResources.elephantAndTailor,
    ImageResources.wolfWolf,
    ImageResources.lionAndRabbit,
    ImageResources.literateAndIliterate
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storyteller'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // number of items per row
          crossAxisSpacing: 8, // spacing between items horizontally
          mainAxisSpacing: 8, // spacing between items vertically
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StoryPage(imagePath: images[index])),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(images[index]),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }
}
