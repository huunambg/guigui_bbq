class Tablee {
  int? tableId;
  String? tableName;
  int? capacity;
  String? status;

  Tablee({this.tableId, this.tableName, this.capacity, this.status});

  Tablee.fromJson(Map<String, dynamic> json) {
    tableId = json['table_id'];
    tableName = json['table_name'];
    capacity = json['capacity'] as int;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['table_name'] = this.tableName;
    data['capacity'] = this.capacity.toString();
    return data;
  }

  Map<String, dynamic> toJsonUpdate() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['table_id'] = this.tableId;
    data['table_name'] = this.tableName;
    data['capacity'] = this.capacity;
    data['status'] = this.status;
    return data;
  }
}
