//
//  WhoSingsRealm.swift
//  WhoSings
//
//  Created by netfarm on 03/04/21.
//

import Foundation
import RealmSwift

    
func saveAndClearScore(){
    // save
    let realm = try! Realm()
    let score = Score()
    score.player_name = player_name
    score.points = current_score
    try! realm.write {
        realm.add(score)
    }
    //clear
    current_score = 0
}


func getPlayerScores(quantity:Int) -> ReversedCollection<Results<Score>>.SubSequence{
    let realm = try! Realm()
    let playerScores = realm.objects(Score.self).filter("player_name == %@", player_name ?? "").reversed()
    return playerScores.prefix(quantity)
}

func getHighScores(quantity:Int) -> Slice<Results<Score>>{
    let realm = try! Realm()
    let highScores = realm.objects(Score.self).sorted(byKeyPath: "points", ascending: false)
    return highScores.prefix(quantity)
}
