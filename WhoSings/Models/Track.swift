//
//  Track.swift
//  WhoSings
//
//  Created by netfarm on 03/04/21.
//

import ObjectMapper


class TrackDict: Mappable {
    var track: Track?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        track            <- map["track"]
    }
}

class Track: Mappable {
    var track_id: Int?
    var track_name: String?
    var commontrack_id: Int?
    var has_lyrics: Int?
    var artist_id: Int?
    var artist_name: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        track_id            <- map["track_id"]
        track_name          <- map["track_name"]
        commontrack_id      <- map["commontrack_id"]
        has_lyrics          <- map["has_lyrics"]
        artist_id           <- map["artist_id"]
        artist_name         <- map["artist_name"]
    }
}
