class Listing {
  final String id;
  final String title;
  final double price;
  final String location;
  final double lat;
  final double lng;
  final String image;
  final String description;
  final String userId;

  Listing({
    required this.id,
    required this.title,
    required this.price,
    required this.location,
    required this.lat,
    required this.lng,
    required this.image,
    required this.description,
    required this.userId,
  });

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
    id: json['_id'],
    title: json['title'],
    price: (json['price'] as num).toDouble(),
    location: json['location'],
    lat: (json['lat'] as num).toDouble(),
    lng: (json['lng'] as num).toDouble(),
    image: json['image'],
    description: json['description'] ?? "",
    userId: json['user'],
  );
}
