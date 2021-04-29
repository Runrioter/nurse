//
//  Source.swift
//

import Foundation

struct Source: Codable {

  var title: String

  var slug: String

  var url: URL

  var crawlRate: Int

  enum CodingKeys: String, CodingKey {
    case title
    case slug
    case url
    case crawlRate = "crawl_rate"
  }

}
