class Comment{
  final int id;
  final int productId;
  final String name;
  final String? profile;
  final String comment;

  Comment({
    required this.id,
    required this.productId,
    required this.name,
    this.profile,
    this.comment = '',
  });

  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
      id: json['id'], 
      productId: json['product_id'],
      name: json['user']['name'], 
      profile: json['user']['profile'], 
      comment: json['comment_text'] ?? ''
    );
  }

  static List<Comment> listComments(List snapshot){
    return snapshot.map((data){
      return Comment.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Comment{id: $id, product ID: $productId, name: $name, profile: $profile, comment: $comment}';
  }
}