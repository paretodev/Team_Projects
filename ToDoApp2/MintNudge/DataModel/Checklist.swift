//
//  Checklist.swift
//  ToDoApp2
//
//  Created by 한석희 on 10/29/20.
//

import Foundation
import UIKit

class Checklist : NSObject, Codable {
    // MARK: - 속성
    var name = ""
    var items = [ChecklistItem]()
    var iconName = "No Icon"
    // MARK: - 생성자. 사망자
        // 1). 오버 로딩
    init(name: String, iconName: String = "No Icon"){
        self.name = name
        self.iconName = iconName
        super.init()
    }
        // 2).오버 라이딩
    override init(){
        super.init()
    }
    // MARK: - 기타 메서드
        // 1). 아직 미완된 갯수 세기
    func countUndone() -> Int {
       return items.reduce(0){ if $1.checked == true { return $0  } else{ return $0+1 } }
    }
        // 2). 데드 라인 순으로 정렬하기
    func sortItems() {
        items.sort{ item1, item2 in
            item1.dueDate < item2.dueDate
        }
    }
}
