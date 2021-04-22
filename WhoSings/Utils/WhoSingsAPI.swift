//
//  WhoSingsAPI.swift
//  WhoSings
//
//  Created by netfarm on 03/04/21.
//

import Foundation
import Alamofire
import ObjectMapper

let ROOT_URL = Bundle.main.object(forInfoDictionaryKey: "ROOT_URL") as! String
let MXM_KEY = Bundle.main.object(forInfoDictionaryKey: "MXM_KEY") as! String
let CHART_NAME = Bundle.main.object(forInfoDictionaryKey: "CHART_NAME") as! String
let CHART_COUNTRY = Bundle.main.object(forInfoDictionaryKey: "CHART_COUNTRY") as! String

let SEARCH_TRACKS = "\(ROOT_URL)chart.tracks.get?chart_name=\(CHART_NAME)&page=%i&page_size=%i&country=\(CHART_COUNTRY)&f_has_lyrics=1&apikey=\(MXM_KEY)"
let SEARCH_ARTISTS = "\(ROOT_URL)artist.search?page=%i&page_size=%i&apikey=\(MXM_KEY)"
let FIND_LYRICS = "\(ROOT_URL)track.snippet.get?track_id=%i&apikey=\(MXM_KEY)"


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
                let body = fromMXMToBody(value as? [String: Any])
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
                let body = fromMXMToBody(value as? [String: Any])
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
                let body = fromMXMToBody(value as? [String: Any])
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
    
