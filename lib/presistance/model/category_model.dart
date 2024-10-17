class CategoryModel {
  final String title;
  final String description;
  final String imageUrl;

  CategoryModel(
      {required this.title, required this.description, required this.imageUrl});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        title: json['title'],
        description: json['description'],
        imageUrl: json['image_url'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'image_url': imageUrl,
      };
}
