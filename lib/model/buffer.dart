class Buffer {
  int? bufferId;
  String? bufferType;
  int? pricePerPerson;

  Buffer({this.bufferId, this.bufferType, this.pricePerPerson});

  Buffer.fromJson(Map<String, dynamic> json) {
    bufferId = json['buffer_id'];
    bufferType = json['buffer_type'];
    pricePerPerson = json['price_per_person'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buffer_type'] = this.bufferType;
    data['price_per_person'] = this.pricePerPerson.toString();
    return data;
  }

  Map<String, dynamic> toJsonUpdate() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buffer_id'] = this.bufferId.toString();
    data['buffer_type'] = this.bufferType;
    data['price_per_person'] = this.pricePerPerson.toString();
    return data;
  }
}
