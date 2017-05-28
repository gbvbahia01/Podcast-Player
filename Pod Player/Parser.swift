//
//  Parser.swift
//  Pod Player
//
//  Created by Guilherme B V Bahia on 26/05/17.
//  Copyright © 2017 Planet Bang. All rights reserved.
//

import Foundation

class Parser {
   func getPodcastMetaData(data:Data) -> (title:String?, imageUrl:String?) {
      
      let xml = SWXMLHash.parse(data);
      
      return (xml["rss"]["channel"]["title"].element?.text,
      xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text)
   }
   
   func getEpisode(data:Data) -> [Episode] {
      let xml = SWXMLHash.parse(data);
      
      var episodes : [Episode] = []
      
      for item in xml["rss"]["channel"]["item"] {
         let epsode = Episode()
         if let title = item["title"].element?.text {
            epsode.title = title;
         }else {
            epsode.title = "UNKNOW"
         }
         if let html = item["description"].element?.text {
            epsode.htmlDescription = html;
         }
         if let audio = item["enclosure"].element?.attribute(by: "url")?.text {
            epsode.audioUrl = audio;
         }
         if let pubDate = item["pubDate"].element?.text {
            epsode.setPubDate(date: pubDate)
         }
         episodes.append(epsode)
      }
      
      return episodes
   }
}
