class Project {
  String name;
  bool use_conan;
  String include_dir;
  bool lock_cmake;
  List<String> header_files;
  String src_dir;
  List<String> src_files;
  String project_type;

  bool include_test;
  String test_dir;
  String test_include_dir;
  String test_src_dir;
  String testing_framework;
  List<String> test_files;

  Project(
      {this.name,
      this.include_dir,
      this.src_dir,
      this.use_conan,
      this.lock_cmake,
      this.project_type,
      this.include_test,
      this.test_include_dir,
      this.test_src_dir,
      this.test_dir,
      this.testing_framework}) {
    header_files = [];
    src_files = [];
    test_files = [];
  }

  Project.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        include_dir = json['include_dir'],
        header_files = List<String>.from(json['header_files']),
        src_dir = json['src_dir'],
        src_files = List<String>.from(json['src_files']),
        use_conan = json['use_conan'],
        lock_cmake =
            json.containsKey('lock_cmake') ? json['lock_cmake'] : false,
        project_type = json['project_type'],
        include_test = json['include_test'],
        test_include_dir = json['test_include_dir'],
        test_src_dir = json['test_src_dir'],
        test_files = List<String>.from(json['test_files']),
        test_dir = json['test_dir'],
        testing_framework = json['testing_framework'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'include_dir': include_dir,
        'header_files': header_files,
        'src_dir': src_dir,
        'src_files': src_files,
        'use_conan': use_conan,
        'lock_cmake': lock_cmake,
        'project_type': project_type,
        'include_test': include_test,
        'test_include_dir': test_include_dir,
        'test_src_dir': test_src_dir,
        'test_files': test_files,
        'test_dir': test_dir,
        'testing_framework': testing_framework
      };
}
