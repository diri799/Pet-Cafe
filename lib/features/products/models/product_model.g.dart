// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      imageUrls: (json['imageUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      category: $enumDecode(_$ProductCategoryEnumMap, json['category']),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isOnSale: json['isOnSale'] as bool? ?? false,
      salePrice: (json['salePrice'] as num?)?.toDouble(),
      brand: json['brand'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      dimensions: json['dimensions'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'imageUrls': instance.imageUrls,
      'category': _$ProductCategoryEnumMap[instance.category]!,
      'stock': instance.stock,
      'isFeatured': instance.isFeatured,
      'isOnSale': instance.isOnSale,
      'salePrice': instance.salePrice,
      'brand': instance.brand,
      'weight': instance.weight,
      'dimensions': instance.dimensions,
      'tags': instance.tags,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ProductCategoryEnumMap = {
  ProductCategory.food: 'food',
  ProductCategory.toys: 'toys',
  ProductCategory.accessories: 'accessories',
  ProductCategory.health: 'health',
  ProductCategory.grooming: 'grooming',
  ProductCategory.clothing: 'clothing',
  ProductCategory.other: 'other',
};
