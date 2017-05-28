//
//  SplitController.swift
//  Pod Player
//
//  Created by Guilherme B V Bahia on 27/05/17.
//  Copyright © 2017 Planet Bang. All rights reserved.
//

import Cocoa

class SplitController: NSSplitViewController {

   @IBOutlet weak var podcastViewItem: NSSplitViewItem!
   
   @IBOutlet weak var episodeViewItem: NSSplitViewItem!
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
      if let podcastVC = podcastViewItem.viewController as? PodcastViewController {
         if let episodeVC = episodeViewItem.viewController as? EpisodesViewController {
            podcastVC.episodesVC = episodeVC;
            episodeVC.podcastVC = podcastVC;
         }
      }
    }
    
}
