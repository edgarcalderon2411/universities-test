import 'package:universities/src/domain/models/university.dart';

abstract class UniversitiesRepository {
  Future<List<University>> getUniversities();
}