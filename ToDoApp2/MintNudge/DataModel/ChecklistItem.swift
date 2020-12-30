//
//  ChecklistItem.swift
//  ToDoApp2
//
//  Created by 한석희 on 10/29/20.
//

import Foundation
import UserNotifications

class ChecklistItem : NSObject, Codable {
    
    // 속성
    var name : String = ""
    var checked : Bool = false
    var shouldRemind : Bool = false
    var notificationID : Int = -1
    var notificationID_h : Int = -1
    var notificationID_d : Int = -1
    var dueDate: Date = Date() // default  date obj -> for deadline ( right now )
    var steps : ASteps = ASteps()
    
    // 생성자, 사망자
   override init(){
        self.notificationID = DataModel.nextChecklistItemID() // 알림 해당 시간용
        self.notificationID_h = DataModel.nextChecklistItemID() // 1시간 전용
        self.notificationID_d = DataModel.nextChecklistItemID() // 1일 전용
        super.init() // 상속 - 상위 객체 부분 초기화
    }
    deinit {
        self.removeNotification()
    }
    // 메소드
        // 1.
    func sheduleNotification(){
        self.removeNotification()
        if shouldRemind == true && dueDate > Date() {
            //1. dueDate에 맞게, 해당 시간, 1일 전, 1시간 전 노티피케이션 리퀘스트 등록
            let notiRequest1 = configureNotiRequest(of: dueDate, by: .day)
            let notiRequest2 = configureNotiRequest(of: dueDate, by: .hour)
            let notiRequest3 = configureNotiRequest(of: dueDate, by: .second) // -> 로직에 의해 해당시간으로 계산됨
            //2. 센터에 신청 제출
            let center = UNUserNotificationCenter.current()
            center.add( notiRequest1 )
            center.add( notiRequest2 )
            center.add( notiRequest3 )
        }
    }
    //2.
    func removeNotification( ){
        // 그 기기의 내부 알림 센터 레퍼런스 받기
        let center = UNUserNotificationCenter.current()
        // 센터에 체크리스트 아이템과 매칭되는 노티피케이션 객체 삭제 ( 스트링 리스트 )
        center.removePendingNotificationRequests( withIdentifiers: [ "\(self.notificationID_d)" ]  )
        center.removePendingNotificationRequests( withIdentifiers: [ "\(self.notificationID_h)" ]  )
        center.removePendingNotificationRequests( withIdentifiers: [ "\(self.notificationID)" ]  )
    }
    
    // Date, 시간 단위 -> 알림 리퀘스트 생성
    func configureNotiRequest(of date: Date, by factor: Calendar.Component ) -> UNNotificationRequest {
        //
        let content = UNMutableNotificationContent()
        var unitComponent   =  DateComponents()
        var notiID = -1 // 디폴트
        //
        switch factor {
            case .day:
                content.title =  "데드라인 1일 전 🤷🏻‍♀️🤷🏻‍♂️"
                content.body =  "\(self.name)  👈🏻 데드라인이 1일 앞으로 다가왔습니다"
                unitComponent.day = -1
                notiID = notificationID_d
            case .hour:
                content.title = "데드라인 1시간 전 😱"
                content.body = "\(self.name) 👈🏻 데드라인이 1시간 남았습니다."
                unitComponent.hour = -1
                notiID = notificationID_h
            default:
                content.title = "데드라인 💣"
                content.body = "\(self.name) 👈🏻 데드라인이 마감되었습니다."
                unitComponent.second = 0
                notiID = notificationID
        }
        //
        content.sound = .default
        let theCalendar = Calendar.current
        let targetDate = theCalendar.date( byAdding: unitComponent, to: date )
        //
        let calendar = Calendar( identifier: .gregorian )
        let components = calendar.dateComponents( [ .year, .month, .day, .hour, .minute ],  from: targetDate! )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest( identifier: "\(notiID)", content: content, trigger: trigger )
        //
        return request
    }
    
    // 끝
}
