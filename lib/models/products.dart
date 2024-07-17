class Products{
  final int id;
  final String image1;
  final String? image2;
  final String? image3;
  final String? image4;
  final String? image5;
  final String brand;
  final String name;
  final double popularity;
  final double price;
  final String description;

  Products({
    required this.id,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
    required this.image5,
    required this.brand, 
    required this.name, 
    required this.popularity, 
    required this.price,
    required this.description,
  });

  factory Products.fromJson(Map<String, dynamic> json){
    return Products(
      id: json['id'], 
      image1: json['image1'], 
      image2: json['image2'], 
      image3: json['image3'], 
      image4: json['image4'], 
      image5: json['image5'], 
      brand: json['brand'], 
      name: json['name'], 
      popularity: double.tryParse(json['popularity']) ?? 0.0, 
      price: double.tryParse(json['price']) ?? 0.0, 
      description: json['description'],
    );
  }

  static List<Products> listProducts(List snapshot){
    return snapshot.map((data){
      return Products.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Products{id: $id, image1: $image1, image2: $image2, image3: $image3, image4: $image4, image5: $image5, brand: $brand, name: $name, popularity: $popularity, price: $price, description: $description}';
  }

}