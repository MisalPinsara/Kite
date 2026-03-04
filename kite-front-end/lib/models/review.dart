class Review {
  final String name;
  final String description;
  final int? eventId;

  Review({
    required this.name,
    required this.description,
    this.eventId,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      name: json['name'],
      description: json['description'],
      eventId: json['eventId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'eventId': eventId,
  };
}
