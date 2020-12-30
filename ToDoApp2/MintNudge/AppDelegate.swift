//
//  AppDelegate.swift
//  ToDoApp2
//
//  Created by 한석희 on 10/29/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    // MARK:- 앱이 👌시작되자 마자, 시퀀스 진행이 가능한 곳
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
            // 디바이스별  알림 센터 레퍼런스를 가져오고, 델리게이트로서 등록
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        //
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // This method will be called when app received push notifications in foreground
        // 노티피케이션 센터에 delegate로 등록하고, 거기에서 센터에 도착한 알림에 대해서, 인앱상황에서 어떻게 처리할지 핸뜰링하는 것.
        // 배너, 리스트, 사운드 모두 ( 투 듀 리스트 앱 )
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler( [ .list, .banner, .sound ] )
    }

}

/*  [  UNNotification 객체  ]
 <UNNotification: 0x600001dab270; source: com.sos.ToDoApp2 date: 2020-11-01 11:34:00 +0000, request: <UNNotificationRequest: 0x600001dab600; identifier: 5, content: <UNNotificationContent: 0x600002846a40; title: <redacted>, subtitle: (null), body: <redacted>, summaryArgument: , summaryArgumentCount: 0, categoryIdentifier: , launchImageName: , threadIdentifier: , attachments: (
 ), badge: (null), sound: <UNNotificationSound: 0x600003809260>, realert: 0, trigger: <UNCalendarNotificationTrigger: 0x6000013f5320; dateComponents: <NSDateComponents: 0x6000011696d0> {
     Calendar Year: 2020
     Month: 11
     Day: 1
     Hour: 20
     Minute: 34, repeats: NO>>, intents: (
 )>
    앱 사용중 노티피케이션 센터에서, 알림을 받은 것에 대한 정보를 객체에 받는다. -> alert 로 치환시키고 싶다.
 */
