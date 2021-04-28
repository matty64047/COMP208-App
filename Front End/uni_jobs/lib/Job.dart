Job jobFromJson(jsonData) {
  return Job.fromMap(jsonData);
}

class Job {
  int id, ratingCount;
  String added, university, rating, daysAgo, company, image, location, salary, description, title, titleURL, workType, logo;

  Job({
    required this.id,
    required this.added,
    required this.university,
    required this.company,
    required this.image,
    required this.logo,
    required this.location,
    required this.salary,
    required this.description,
    required this.title,
    required this.titleURL,
    required this.workType,
    required this.rating,
    required this.ratingCount,
    required this.daysAgo
  });

  factory Job.fromMap(Map<String, dynamic> json) => new Job(
    id: json["id"],
    added: json["added"],
    university: json["city"],
    company: json["company"],
    image: json["image"],
    location: json["location"],
    salary: json["salary"],
    description: json["description"],
    title: json["title"],
    rating: json["rating"],
    ratingCount: json["rating_count"],
    titleURL: json["title_url"],
    workType: json["work_type"],
    logo: json["logo"],
    daysAgo: json["days_ago"]
  );
}