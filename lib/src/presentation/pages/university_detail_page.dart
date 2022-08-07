import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:universities/src/domain/models/university.dart';
import 'package:universities/src/presentation/bloc/universities_bloc.dart';

class UniversityDetailPage extends StatefulWidget {
  const UniversityDetailPage(
    this.university, {
    Key? key,
  }) : super(key: key);

  final University university;

  @override
  State<UniversityDetailPage> createState() => _UniversityDetailPageState();
}

class _UniversityDetailPageState extends State<UniversityDetailPage> {
  final ImagePicker _picker = ImagePicker();

  UniversitiesBloc? _bloc;

  String? selectedImage;

  final TextEditingController _studentsCtrl = TextEditingController();
  bool studentsInputError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc ??= Provider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            (widget.university.imagePath != null || selectedImage != null)
                ? Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: Hero(
                            tag: widget.university.name ?? 'universityimage',
                            child: Image.file(File(
                              selectedImage != null
                                  ? selectedImage!
                                  : widget.university.imagePath!,
                            )),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: _selectImage, child: Text('Change image')),
                    ],
                  )
                : Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey[200],
                    child: IconButton(
                        onPressed: _selectImage, icon: Icon(Icons.add_a_photo)),
                  ),
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _info('Name', widget.university.name ?? ''),
                    _info('Country', widget.university.country ?? ''),
                    _info('State Province',
                        widget.university.stateProvince ?? 'Unknown'),
                    _info('Domains', '${widget.university.domains}'),
                    _info('Web Pages', '${widget.university.webPages}'),
                    _info(
                        'Alpha Two Code', '${widget.university.alphaTwoCode}'),
                    if (widget.university.numberOfStudents != null)
                      _info('Number of students',
                          '${widget.university.numberOfStudents}'),
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Set the number of students'),
                                    content: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _studentsCtrl,
                                          keyboardType: TextInputType.number,
                                        ),
                                        SizedBox(height: 15,),

                                        if(studentsInputError)
                                        Text('You must enter a valid number')
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            studentsInputError = false;
                                            _studentsCtrl.clear();
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel')),
                                      TextButton(
                                          onPressed: () {
                                            try {
                                              if (_studentsCtrl
                                                  .text.isNotEmpty) {
                                                int number = int.parse(
                                                    _studentsCtrl.text);

                                                _bloc!.setNumberOfStudents(
                                                    widget.university, number);

                                                studentsInputError = false;
                                                _studentsCtrl.clear();
                                                setState(() {});
                                                Navigator.pop(context);
                                              }
                                            } catch (e) {
                                              setState(() {
                                                studentsInputError = true;
                                              });
                                            }
                                          },
                                          child: Text('Set')),
                                    ],
                                  ));
                        },
                        child: Text('Set number of students'))
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String value) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  _selectImage() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Choose source'),
            // content: Text('Select image source'),
            actions: [
              TextButton(
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);

                    if (image != null) {
                      _bloc!.setUniversityImage(widget.university, image.path);
                      setState(() {
                        selectedImage = image.path;
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: Text('Gallery')),
              TextButton(
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.camera);

                    if (image != null) {
                      _bloc!.setUniversityImage(widget.university, image.path);
                      setState(() {
                        selectedImage = image.path;
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: Text('Camera')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
            ],
          );
        });
  }
}
