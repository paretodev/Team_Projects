//
//  DataModel.swift
//  ToDoApp2
//
//  Created by 한석희 on 10/29/20.
//

import Foundation

class DataModel { // <- 메소드로 계산을 해서 주고, 데이터를 가지고 있다 : 데이터 관련 일 <- 불러오기, 저장하기, 연산하기
    
//MARK:-정적 메소드
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set( itemID + 1, forKey: "ChecklistItemID" )
        return itemID
    }
    
// MARK: - 속성
    var lists : [Checklist] = []
    var lastVisitedScreen : Int {
        get {
            return UserDefaults.standard.integer(forKey: "lastVisitedScreen")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "lastVisitedScreen")
        }
    }
// MARK: - 생성자, 사망자
        // 1).
    init(){
        loadChecklists()
        registerDefaults() // 디폴트값 등록
        handleFirstTime()  // 앱 깔고 처음이라고 나온다면 -> lastVisitedScreen 0, lists에 추가
    }

// MARK: - 불러오기 & 저장 메소드
        // 1).
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask  )
        return paths[0]
    }
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("ToDoAppListsData.plist")
    }
        // 2).
    func saveChecklists(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode( lists )
            try data.write(
                to : dataFilePath(),
                options : Data.WritingOptions.atomic
            )
        }
        catch{
            print(  "Error encoding an Checklist obj array: \(error.localizedDescription)"  )
        }
    }
        // 3).
    func loadChecklists( ){
        let path = dataFilePath()
        if let data = try? Data( contentsOf: path ) {
            let decoder = PropertyListDecoder()
            do{
               lists = try decoder.decode(  [Checklist].self, from: data  )
            }catch{
                print( "Error decoding Checklist obj array : \(error.localizedDescription)" )
            }
        }
    }
// MARK: - 기타 메소드
    
    // 1).
    func registerDefaults(){
        let dictionary = ["lastVisitedScreen" : -1, "FirstTime" : true, "ChecklistItemID" : 0] as [String : Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    //2).
    func handleFirstTime(){
        //<1>.
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        //<2>.
        if firstTime {
                // 1>
            let checklist = Checklist(name: "리스트 샘플 : )")
            lists.append(checklist)
                // 2> ( 처음일 경우 ) -> 바로 스크린 0번으로 이동
           lastVisitedScreen = 0
            //  처음이 아닌 것으로 바꾸기
            userDefaults.setValue(false, forKey: "FirstTime")
        }
    }
    
        //<3>.  데이터 모델이 포함하는 리스트들을 사전순으로 정렬 !!
    func sortChecklists(){
        lists.sort { list1, list2 in
            return list1.name.localizedStandardCompare( list2.name ) == .orderedAscending
        }
    }
    //
}
