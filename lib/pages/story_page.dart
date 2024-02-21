import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:storyteller/utils/constants.dart';
import 'dart:typed_data';

class StoryPage extends StatefulWidget {
  final String imagePath;

  const StoryPage({super.key, required this.imagePath});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  List<String> story = [];
  bool isLoading = true;

  Future<Uint8List> loadImageAssetBytes(String path) async {
    ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  void composeStory() async {
    story.clear();
    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
    final prompt = 'Generate a story behind this image?';
    final lionBytes = await loadImageAssetBytes(widget.imagePath);

    final content = [
      Content.multi([TextPart(prompt), DataPart('image/jpeg', lionBytes)])
    ];
    final responses = model.generateContentStream(content);
    await for (final response in responses) {
      story.add(response.text!.trim());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    composeStory();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: size.height * 0.4,
              floating: false,
              pinned: true,
              iconTheme: IconThemeData(
                  color: innerBoxIsScrolled ? Colors.black : Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: story.length,
                itemBuilder: (context, index) {
                  return Text(
                    story[index],
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                },
              ),
      ),
    );
  }
}
