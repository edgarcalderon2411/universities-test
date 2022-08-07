class University {
  University({
    this.alphaTwoCode,
    this.domains,
    this.country,
    this.webPages,
    this.name,
    this.stateProvince,
    this.imagePath,
    this.numberOfStudents,
  });
  String? alphaTwoCode;
  List<String>? domains;
  String? country;
  String? stateProvince;
  List<String>? webPages;
  String? name;
  String? imagePath;
  int? numberOfStudents;

  University.fromJson(Map<String, dynamic> json) {
    alphaTwoCode = json['alpha_two_code'];
    domains = List.castFrom<dynamic, String>(json['domains']);
    country = json['country'];
    stateProvince = json['state-province'];
    webPages = List.castFrom<dynamic, String>(json['web_pages']);
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['alpha_two_code'] = alphaTwoCode;
    _data['domains'] = domains;
    _data['country'] = country;
    _data['state-province'] = stateProvince;
    _data['web_pages'] = webPages;
    _data['name'] = name;
    return _data;
  }
}
