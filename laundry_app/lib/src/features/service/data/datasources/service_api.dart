import 'package:laundry_app/src/features/service/data/models/price_model.dart';
import 'package:laundry_app/src/features/service/data/models/service_model.dart';

// JSON giả
const mockServicesJson = [
  {
    "id": 1,
    "name": "Giặt sấy",
    "description": "Giặt sạch - sấy khô trong 60 phút",
    "icon": "lib/src/assets/images/laundry.png",
    "is_main": true
  },
  {
    "id": 2,
    "name": "Giặt hấp",
    "description": "Giặt hấp cao cấp cho áo vest, áo dạ",
    "icon": "lib/src/assets/images/laundry.png",
    "is_main": true
  },
  {
    "id": 3,
    "name": "Ủi quần áo",
    "description": "Ủi thẳng phẳng lì",
    "icon": "lib/src/assets/images/laundry.png",
    "is_main": false
  },
  {
    "id": 4,
    "name": "Tẩy quần áo",
    "description": "Tẩy quần áo trắng",
    "icon": "lib/src/assets/images/laundry.png",
    "is_main": false
  },
  {
    "id": 5,
    "name": "Vá quần áo",
    "description": "Vá quần áo",
    "icon": "lib/src/assets/images/laundry.png",
    "is_main": false
  },
  {
    "id": 6,
    "name": "Tẩy quần áo màu",
    "description": "Tẩy quần áo màu",
    "icon": "lib/src/assets/images/laundry.png",
    "is_main": false
  },



];
const mockPricesJson =[
  {
    "service": "Giặt sấy",
    "types": [
      {
        "name": "Quần áo",
        "items": [
          { "subname": "Áo trắng", "cost": 15000, "unit": "kg" },
          { "subname": "Áo ra màu", "cost": 15000, "unit": "kg" },
          { "subname": "Áo khoác", "cost": 30000, "unit": "kg" }
        ]
      },
      {
        "name": "Rèm cửa",
        "items": [
          { "subname": "Rèm cửa", "cost": 40000,"unit": "kg" },
          { "subname": "Thảm", "cost": 20000,"unit": "kg" },
          { "subname": "Nệm đơn", "cost": 100000,"unit": "cái" },
          { "subname": "Nệm đôi", "cost": 150000 ,"unit": "cái"}
        ]
      }
    ]
  },
  {
    "service": "Giặt hấp ",
    "types": [
      {
        "name": "Quần áo",
        "items": [
          { "subname": "Áo trắng", "cost": 20000, "unit": "kg" },
          { "subname": "Áo ra màu", "cost": 20000, "unit": "kg" },
          { "subname": "Áo khoác", "cost": 35000, "unit": "kg" }
        ]
      },
      {
        "name": "Rèm cửa",
        "items": [
          { "subname": "Rèm cửa", "cost": 50000 ,"unit": "kg" },
          { "subname": "Thảm", "cost": 25000,"unit": "kg"  },
          { "subname": "Nệm đơn", "cost": 120000,"unit": "cái" },
          { "subname": "Nệm đôi", "cost": 170000,"unit": "cái" }
        ]
      }
    ]
  }
];
class ServiceApi {
  Future<List<ServiceModel>> fetchServices() async {
    await Future.delayed(Duration(milliseconds: 500));
    return mockServicesJson
        .map((e) => ServiceModel.fromJson(e))
        .toList();
  }

  Future<List<PriceModel>> fetchPrices() async {
    await Future.delayed(Duration(milliseconds: 500));
    return mockPricesJson
        .map((e) => PriceModel.fromJson(e))
        .toList();
  }
}
