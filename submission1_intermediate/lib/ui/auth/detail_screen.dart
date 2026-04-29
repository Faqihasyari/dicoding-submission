import 'package:flutter/material.dart';
import '../../data/model/story.dart';
import '../../l10n/app_localizations.dart';
import '../widget/story_map_widget.dart';

class DetailScreen extends StatelessWidget {
  final Story story;

  const DetailScreen({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.detailStoryTitle)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: story.id,
              child: Image.network(
                story.photoUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, _) => const SizedBox(
                  height: 300,
                  child: Center(child: Icon(Icons.broken_image, size: 50)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(story.description, style: const TextStyle(fontSize: 16)),

                  if (story.lat != null && story.lon != null)
                    StoryMapWidget(
                      lat: story.lat!,
                      lon: story.lon!,
                      storyName: story.name,
                    ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}