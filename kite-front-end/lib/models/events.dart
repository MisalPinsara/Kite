class Event {
  final int id;
  final String name;
  final String date;
  final String time;
  final int seats;
  final int seatsLeft;
  final String location;
  final String? description;
  final String? image;
  final String? registeredMail;
  
  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.seats,
    required this.seatsLeft,
    required this.location,
    this.description,
    this.image,
    this.registeredMail,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['Id'] ?? json['id'],
      name: json['Name'] ?? json['name'],
      date: json['Date'] ?? json['date'],
      time: json['Time'] ?? json['time'],
      seats: json['seats'],
      seatsLeft: json['seatsLeft'],
      location: json['Location'] ?? json['location'],
      description: json['description'],
      image: json['image'],
      registeredMail: json['registeredMail'],
    );
  }

  Map<String, dynamic> toJson() => {
    'Id': id,
    'Name': name,
    'Date': date,
    'Time': time,
    'seats': seats,
    'seatsLeft': seatsLeft,
    'Location': location,
    'description': description,
    'image': image,
    if (registeredMail != null) 'registeredMail': registeredMail,
  };
}