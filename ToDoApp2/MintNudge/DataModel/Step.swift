//
//  Step.swift
//  MintNudge
//
//  Created by 한석희 on 11/2/20.
//

import Foundation

class Step : NSObject, Codable {
    var task : String = ""
    var isDone : Bool = false
    //
    override init(){
        super.init()
    }
    //
    init(task: String, isDone: Bool){
        self.task = task
        self.isDone = isDone
    }
    //
}
