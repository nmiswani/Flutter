class AboutUs {
  String? title;
  String? description;
  String? sambungan; // <-- Tambah ini
  String? image1;
  String? image2;
  String? image3;
  String? contactNumber;
  String? email;
  String? operatingHours;
  String? locationLat;
  String? locationLng;
  String? locationName;
  String? locationAddress;

  AboutUs({
    this.title,
    this.description,
    this.sambungan, // <-- Tambah ini
    this.image1,
    this.image2,
    this.image3,
    this.contactNumber,
    this.email,
    this.operatingHours,
    this.locationLat,
    this.locationLng,
    this.locationName,
    this.locationAddress,
  });

  AboutUs.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    sambungan = json['sambungan']; // <-- Tambah ini
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
    contactNumber = json['contact_number'];
    email = json['email'];
    operatingHours = json['operating_hours'];
    locationLat = json['location_lat'].toString();
    locationLng = json['location_lng'].toString();
    locationName = json['location_name'];
    locationAddress = json['location_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['sambungan'] = sambungan; // <-- Tambah ini
    data['image1'] = image1;
    data['image2'] = image2;
    data['image3'] = image3;
    data['contact_number'] = contactNumber;
    data['email'] = email;
    data['operating_hours'] = operatingHours;
    data['location_lat'] = locationLat;
    data['location_lng'] = locationLng;
    data['location_name'] = locationName;
    data['location_address'] = locationAddress;
    return data;
  }
}
