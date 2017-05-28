//
//  EpisodesViewController.swift
//  Pod Player
//
//  Created by Guilherme B V Bahia on 27/05/17.
//  Copyright © 2017 Planet Bang. All rights reserved.
//

import Cocoa
import AVFoundation

class EpisodesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
   
   @IBOutlet weak var titleLabel: NSTextField!
   
   @IBOutlet weak var imageView: NSImageView!
   
   @IBOutlet weak var deleteButton: NSButton!
   @IBOutlet weak var pausePlayButton: NSButton!
   
   @IBOutlet weak var tableView: NSTableView!
   
   var podcastVC : PodcastViewController? = nil
   var podcast : Podcast? = nil
   var episodes : [Episode] = []
   var player : AVPlayer? = nil
   
   override func viewDidLoad() {
      super.viewDidLoad()
      updateView(pod: nil)
   }
   
   override func viewWillDisappear() {
      super.viewWillDisappear()
      player?.pause()
      player = nil
   }
   
   func updateView(pod: Podcast?) {
      self.podcast = pod
      
      if pod == nil {
         titleLabel.stringValue = ""
         imageView.image = nil
         tableView.isHidden = true
         deleteButton.isHidden = true
         self.checkPlayPauseButton()
         return;
      }
      
      tableView.isHidden = false
      deleteButton.isHidden = false
      self.checkPlayPauseButton()
      
      if self.podcast?.title != nil {
         titleLabel.stringValue = podcast!.title!;
      }
      if self.podcast?.imageUrl != nil {
         let image = NSImage(byReferencing: URL(string: self.podcast!.imageUrl!)!)
         imageView.image = image
      }
      
      self.getEpisodes()
   }
   
   func checkPlayPauseButton() {
      if player == nil || (player?.isMuted)! {
         pausePlayButton.isHidden = true
      }
   }
   
   func getEpisodes() {
      if self.podcast?.rssUrl != nil {
         
         if let url = URL(string: self.podcast!.rssUrl!) {
            
            URLSession.shared.dataTask(with: url) {
               (data:Data?, response:URLResponse?, error:Error?) in
               
               if (error != nil) {
                  print(error!);
               } else if (data != nil) {
                  let parser = Parser();
                  self.episodes = parser.getEpisode(data: data!)
                  DispatchQueue.main.async {
                     self.tableView.reloadData()
                  }
               }
               }.resume()
         }
      }
   }
   
   @IBAction func deleteClicked(_ sender: Any) {
      if (self.podcast != nil) {
         if let context = self.getContext() {
            context.delete(self.podcast!)
            (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
            updateView(pod: nil)
            self.podcastVC?.getPodcasts()
         }
      }
   }
   
   @IBAction func pauseClicked(_ sender: Any) {
      if pausePlayButton.title == "Pause" {
      player?.pause()
      pausePlayButton.title = "Play"
      } else {
         player?.play()
         pausePlayButton.title = "Pause"
      }
   }
   
   func getContext() -> NSManagedObjectContext? {
      return (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext
   }
   
   // MARK: - Table Stuff
   func numberOfRows(in tableView: NSTableView) -> Int {
      return episodes.count
   }
   
   func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
      let episode = episodes[row]
      let cell = tableView.make(withIdentifier: "episodeCell", owner: self) as? EpisodeCell
      cell?.titleLabel.stringValue = episode.title
      cell?.pubDateLabel.stringValue = episode.getPudDate()
      cell?.webview.mainFrame.loadHTMLString(episode.htmlDescription, baseURL: nil)
      return cell;
   }
   
   func tableViewSelectionDidChange(_ notification: Notification) {
      if tableView.selectedRow >= 0 {
         let episode = episodes[tableView.selectedRow]
         if let url = URL(string: episode.audioUrl) {
            player?.pause()
            player = nil;
            player = AVPlayer(url: url)
            player?.play()
            pausePlayButton.isHidden = false
            pausePlayButton.title = "Pause"
         }
      }
   }
   
   func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
      return 100
   }
}
