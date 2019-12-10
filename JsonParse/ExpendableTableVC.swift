//
//  ExpendableTableVC.swift
//  JsonParse
//
//  Created by mac on 12/9/19.
//  Copyright © 2019 Gopabandhu. All rights reserved.
//

import UIKit
import SwiftyJSON
import KJExpandableTableTree

struct Pocket: Codable{

    var name: String = ""
    var isAvailable: Bool = false
    var displayName: String = ""
    var isSys: Bool = false
    var currentLavel: Int = 0
    var isChecked: Bool = false
    var parent: String = ""
    var childCount: Int = 0
    var id: String = ""
    var count: Int = 0
    var child: [Pocket]!

    enum CodingKeys: String, CodingKey{

        case name = "Name"
        case isAvailable = "IsAvailable"
        case displayName = "DisplayName"
        case isSys = "IsSys"
        case currentLavel = "CurrentLevel"
        case isChecked = "IsChecked"
        case parent = "Parent"
        case childCount = "ChildCount"
        case id = "Id"
        case child = "Child"
        case count = "Count"

    }

    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        isAvailable = try values.decodeIfPresent(Bool.self, forKey: .isAvailable) ?? false
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName) ?? ""
        isSys = try values.decodeIfPresent(Bool.self, forKey: .isSys) ?? false
        currentLavel = try values.decodeIfPresent(Int.self, forKey: .currentLavel) ?? 0
        isChecked = try values.decodeIfPresent(Bool.self, forKey: .isChecked) ?? false
        parent = try values.decodeIfPresent(String.self, forKey: .parent) ?? ""
        childCount = try values.decodeIfPresent(Int.self, forKey: .childCount) ?? 0
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        count = try values.decodeIfPresent(Int.self, forKey: .count) ?? 0
        child = try values.decodeIfPresent([Pocket].self, forKey: .child)

    }
}


class ExpendableTableVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tblView: UITableView!

    // KJ Tree instances -------------------------
    var arrOfPocket = [Pocket]()
    var arrOfFilteredPocket: KJTree = KJTree()
    var arrOfContects = [Pocket]()
    var parsed: NSArray!
    var count: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let file = "/Users/macbt/Desktop/JsonParse/pocket.geojson"
        let path = URL(fileURLWithPath: file)
        let text = try! String(contentsOf: path)
        
        let data = text.data(using: .utf8)!
        
        self.arrOfPocket = try! JSONDecoder().decode([Pocket].self, from: data)
        print(self.arrOfPocket)
        
        arrOfContects = filterData(pocketId: "327566ae-a329-4afa-b38f-b05be63778cf")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(arrOfContects)
        count = arrOfContects.count
        print(JSON(jsonData))
        
        do{
            // for convert jason data to array
          parsed = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? NSArray
        }
        catch {
            print("error:\(error)")
        }
        
        arrOfFilteredPocket = KJTree(parents: parsed, childrenKey: "Child", key: "Id")

        
        tblView.delegate = self
        tblView.dataSource = self
        
        arrOfFilteredPocket.isInitiallyExpanded = false
        arrOfFilteredPocket.animation = .fade
        tblView.rowHeight = UITableViewAutomaticDimension
        
        tblView.register(UINib.init(nibName: "CellTblVC", bundle: nil), forCellReuseIdentifier: "CellTblVC")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let total = arrOfFilteredPocket.tableView(tblView, numberOfRowsInSection: section)
        return total
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let node = arrOfFilteredPocket.cellIdentifierUsingTableView(tblView, cellForRowAt: indexPath)
        let indexTuples = node.index.components(separatedBy: ".")
        
        var dict:Pocket!
        
        if indexTuples.count == 1{
            let index1 = indexTuples.first
            dict = (arrOfContects[Int(index1!)!])
        }else if indexTuples.count == 2{
            let index1 = indexTuples.first
            let index2 = indexTuples[1]
            dict = ((arrOfContects[Int(index1!)!]).child[Int(index2)!])
        }else if indexTuples.count == 3{
            let index1 = indexTuples.first
            let index2 = indexTuples[1]
            let index3 = indexTuples[2]
            dict = (((arrOfContects[Int(index1!)!]).child[Int(index2)!]).child[Int(index3)!])
        }else if indexTuples.count == 4{
            let index1 = indexTuples.first
            let index2 = indexTuples[1]
            let index3 = indexTuples[2]
            let index4 = indexTuples[3]
            dict = ((((arrOfContects[Int(index1!)!]).child[Int(index2)!]).child[Int(index3)!]).child[Int(index4)!])
        }
        
        print(dict)
        
        
        if indexTuples.count == 1  || indexTuples.count == 4 {
            
            // Parents
            let cellIdentifierParents = "CellTblVC"
            var cellParents: CellTblVC? = tableView.dequeueReusableCell(withIdentifier: cellIdentifierParents) as? CellTblVC
            if cellParents == nil {
                tableView.register(UINib(nibName: "CellTblVC", bundle: nil), forCellReuseIdentifier: cellIdentifierParents)
                cellParents = tableView.dequeueReusableCell(withIdentifier: cellIdentifierParents) as? CellTblVC
            }
            cellParents?.cellFillUp(indexParam: dict.name)
    
            cellParents?.selectionStyle = .none
            
            if node.state == .open {
               cellParents?.btnDropDown.setImage(UIImage(named: "DropDown"), for: .normal)
            }else if node.state == .close {
                cellParents?.btnDropDown.setImage(UIImage(named: "DropDown"), for: .normal)
            }else{
               cellParents?.btnDropDown.setImage(nil, for: .normal)
            }
            
            return cellParents!
            
        }else if indexTuples.count == 2{
            
            // Parents
            let cellIdentifierChilds = "CellTblChildSecondStage"
            var cellChild: CellTblChildSecondStage? = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? CellTblChildSecondStage
            if cellChild == nil {
                tableView.register(UINib(nibName: "CellTblChildSecondStage", bundle: nil), forCellReuseIdentifier: cellIdentifierChilds)
                cellChild = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? CellTblChildSecondStage
            }
            cellChild?.cellFillUp(indexParam: dict.name)
            cellChild?.selectionStyle = .none
            
            if node.state == .open {
                cellChild?.btnDropDown.setImage(UIImage(named: "DropDown"), for: .normal)
            }else if node.state == .close {
                cellChild?.btnDropDown.setImage(UIImage(named: "DropDown"), for: .normal)
            }else{
                cellChild?.btnDropDown.setImage(nil, for: .normal)
            }
            
            return cellChild!
            
        }else if indexTuples.count == 3{
            
            // Parents
            let cellIdentifierChilds = "CellTblChildThirdStage"
            var cellChild: CellTblChildThirdStage? = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? CellTblChildThirdStage
            if cellChild == nil {
                tableView.register(UINib(nibName: "CellTblChildThirdStage", bundle: nil), forCellReuseIdentifier: cellIdentifierChilds)
                cellChild = tableView.dequeueReusableCell(withIdentifier: cellIdentifierChilds) as? CellTblChildThirdStage
            }
            cellChild?.cellFillUp(indexParam: dict.name)
            cellChild?.selectionStyle = .none
            
            if node.state == .open {
                cellChild?.btnDropDown.setImage(UIImage(named: "DropDown"), for: .normal)
            }else if node.state == .close {
                cellChild?.btnDropDown.setImage(UIImage(named: "DropDown"), for: .normal)
            }else{
                cellChild?.btnDropDown.setImage(nil, for: .normal)
            }
            
            return cellChild!
        }else{
            // Childs
            // grab cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellidentity") as! CellTblVC
            return cell
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = arrOfFilteredPocket.tableView(tblView, didSelectRowAt: indexPath)
        print(node.index)
        print(node.key)
        // if you've added any identifier or used indexing format
        print(node.givenIndex)
    }
    
    func filterData(pocketId: String) -> [Pocket]{
        
        var arrOfMatchedData = [Pocket]()
        
        for i in 0..<arrOfPocket.count{
            
            if pocketId == arrOfPocket[i].parent{
                
                if arrOfPocket[i].childCount > 0{
                    
                    arrOfPocket[i].child = filterData(pocketId: arrOfPocket[i].id)
                    arrOfPocket[i].count = arrOfPocket[i].child.count
                }
                
                arrOfMatchedData.append(arrOfPocket[i])
            }
            
        }
        
        return arrOfMatchedData
    }

}
