class Parcel {
  String address;
  bool paidStatus;
  String phone;
  bool pickedUpStatus;
  String sender;
  String timestamp;
  String tracking;
  String description;
  double weight;
  int totalPieces;
  String shipDate;
  int estimateTime;
  String destination;

  Parcel(
      {this.address,
      this.paidStatus,
      this.phone,
      this.pickedUpStatus,
      this.sender,
      this.timestamp,
      this.description,
      this.weight,
      this.destination,
      this.totalPieces,
      this.shipDate,
      this.estimateTime,
      this.tracking});

  factory Parcel.fromMap(Map<String, dynamic> data) {
    return Parcel(
        address: data['address'],
        phone: data['phone'],
        pickedUpStatus: data['pickedUpStatus'],
        sender: data['sender'],
        timestamp: data['timestamp'],
        tracking: data['tracking'],
        description: data['description'],
        weight: data['weight'],
        shipDate: data['shipDate'],
        estimateTime: data['estimateTime'],
        totalPieces: data['totalPieces'],
        destination: data['destination'],
        paidStatus: data['paidStatus']);
  }
}
