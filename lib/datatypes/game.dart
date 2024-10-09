class Game {
  final String name;
  final String imagepath;
  final String description;
  final String link;
  bool active = false;

  Game(
      {required this.name,
      required this.imagepath,
      required this.description,
      required this.link,
      this.active = false});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      name: json['name'],
      imagepath: json['image'],
      description: json['description'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'imagepath': imagepath,
        'description': description,
        'link': link,
      };
}
