//
//  Score.swift
//  WhoSings
//
//  Created by netfarm on 07/04/21.
//
import RealmSwift

class Score: Object {
    @objc dynamic var player_name:String?
    @objc dynamic var points:Int = 0
    
}
