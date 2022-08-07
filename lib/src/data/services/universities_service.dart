import 'dart:convert';

import 'package:universities/src/domain/models/university.dart';
import 'package:universities/src/domain/repositories/universities_repository.dart';
import 'package:http/http.dart' as http;

class UniversitiesService implements UniversitiesRepository {
  @override
  Future<List<University>> getUniversities() async {
    final Uri _uri = Uri.https(
        'tyba-assets.s3.amazonaws.com', 'FE-Engineer-test/universities.json');

    final List<University> universities = [];

    final http.Response response = await http.get(_uri);

    (jsonDecode(response.body) as List).forEach((element) {
      universities.add(University.fromJson(element));
    });

    return universities;
  }
}
