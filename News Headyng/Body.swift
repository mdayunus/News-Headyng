//
//  Body.swift
//  News Headyng
//
//  Created by Mohammad Yunus on 08/05/19.
//  Copyright © 2019 taptap. All rights reserved.
//

import Foundation
struct Body: Codable {
    var copyright: String
    var last_updated: String
    var num_results: Int
    var results: [News]
    var section: String
    var status: String
}

struct News: Codable {
    var abstract: String
    var byline: String
    var created_date: String
    var des_facet: [String]
    var geo_facet: [String]
    var item_type: String
    var kicker: String
    var material_type_facet: String
    var multimedia: [Multimedia]
    var org_facet: [String]
    var per_facet: [String]
    var published_date: String
    var section: String
    var short_url: String?
    var subsection: String
    var title: String
    var updated_date: String
    var url: String
}

struct Multimedia: Codable {
    var caption: String
    var copyright: String
    var format: String
    var height: Int
    var subtype: String
    var type: String
    var url: String
    var width: Int
}
