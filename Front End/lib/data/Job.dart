Job jobFromJson(jsonData) {
  return Job.fromMap(jsonData);
}

Job jobFromQuery(queryRow) {
  return Job.fromQuery(queryRow);
}

class Job {
  int id;
  String added, city, company, date, image, location, salary, summary, title, titleURL;

  Job({
    this.id,
    this.added,
    this.city,
    this.company,
    this.date,
    this.image,
    this.location,
    this.salary,
    this.summary,
    this.title,
    this.titleURL
  });

  factory Job.fromMap(Map<String, dynamic> json) => new Job(
    id: json["_id"],
    added: json["Added"],
    city: json["City"],
    company: json["Company"],
    date: json["Date"],
    image: json["Image"],
    location: json["Location"],
    salary: json["Salary"],
    summary: json["Summary"],
    title: json["Title"],
    titleURL: json["TitleURL"],
  );

  factory Job.fromQuery(Map<String, dynamic> query) => new Job(
    id: query["id"],
    added: query["added"],
    city: query["city"],
    company: query["company"],
    date: query["date"],
    image: query["image"],
    location: query["location"],
    salary: query["salary"],
    summary: query["summary"],
    title: query["title"],
    titleURL: query["title_url"],
  );
}