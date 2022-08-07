import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:universities/src/domain/models/university.dart';
import 'package:universities/src/presentation/bloc/universities_bloc.dart';
import 'package:universities/src/presentation/pages/university_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UniversitiesBloc? _bloc;

  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _bloc ??= Provider.of(context);
    _bloc!.getUniversities();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 40) {
        _bloc!.goToNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc!.universitiesInfoStream,
      builder:
          (BuildContext context, AsyncSnapshot<UniversitiesInfo> snapshot) {
        if (snapshot.hasData) {
          final List<University> universities = _bloc!.getUniversitiesInPage();
          final LayoutType layoutType = snapshot.data!.layoutType!;
          final int currentPage = snapshot.data!.currentPage!;

          return Scaffold(
            appBar: AppBar(
              title: Text('Universities'),
              actions: [
                IconButton(
                    onPressed: () {
                      _bloc!.changeLayout();
                    },
                    icon: Icon(
                      layoutType == LayoutType.LIST
                          ? Icons.grid_on
                          : Icons.list,
                    ))
              ],
            ),
            body: layoutType == LayoutType.LIST
                ? _listLayout(universities)
                : _gridLayout(universities),

          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Universities'),
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  _listLayout(List<University> universities) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          ...universities
              .map<Widget>(
                (e) => Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Text('${universities.indexOf(e) + 1}'),
                        onTap: () {
                          _goToDetailPage(e);
                        },
                        title: Text(e.name ?? ''),
                        subtitle: Text(e.country ?? ''),
                      ),
                      if (e.imagePath != null)
                        GestureDetector(
                          onTap: () {
                            _goToDetailPage(e);
                          },
                          child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              height: 200,
                              child: Hero(
                                tag: e.name!,
                                child: Image.file(File(e.imagePath!)))),
                        )
                    ],
                  ),
                ),
              )
              .toList()
        ],
      ),
    );
  }

  _goToDetailPage(University university) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                UniversityDetailPage(university)));
  }

  _gridLayout(List<University> universities) {
    return GridView.count(
      controller: _scrollController,
      crossAxisSpacing: 10,
      mainAxisSpacing: 30,
      crossAxisCount: 2,
      children: universities
          .map<Widget>((e) => Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                UniversityDetailPage(e)));
                  },
                  child: GridTile(
                    header: Container(
                      color: Colors.white.withOpacity(.9),
                      child: Text(
                        e.name ?? '',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    footer: Container(
                      color: Colors.white.withOpacity(.8),
                      child: Text(
                        e.country ?? '',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    child: Container(
                      color: Colors.white,
                      child: e.imagePath != null
                          ? Image.file(
                              File(
                                e.imagePath!,
                              ),
                          
                            )
                          : Icon(Icons.image),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
