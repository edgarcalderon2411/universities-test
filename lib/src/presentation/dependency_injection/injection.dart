import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:universities/src/data/services/universities_service.dart';
import 'package:universities/src/data/use_cases/universities_use_case_adapter.dart';
import 'package:universities/src/domain/repositories/universities_repository.dart';
import 'package:universities/src/domain/use_cases/universities_use_case.dart';
import 'package:universities/src/presentation/bloc/universities_bloc.dart';

class InjectionWidget extends StatelessWidget {
  const InjectionWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final UniversitiesRepository universitiesRepository = UniversitiesService();
    final UniversitiesUseCase universitiesUseCase =
        UniversitiesUseCaseAdapter(universitiesRepository);
    final UniversitiesBloc universitiesBloc =
        UniversitiesBloc(universitiesUseCase);

    return MultiProvider(
      providers: [
        Provider(create: (context) => universitiesRepository),
        Provider(create: (context) => universitiesUseCase),
        Provider(create: (context) => universitiesBloc),
      ],
      child: child,
    );
  }
}
