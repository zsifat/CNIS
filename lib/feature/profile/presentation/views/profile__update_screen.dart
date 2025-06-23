import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chapainawabganjcity/feature/profile/presentation/bloc/profile_info_cubit/profile_info_cubit.dart';
import 'package:chapainawabganjcity/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chapainawabganjcity/feature/profile/data/repository/profile_repository.dart';
import 'package:chapainawabganjcity/feature/profile/presentation/bloc/profile_update_cubit/profile_update_cubit.dart';
import 'package:chapainawabganjcity/feature/profile/presentation/bloc/profile_update_cubit/profile_update_states.dart';

class ProfileUpdateScreen extends StatefulWidget {
  final String initialUsername;
  final String imageUrl;

  const ProfileUpdateScreen({
    super.key,
    required this.initialUsername,
    required this.imageUrl,
  });

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialUsername);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitUpdate() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileUpdateCubit>().uploadProfilePicture(
        name: _nameController.text,
        imageFile: _selectedImage!,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('আপডেট করুন'),
      body: BlocConsumer<ProfileUpdateCubit, ProfileUpdateState>(
        listener: (context, state) {
          if (state is ProfileUploadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            context.read<ProfileCubit>().loadUserProfile();
            Navigator.pop(context, true);
          } else if (state is ProfileUploadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      child: ClipOval(
                        child: _selectedImage != null
                            ? Image.file(
                          _selectedImage!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                            : CachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            size: 40
                          ),
                          placeholder: (context, url) => const CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: false,
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.green.shade900),
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.green.shade800,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'নাম দেয়া আবশ্যক';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                        onTap: state is ProfileUploading ? null : _submitUpdate,
                        child: Container(
                          width: double.infinity,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.green.shade800,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child:  Center(
                            child: state is ProfileUploading
                                ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              'আপডেট করুন',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}