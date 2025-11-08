// features/ui/post_job_screen.dart
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobarchy_flutter_app/core/utils/environment.dart';
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
      _showSnackBar('Title is required');
      return;
    }
    if (_images.isEmpty) {
      _showSnackBar('Please pick at least one image');
      return;
    }

    await ref.read(createPostViewModelProvider.notifier).create(
          title: _titleCtrl.text,
          description: _descCtrl.text,
          country: _countryCtrl.text,
          images: _images,
        );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncResp = ref.watch(createPostViewModelProvider);

    ref.listen(createPostViewModelProvider, (_, next) {
      if (next is AsyncData && next.value?.status == true) {
        _titleCtrl.clear();
        _descCtrl.clear();
        setState(() => _images.clear());
        ref.read(createPostViewModelProvider.notifier).reset();
        _showSnackBar('Posted successfully!');
      }
    });

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1B2735),
            Color(0xFF090A0F),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Post a Job',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Title Field
                _buildTextField(
                  controller: _titleCtrl,
                  hint: 'Job Title',
                  icon: CupertinoIcons.briefcase,
                ),
                const SizedBox(height: 16),

                // Description Field
                _buildTextField(
                  controller: _descCtrl,
                  hint: 'Description',
                  icon: CupertinoIcons.doc_text,
                  maxLines: 5,
                ),
                const SizedBox(height: 16),

                // Country Field
                _buildTextField(
                  controller: _countryCtrl,
                  hint: 'Country',
                  icon: CupertinoIcons.globe,
                ),
                const SizedBox(height: 24),

                // Image Picker Button
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.photo, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Pick Images (${_images.length})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: _pickImages,
                ),
                const SizedBox(height: 12),

                // Image Chips (Glassmorphic)
                if (_images.isNotEmpty)
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _images.map((file) {
                      final name = file.path.split(Platform.pathSeparator).last;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                          // backdropFilter: const BlurFilter(),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                file,
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              name.length > 15 ? '${name.substring(0, 15)}...' : name,
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => setState(() => _images.remove(file)),
                              child: const Icon(
                                CupertinoIcons.xmark_circle_fill,
                                color: Colors.white70,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 32),

                // Status
                asyncResp.when(
                  data: (resp) => const SizedBox(),
                  loading: () => const CupertinoActivityIndicator(radius: 16),
                  error: (err, _) => Text(
                    'Error: $err',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),

        // Floating Submit Button
        floatingActionButton: FloatingActionButton.extended(
          onPressed: asyncResp.isLoading ? null : _submit,
          backgroundColor: const Color(0xFF00C6FF),
          elevation: 8,
          label: asyncResp.isLoading
              ? const CupertinoActivityIndicator()
              : const Text(
                  'POST JOB',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
          icon: const Icon(CupertinoIcons.paperplane_fill),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return CupertinoTextField(
      controller: controller,
      placeholder: hint,
      placeholderStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      prefix: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
      cursorColor: const Color(0xFF00C6FF),
    );
  }
}
