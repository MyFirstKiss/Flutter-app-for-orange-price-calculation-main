import 'package:flutter/material.dart';

class OrangeType {
  final String id;
  final String name;
  final double pricePerKg;
  final String height;
  final String radius;
  final String diameter;
  final List<Color> colors;
  final String description;

  OrangeType({
    required this.id,
    required this.name,
    required this.pricePerKg,
    required this.height,
    required this.radius,
    required this.diameter,
    required this.colors,
    required this.description,
  });

  // สร้าง OrangeType จาก JSON
  factory OrangeType.fromJson(Map<String, dynamic> json) {
    List<Color> getColors(String colorName) {
      switch (colorName) {
        case 'orange':
          return [Colors.orange.shade400, Colors.orange.shade600];
        case 'green':
          return [Colors.green.shade400, Colors.green.shade600];
        case 'amber':
          return [Colors.amber.shade400, Colors.orange.shade500];
        default:
          return [Colors.orange.shade400, Colors.orange.shade600];
      }
    }

    return OrangeType(
      id: json['id'],
      name: json['name'],
      pricePerKg: (json['pricePerKg'] as num).toDouble(),
      height: json['height'],
      radius: json['radius'],
      diameter: json['diameter'],
      colors: getColors(json['color']),
      description: json['description'],
    );
  }

  // แปลง OrangeType เป็น JSON
  Map<String, dynamic> toJson() {
    String getColorName() {
      if (colors[0] == Colors.green.shade400) return 'green';
      if (colors[0] == Colors.amber.shade400) return 'amber';
      return 'orange';
    }

    return {
      'id': id,
      'name': name,
      'pricePerKg': pricePerKg,
      'height': height,
      'radius': radius,
      'diameter': diameter,
      'color': getColorName(),
      'description': description,
    };
  }
}

final List<OrangeType> orangeTypes = [
  OrangeType(
    id: "tangerine",
    name: "ส้มสายน้ำผึ้ง",
    pricePerKg: 45,
    height: "7.5",
    radius: "3.8",
    diameter: "7.6",
    colors: [Colors.orange.shade400, Colors.orange.shade600],
    description: "รสชาติหวานฉ่ำ เนื้อนุ่ม น้ำมาก",
  ),
  OrangeType(
    id: "green-sweet",
    name: "ส้มเขียวหวาน",
    pricePerKg: 35,
    height: "8.2",
    radius: "4.1",
    diameter: "8.2",
    colors: [Colors.green.shade400, Colors.green.shade600],
    description: "หวานกรอบ สดชื่น ไม่เปรี้ยว",
  ),
  OrangeType(
    id: "mandarin",
    name: "ส้มแมนดาริน",
    pricePerKg: 55,
    height: "6.8",
    radius: "3.5",
    diameter: "7.0",
    colors: [Colors.amber.shade400, Colors.orange.shade500],
    description: "หวานหอม ปอกง่าย เนื้อละเอียด",
  ),
];
