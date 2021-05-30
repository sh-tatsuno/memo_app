class Memo {
  String title;
  String detail;
  DateTime? createdTime;
  DateTime? updatedDate;

  Memo({
    required this.title, 
    required this.detail, 
    this.createdTime,
    this.updatedDate
    });
}

