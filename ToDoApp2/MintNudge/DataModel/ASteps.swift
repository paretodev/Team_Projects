//
//  ASteps.swift
//  MintNudge
//
//  Created by 한석희 on 11/2/20.
//

import Foundation

class ASteps : NSObject, Codable {
    //
    var list : [Step] = []
    //
    override init(){
        super.init()
    }
    //
    func progress() -> Float {
        if list.isEmpty{
            return 0.0
        }
        return Float(  self.list.reduce(0){if $1.isDone == true { return $0 + 1 } else{ return $0 } } / list.count  )
    }
    
}
