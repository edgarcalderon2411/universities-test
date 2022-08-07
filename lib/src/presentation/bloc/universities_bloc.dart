import 'package:rxdart/rxdart.dart';
import 'package:universities/src/domain/models/university.dart';
import 'package:universities/src/domain/use_cases/universities_use_case.dart';
import 'package:universities/src/presentation/bloc/bloc.dart';

class UniversitiesBloc extends Bloc {
  UniversitiesBloc(this._useCase);

  final UniversitiesUseCase _useCase;

  final BehaviorSubject<List<University>> _universitiesSubject =
      BehaviorSubject<List<University>>();

  final BehaviorSubject<int> _pageSubject = BehaviorSubject<int>.seeded(1);

  final BehaviorSubject<LayoutType> _layoutTypeSubject =
      BehaviorSubject<LayoutType>.seeded(LayoutType.LIST);

  ValueStream<List<University>> get universitiesStream =>
      _universitiesSubject.stream;

  ValueStream<LayoutType> get layoutTypeStream => _layoutTypeSubject.stream;

  ValueStream<int> get pageStream => _pageSubject.stream;

  Stream<UniversitiesInfo> get universitiesInfoStream => CombineLatestStream
      .combine3<List<University>, int, LayoutType, UniversitiesInfo>(
          _universitiesSubject,
          _pageSubject,
          _layoutTypeSubject,
          (List<University> a, int b, LayoutType c) =>
              UniversitiesInfo(universities: a, currentPage: b, layoutType: c));

  Future<void> getUniversities() async {
    _universitiesSubject.value = await _useCase.getUniversities();
  }

  void changeLayout() {
    if (_layoutTypeSubject.value == LayoutType.LIST) {
      _layoutTypeSubject.value = LayoutType.GRID;
    } else {
      _layoutTypeSubject.value = LayoutType.LIST;
    }
  }

  List<University> getUniversitiesInPage() {
    return _universitiesSubject.value.sublist(0, _pageSubject.value * 20);
  }

  void setUniversityImage(University university, String imagePath) {
    int index = _universitiesSubject.value.indexOf(university);

    _universitiesSubject.value[index].imagePath = imagePath;

    _universitiesSubject.value = _universitiesSubject.value;
  }

    void setNumberOfStudents(University university, int n) {
    int index = _universitiesSubject.value.indexOf(university);

    _universitiesSubject.value[index].numberOfStudents = n;

    _universitiesSubject.value = _universitiesSubject.value;
  }

  bool nextPageAwait = false;

  Future goToNextPage() async {
    if (!nextPageAwait) {
      _pageSubject.value = _pageSubject.value + 1;
      print(_pageSubject.value);

      nextPageAwait = true;
      await Future.delayed(Duration(seconds: 1));
      nextPageAwait = false;
    }
  }

  @override
  void dispose() {
    _universitiesSubject.close();
    _layoutTypeSubject.close();
    _pageSubject.close();
  }
}

enum LayoutType {
  GRID,
  LIST,
}

class UniversitiesInfo {
  UniversitiesInfo({
    required this.universities,
    required this.currentPage,
    required this.layoutType,
  });

  List<University>? universities;
  int? currentPage;
  LayoutType? layoutType;
}
