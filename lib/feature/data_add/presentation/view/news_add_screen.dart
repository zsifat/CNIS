import 'dart:io';

import 'package:chapainawabganjcity/feature/data_add/presentation/cubit/activity_form_cubit.dart';
import 'package:chapainawabganjcity/feature/data_add/presentation/cubit/data_post_state.dart';
import 'package:chapainawabganjcity/feature/data_add/presentation/cubit/submit_news_cubit.dart';
import 'package:chapainawabganjcity/models/news_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../views/widgets/app_bar.dart';
import '../cubit/submit_news_state.dart';

class NewsAddScreen extends StatefulWidget {
  const NewsAddScreen({super.key, required this.newsCategory, this.subCatId});

  final NewsCategory newsCategory;
  final String? subCatId;

  @override
  State<NewsAddScreen> createState() => _NewsAddScreenState();
}

class _NewsAddScreenState extends State<NewsAddScreen> {
  final _formKey = GlobalKey<FormState>();

  File? imageFile;
  final ImagePicker _picker = ImagePicker();
  String title = '';
  String description = '';

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final int sizeInBytes = await file.length();
      final double sizeInMB = sizeInBytes / (1024 * 1024);

      if (sizeInMB <= 2) {
        setState(() {
          imageFile = file;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ছবিটি খুব বড়। দয়া করে ছোট ছবি ব্যবহার করুন।')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(widget.newsCategory.title),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: imageFile != null
                        ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(imageFile!, fit: BoxFit.cover))
                        : const Center(
                        child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey)),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField("শিরোনাম", required: true, onSaved: (val) => title = val!),
                _buildTextField("বিস্তারিত", required: true, onSaved: (val) => description = val!, minLines: 5),
                const SizedBox(height: 24),
                BlocConsumer<SubmitNewsCubit, SubmitNewsState>(
                  listener: (context, state) {
                    if(state is SubmitNewsLoading) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('অপেক্ষা করুন...')),
                      );
                    }
                    if (state is SubmitNewsSuccess) {
                      _formKey.currentState?.reset();
                      setState(() {
                        imageFile = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('নিউজ সফলভাবে জমা হয়েছে।')),
                      );
                      Navigator.pop(context);
                    } else if (state is SubmitNewsFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('জমা ব্যর্থ হয়েছে: ${state.error}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          context.read<SubmitNewsCubit>().submitNews(
                            title: title,
                            description: description,
                            image: imageFile,
                            catId: int.parse(widget.newsCategory.id.toString()),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.green.shade800,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: state is ActivityFormLoading
                              ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            'জমা দিন',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {bool required = false, FormFieldSetter<String>? onSaved, int minLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: TextFormField(
        minLines: minLines,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.green.shade800),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red.shade800),
          ),
        ),
        validator: required ? (value) => value == null || value.isEmpty ? 'ফিল্ডটি আবশ্যক' : null : null,
        onSaved: onSaved,
      ),
    );
  }
}
