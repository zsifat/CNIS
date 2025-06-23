import 'package:chapainawabganjcity/core/shared_prefs_service/shared_pref_keys.dart';
import 'package:chapainawabganjcity/feature/data_add/presentation/cubit/activity_form_cubit.dart';
import 'package:chapainawabganjcity/feature/data_add/presentation/cubit/data_post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // for date formatting
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../../../../models/upazila.dart';
import '../../../../views/widgets/app_bar.dart';

class InputFormScreen extends StatefulWidget {
  const InputFormScreen({super.key, required this.catId, this.subCatId});

  final String catId;
  final String? subCatId;

  @override
  State<InputFormScreen> createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {
  final _formKey = GlobalKey<FormState>();

  File? thumb;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Reduces image size, adjust as needed
      maxWidth: 1920, // Optional: resize width
      maxHeight: 1080, // Optional: resize height
    );

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final int sizeInBytes = await imageFile.length();
      final double sizeInMB = sizeInBytes / (1024 * 1024);

      if (sizeInMB <= 2) {
        setState(() {
          thumb = imageFile;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image still too large. Try picking another one.')),
        );
      }
    }
  }

  Upazila selectedUpazila = Upazila.all;
  String title = '';
  int? catId;
  String details = '';
  String contact = '';
  String degree = '';
  String address = '';
  String idLink = '';
  String chamber = '';
  String price = '';
  String bloodGroup = '';
  String email = '';

  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8.0),
          child: BlocConsumer<ActivityFormCubit, ActivityFormState>(
            listener: (context, state) {
              if (state is ActivityFormSuccess) {
                _formKey.currentState?.reset();
                setState(() {
                  thumb = null;
                  selectedUpazila = Upazila.all;
                  title = '';
                  details = '';
                  contact = '';
                  degree = '';
                  address = '';
                  idLink = '';
                  chamber = '';
                  price = '';
                  bloodGroup = '';
                  email = '';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Submitted successfully!')),
                );
                Navigator.pop(context);
              } else if (state is ActivityFormFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Submission failed: ${state.error}')),
                );
              }
            },
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    context.read<ActivityFormCubit>().submitActivityForm(
                      title: title,
                      upazila: selectedUpazila.index.toString(),
                      catId: int.parse(widget.catId),
                      address: address,
                      bloodGroup: bloodGroup,
                      chamber: chamber,
                      contact: contact,
                      degree: degree,
                      details: details,
                      email: email,
                      idLink: idLink,
                      price: price,
                      subCategory: int.tryParse(widget.subCatId?? ''),
                      thumb: thumb,
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
                      'সাবমিট করুন',
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
        ),
        appBar: buildAppBar('তথ্য দিন'),
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
                    child: thumb != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(thumb!, fit: BoxFit.cover))
                        : const Center(child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey)),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField("টাইটেল", required: true, onSaved: (val) => title = val!),
                const SizedBox(height: 16),
                DropdownButtonFormField<Upazila>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.green.shade300, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.green.shade800, width: 1),
                    ),
                    labelText: 'উপজেলা নির্বাচন করুন',
                    labelStyle: TextStyle(color: Colors.grey.shade700),
                  ),
                  value: selectedUpazila,
                  items: Upazila.values.map((upazila) {
                    return DropdownMenuItem<Upazila>(
                      value: upazila,
                      child: Text(upazila.name),
                    );
                  }).toList(),
                  onChanged: (Upazila? newValue) {
                    setState(() {
                      if (newValue != null) {
                        selectedUpazila = newValue;
                      }
                    });
                  },
                ),
                _buildTextField("বিস্তারিত", onSaved: (val) => details = val ?? '', minLines: 3),
                _buildNumberField("ফোন নাম্বার", onSaved: (val) => contact = val!),
                //if doctor
                if (widget.catId == '2')
                  _buildTextField("শিক্ষাগত যোগ্যতা", onSaved: (val) => degree = val ?? ''),
                _buildTextField("ঠিকানা", onSaved: (val) => address = val ?? ''),
                _buildTextField("আইডি লিংক", onSaved: (val) => idLink = val ?? ''),
                //if doctor
                if (widget.catId == '2')
                  _buildTextField("চেম্বার", onSaved: (val) => chamber = val ?? ''),
                //if shop or home rent or flat
                if (widget.catId == '134' || widget.catId == '9' || widget.catId == '12')
                  _buildNumberField("দাম", onSaved: (val) => price = val ?? ''),
                //if blood donation
                if (widget.catId == '4')
                  _buildTextField("রক্তের গ্রুপ", onSaved: (val) => bloodGroup = val ?? ''),
                _buildTextField("Email", onSaved: (val) => email = val ?? ''),
                const SizedBox(height: 20),
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
        validator: required ? (value) => value == null || value.isEmpty ? 'Required' : null : null,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildNumberField(String label,
      {bool required = false, FormFieldSetter<String>? onSaved}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: TextFormField(
        decoration: InputDecoration(
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
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        keyboardType: TextInputType.number,
        validator: required ? (value) => value == null || value.isEmpty ? 'Required' : null : null,
        onSaved: onSaved,
      ),
    );
  }
}
