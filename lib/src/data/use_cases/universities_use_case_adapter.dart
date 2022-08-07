import 'package:universities/src/domain/models/university.dart';
import 'package:universities/src/domain/repositories/universities_repository.dart';
import 'package:universities/src/domain/use_cases/universities_use_case.dart';

class UniversitiesUseCaseAdapter implements UniversitiesUseCase {
  UniversitiesUseCaseAdapter(this.repository);

  final UniversitiesRepository repository;

  @override
  Future<List<University>> getUniversities() {
    return repository.getUniversities();
  }
}
