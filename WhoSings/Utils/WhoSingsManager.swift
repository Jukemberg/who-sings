//
//  WhoSingsManager.swift
//  WhoSings
//
//  Created by netfarm on 03/04/21.
//

import Foundation
import Alamofire
import ObjectMapper
import RealmSwift

let ROOT_URL = Bundle.main.object(forInfoDictionaryKey: "ROOT_URL") as! String
let MXM_KEY = Bundle.main.object(forInfoDictionaryKey: "MXM_KEY") as! String
let CHART_NAME = Bundle.main.object(forInfoDictionaryKey: "CHART_NAME") as! String
let CHART_COUNTRY = Bundle.main.object(forInfoDictionaryKey: "CHART_COUNTRY") as! String
let DEFAULT_PLAYER = Bundle.main.object(forInfoDictionaryKey: "DEFAULT_PLAYER") as! String

let SEARCH_TRACKS = "\(ROOT_URL)chart.tracks.get?chart_name=\(CHART_NAME)&page=%i&page_size=%i&country=\(CHART_COUNTRY)&f_has_lyrics=1&apikey=\(MXM_KEY)"
let SEARCH_ARTISTS = "\(ROOT_URL)artist.search?page=%i&page_size=%i&apikey=\(MXM_KEY)"
let FIND_LYRICS = "\(ROOT_URL)track.snippet.get?track_id=%i&apikey=\(MXM_KEY)"


class WhoSingsManager: NSObject, UINavigationControllerDelegate {
    
    static let sharedInstance = WhoSingsManager()
        
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
    
    func getPlayerNameAlert(completionHandler: @escaping (_ player_name:String?) -> ()) -> UIAlertController{
        let alertController = UIAlertController(title: "What's your name?", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Name"
            textField.text = WhoSingsManager.sharedInstance.player_name
            textField.keyboardType = .default
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            let player_name = textField.text
            WhoSingsManager.sharedInstance.player_name = player_name
            completionHandler(player_name)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        return alertController
    }
    
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
    
    private func fromMXMToBody(_ value: [String:Any]?) -> [String:Any]?{
        let message = value?["message"] as? [String: Any]
        let body = message?["body"] as? [String: Any]
        return body
    }
    
    func getRandomTracks(with page_size:Int = 10, completionHandler: @escaping (Array<TrackDict>?, Error?, Int?) -> ()){
        getTracks(with: Int.random(in: 1...10), and: page_size, completionHandler: completionHandler)
    }

    
    func getTracks(with page:Int, and page_size:Int = 10, completionHandler: @escaping (Array<TrackDict>?, Error?, Int?) -> ()){
        let url = String(format: SEARCH_TRACKS, page, page_size)
        AF.request(url).responseJSON { outcome in
            let code = outcome.response?.statusCode
            if let error = outcome.error {
                completionHandler(nil, error, code)
                return
            }
            switch outcome.result {
                case .success(let value):
                    let body = self.fromMXMToBody(value as? [String: Any])
                    let track_list = body?["track_list"] as? Array<[String: Any]>
                    let tracks = Mapper<TrackDict>().mapArray(JSONObject: track_list)
                    completionHandler(tracks, nil, code)
                    return
                case .failure(let error):
                    completionHandler(nil, error, code)
                    return
            }
        }
    }
    
    func getLyrics(for track_id:Int, completionHandler: @escaping (Lyric?, Error?, Int?) -> ()){
        let url = String(format: FIND_LYRICS, track_id)
        AF.request(url).responseJSON { outcome in
            let code = outcome.response?.statusCode
            if let error = outcome.error {
                completionHandler(nil, error, code)
                return
            }
            switch outcome.result {
                case .success(let value):
                    let body = self.fromMXMToBody(value as? [String: Any])
                    let snippet = body?["snippet"] as? [String: Any]
                    let lyric = Mapper<Lyric>().map(JSONObject: snippet)
                    completionHandler(lyric, nil, code)
                    return
                case .failure(let error):
                    completionHandler(nil, error, code)
                    return
            }
        }
    }
    
    func getRandomArtist(with page_size:Int = 10, completionHandler: @escaping (Array<ArtistDict>?, Error?, Int?) -> ()){
        getArtists(with: Int.random(in: 1...100), and: page_size, completionHandler: completionHandler)
    }
    
    func getArtists(with page:Int, and page_size:Int = 10, completionHandler: @escaping (Array<ArtistDict>?, Error?, Int?) -> ()){
        let url = String(format: SEARCH_ARTISTS, page, page_size)
        AF.request(url).responseJSON { outcome in
            let code = outcome.response?.statusCode
            if let error = outcome.error {
                completionHandler(nil, error, code)
                return
            }
            switch outcome.result {
                case .success(let value):
                    let body = self.fromMXMToBody(value as? [String: Any])
                    let artist_list = body?["artist_list"] as? Array<[String: Any]>
                    let artists = Mapper<ArtistDict>().mapArray(JSONObject: artist_list)
                    completionHandler(artists, nil, code)
                    return
                case .failure(let error):
                    completionHandler(nil, error, code)
                    return
            }
        }
    }
    
}
