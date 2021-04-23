Job jobFromJson(jsonData) {
  return Job.fromMap(jsonData);
}

class Job {
  int id, ratingCount;
  String added, university, rating, daysAgo, company, image, location, salary, description, title, titleURL, workType, logo;

  Job({
    this.id,
    this.added,
    this.university,
    this.company,
    this.image,
    this.logo,
    this.location,
    this.salary,
    this.description,
    this.title,
    this.titleURL,
    this.workType,
    this.rating,
    this.ratingCount,
    this.daysAgo
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