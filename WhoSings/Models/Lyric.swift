//
//  Lyric.swift
//  WhoSings
//
//  Created by netfarm on 03/04/21.
//

import ObjectMapper

class Lyric: Mappable {
    var snippet_language: String?
    var snippet_body: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        snippet_language    <- map["snippet_language"]
        snippet_body        <- map["snippet_body"]
    }
}
