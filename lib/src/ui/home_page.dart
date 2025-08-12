import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:assignment_task/src/models/picsum_image.dart';

import '../blocs/images/images_bloc.dart';
import '../blocs/images/images_event.dart';
import '../blocs/images/images_state.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Trigger the image fetch when page loads
    context.read<ImagesBloc>().add(const FetchImages(limit: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picsum Images'),
      ),
      body: BlocBuilder<ImagesBloc, ImagesState>(
        builder: (context, state) {
          if (state is ImagesLoading || state is ImagesInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ImagesLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              itemCount: state.images.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final img = state.images[index];
                return _ImageCell(image: img);
              },
            );
          } else if (state is ImagesError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _ImageCell extends StatelessWidget {
  final PicsumImage image;
  const _ImageCell({required this.image});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double aspectRatio = image.width / image.height;
    final double height = screenWidth / aspectRatio;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              image.downloadUrl,
              width: screenWidth,
              height: height,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  height: height,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (_, __, ___) => SizedBox(
                height: height,
                child: const Center(child: Icon(Icons.broken_image)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  image.author,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600, // Semi-bold
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Image ID: ${image.id} — ${image.width}x${image.height}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400, // Regular
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
