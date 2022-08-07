import 'package:universities/src/domain/models/university.dart';

abstract class UniversitiesUseCase {
  Future<List<University>> getUniversities();
}
