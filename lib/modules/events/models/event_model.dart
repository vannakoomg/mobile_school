// ignore_for_file: non_constant_identifier_names

class EventModel {
  List<Data>? data;

  EventModel({this.data});

  EventModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? date;
  List<Event>? event;

  Data({this.date, this.event});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['event'] != null) {
      event = <Event>[];
      json['event'].forEach((v) {
        event!.add(new Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.event != null) {
      data['event'] = this.event!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Event {
  String? title;
  String? action_color;
  String? time;

  Event({this.title, this.action_color, this.time});

  Event.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    action_color = json['action_color'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['action_color'] = this.action_color;
    data['time'] = this.time;
    return data;
  }
}
