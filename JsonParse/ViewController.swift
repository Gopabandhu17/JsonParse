////
////  ViewController.swift
////  JsonParse
////
////  Created by Gopabandhu on 12/10/19.
////  Copyright © 2019 Gopabandhu. All rights reserved.
////
//
//import UIKit
//import SwiftyJSON
//
//
//struct Pocket: Codable{
//
//    var name: String = ""
//    var isAvailable: Bool = false
//    var displayName: String = ""
//    var isSys: Bool = false
//    var currentLavel: Int = 0
//    var isChecked: Bool = false
//    var parent: String = ""
//    var childCount: Int = 0
//    var id: String = ""
//    var count: Int = 0
//    var child: [Pocket]!
//
//    enum CodingKeys: String, CodingKey{
//
//        case name = "Name"
//        case isAvailable = "IsAvailable"
//        case displayName = "DisplayName"
//        case isSys = "IsSys"
//        case currentLavel = "CurrentLevel"
//        case isChecked = "IsChecked"
//        case parent = "Parent"
//        case childCount = "ChildCount"
//        case id = "Id"
//        case child = "Child"
//        case count = "Count"
//
//    }
//
//    init(from decoder: Decoder) throws {
//
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
//        isAvailable = try values.decodeIfPresent(Bool.self, forKey: .isAvailable) ?? false
//        displayName = try values.decodeIfPresent(String.self, forKey: .displayName) ?? ""
//        isSys = try values.decodeIfPresent(Bool.self, forKey: .isSys) ?? false
//        currentLavel = try values.decodeIfPresent(Int.self, forKey: .currentLavel) ?? 0
//        isChecked = try values.decodeIfPresent(Bool.self, forKey: .isChecked) ?? false
//        parent = try values.decodeIfPresent(String.self, forKey: .parent) ?? ""
//        childCount = try values.decodeIfPresent(Int.self, forKey: .childCount) ?? 0
//        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
//        count = try values.decodeIfPresent(Int.self, forKey: .count) ?? 0
//        child = try values.decodeIfPresent([Pocket].self, forKey: .child)
//
//    }
//}
//
//
//class ViewController: UIViewController {
//
//    var arrOfPocket = [Pocket]()
//    var arrOfFilteredPocket = [Pocket]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let file = "/Users/macbt/Desktop/JsonParse/pocket.geojson"
//        let path = URL(fileURLWithPath: file)
//        let text = try! String(contentsOf: path)
//
//
//        let data = text.data(using: .utf8)!
//
//        self.arrOfPocket = try! JSONDecoder().decode([Pocket].self, from: data)
//        print(self.arrOfPocket)
//
//        for dict in self.arrOfPocket{
//
//            if dict.id == "327566ae-a329-4afa-b38f-b05be63778cf"{
//
//                arrOfFilteredPocket.append(dict)
//                break
//            }
//        }
//
//        let filter = filterData(pocketId: "00000000-0000-0000-0000-000000000000")
//        print(filter)
//
//        let jsonEncoder = JSONEncoder()
//        let jsonData = try! jsonEncoder.encode(filter)
//        let json = String(data: jsonData, encoding: String.Encoding.utf8)
//        print(json)
//
//
//        let data1 = json!.data(using: .utf8)!
//        do {
//            if let jsonArray = try JSONSerialization.jsonObject(with: data1, options : .allowFragments) as? [Dictionary<String,Any>]
//            {
//                print(jsonArray) // use the json here
//                print(JSON(jsonArray))
//            } else {
//                print("bad json")
//            }
//        } catch let error as NSError {
//            print(error)
//        }
//
//    }
//
//
//    func filterData(pocketId: String) -> [Pocket]{
//
//        var arrOfMatchedData = [Pocket]()
//
//        for i in 0..<arrOfPocket.count{
//
//            if pocketId == arrOfPocket[i].parent{
//
//                if arrOfPocket[i].childCount > 0{
//
//                    arrOfPocket[i].child = filterData(pocketId: arrOfPocket[i].id)
//                    arrOfPocket[i].count = arrOfPocket[i].child.count
//                }
//
//                arrOfMatchedData.append(arrOfPocket[i])
//            }
//
//        }
//
//
//        return arrOfMatchedData
//    }
//
//
//}
//
