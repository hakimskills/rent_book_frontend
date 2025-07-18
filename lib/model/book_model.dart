class BookModel {
  final int id;
  final String title;
  final String? cover;
  final String author;
  final String? description;
  final String? category;
  final String status;

  BookModel({
    required this.id,
    required this.title,
    this.cover,
    required this.author,
    this.description,
    this.category,
    required this.status,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as int,
      title: json['title'] as String,
      cover: json['cover'] as String?,
      author: json['author'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cover': cover,
      'author': author,
      'description': description,
      'category': category,
      'status': status,
    };
  }

  // Add this method to get the full image URL
  String get imageUrl {
    if (cover == null || cover!.isEmpty) {
      return 'assets/img/default.jpg'; // Fallback to local asset
    }

    // If it's already a full URL, return as is
    if (cover!.startsWith('http')) {
      return cover!;
    }

    // If it's a relative path, prepend your server URL
    return 'http://192.168.1.4:8000/storage/$cover';
  }
}
