import 'dart:convert';

class Note {
  String? name;
  String? date;
  String? notes;

  Note({this.name, this.date, this.notes});

  Note.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        date = json["date"],
        notes = json["notes"];

  Map<String, dynamic> toJson() => {
    "name": name,
    "date": date,
    "notes": notes,
  };

  static String encode(List<Note> notes) => json.encode(
      notes.map<Map<String, dynamic>>((note) => note.toJson()).toList());

  static List<Note> decode(String notes) =>
      json.decode(notes).map<Note>((item) => Note.fromJson(item)).toList();
}