//
//  Episode.swift
//  Pod Player
//
//  Created by Guilherme B V Bahia on 27/05/17.
//  Copyright © 2017 Planet Bang. All rights reserved.
//

import Cocoa

class Episode {
   
   var title = ""
   var pubDate = Date()
   var htmlDescription = ""
   var audioUrl = ""
   
   func setPubDate(date: String) {
      if let pub = Episode.formatter.date(from: date) {
         pubDate = pub;
      }
   }
   
   func getPudDate() -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMM d, yyyy"
      return dateFormatter.string(from: pubDate)
   }
   
   private static let formatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
      return formatter
   }()
}
