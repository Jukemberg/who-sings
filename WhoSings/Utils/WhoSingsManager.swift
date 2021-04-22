//
//  WhoSingsManager.swift
//  WhoSings
//
//  Created by netfarm on 03/04/21.
//

import Foundation

let DEFAULT_PLAYER = Bundle.main.object(forInfoDictionaryKey: "DEFAULT_PLAYER") as! String

var player_name:String?{
    get {
        let defaults = UserDefaults.standard
        return defaults.string(forKey:"PNAME") ?? DEFAULT_PLAYER
    }
    set(name) {
        let defaults = UserDefaults.standard
        return defaults.set(name, forKey: "PNAME")
    }
}

var current_score:Int{
    get {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey:"SCORE")
    }
    set(name) {
        let defaults = UserDefaults.standard
        return defaults.set(name, forKey: "SCORE")
    }
}
