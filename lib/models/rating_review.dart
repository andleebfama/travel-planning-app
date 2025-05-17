class RatingReview {
  final String id;
  final String title; 
  final double rating; 
  final String review; 
  final String userId; 
  final DateTime date;

  RatingReview({
    required this.id,
    required this.title,
    required this.rating,
    required this.review,
    required this.userId,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'rating': rating,
      'review': review,
      'userId': userId,
      'date': date.toIso8601String(),
    };
  }

  factory RatingReview.fromMap(Map<String, dynamic> map) {
    return RatingReview(
      id: map['id'],
      title: map['title'],
      rating: map['rating'],
      review: map['review'],
      userId: map['userId'],
      date: DateTime.parse(map['date']),
    );
  }
}
