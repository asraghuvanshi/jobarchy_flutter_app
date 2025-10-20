import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:jobarchy_flutter_app/features/viewmodel/createpost_viewmodel.dart';


class PostJobScreen extends ConsumerStatefulWidget {
  const PostJobScreen({super.key});
  @override
  ConsumerState<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends ConsumerState<PostJobScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _countryCtrl = TextEditingController(text: 'India');
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _images.addAll(picked.map((x) => File(x.path)));
      });
    }
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Title required')));
      return;
    }

    await ref.read(createPostViewModelProvider.notifier).create(
          title: _titleCtrl.text,
          description: _descCtrl.text,
          country: _countryCtrl.text,
          images: _images,
        );
  }

  @override
  Widget build(BuildContext context) {
    final asyncResp = ref.watch(createPostViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Post a Job')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 8),
            TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Description'), maxLines: 4),
            const SizedBox(height: 8),
            TextField(controller: _countryCtrl, decoration: const InputDecoration(labelText: 'Country')),
            const SizedBox(height: 16),

            // ----- IMAGE PICKER -----
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.image),
              label: Text('Pick Images (${_images.length})'),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _images
                  .map((f) => Chip(
                        avatar: Image.file(f, width: 24, height: 24, fit: BoxFit.cover),
                        label: Text(f.path.split(Platform.pathSeparator).last),
                        onDeleted: () => setState(() => _images.remove(f)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),

            asyncResp.when(
              data: (resp) => resp?.status == true
                  ? const Text('Posted!', style: TextStyle(color: Colors.green))
                  : Text(resp?.message ?? '', style: const TextStyle(color: Colors.red)),
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error: $err', style: const TextStyle(color: Colors.red)),
            ),

            const Spacer(),
            ElevatedButton(
              onPressed: asyncResp.isLoading ? null : _submit,
              child: const Text('POST JOB'),
            ),
          ],
        ),
      ),
    );
  }
}