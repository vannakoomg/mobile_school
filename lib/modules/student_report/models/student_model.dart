class StudentReport {
  String? subject;
  String? score;
  String? color;

  StudentReport({this.subject, this.score, this.color});

  StudentReport.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    score = json['score'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['score'] = this.score;
    data['color'] = this.color;
    return data;
  }
}
