class AidRequest {
  final String CategoryTitle;
  final String title;
  final String description;
  final List<dynamic> imgUrls;
  final Map<String, dynamic> location;
  final List<dynamic> subCategories;
  final String owner;

  AidRequest({
    required this.CategoryTitle,
    required this.title,
    required this.description,
    required this.imgUrls,
    required this.location,
    required this.subCategories,
    required this.owner,
  });

  factory AidRequest.fromJson(Map<String, dynamic> json) {
    return AidRequest(
      CategoryTitle: json['Category Title']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imgUrls: json['imgUrls'] is List
          ? List<String>.from(json['imgUrls'].map((e) => e.toString()))
          : [], 
      location: json['location'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['location'])
          : {}, 
      subCategories: json['subCategories'] is List
          ? List<String>.from(json['subCategories'].map((e) => e.toString()))
          : [],
      owner: json['owner']?.toString() ?? '',
    );
  }
}
