//
//  Artist.swift
//  WhoSings
//
//  Created by netfarm on 03/04/21.
//

import ObjectMapper


class ArtistDict: Mappable {
    var artist: Artist?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        artist            <- map["artist"]
    }
}

class Artist: Mappable {
    var artist_id: Int?
    var artist_name: String?
    
    init() {}
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        artist_id           <- map["artist_id"]
        artist_name         <- map["artist_name"]
    }
}
