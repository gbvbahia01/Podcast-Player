//
//  PodcastViewController.swift
//  Pod Player
//
//  Created by Guilherme B V Bahia on 25/05/17.
//  Copyright © 2017 Planet Bang. All rights reserved.
//

import Cocoa

class PodcastViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
   
   
   @IBOutlet weak var tableView: NSTableView!
   
   @IBOutlet weak var podcastUrlTextField: NSTextField!
   
   var episodesVC : EpisodesViewController? = nil;
   var podcasts : [Podcast] = [];
   
   override func viewDidLoad() {
      super.viewDidLoad()
      //podcastUrlTextField.stringValue = "http://www.espn.com/espnradio/podcast/feeds/itunes/podCast?id=2406595";
      getPodcasts()
   }
   
   @IBAction func addPodcastClicked(_ sender: Any) {
      let urlString = podcastUrlTextField.stringValue;
      if !self.podcastExist(rssUrl: urlString) {
         if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {
               (data:Data?, response:URLResponse?, error:Error?) in
               
               if (error != nil) {
                  print(error!);
               } else if (data != nil) {
                  let parser = Parser();
                  let info = parser.getPodcastMetaData(data: data!)
                  if let context = self.getContext() {
                     let podcast = Podcast(context: context)
                     podcast.title = info.title;
                     podcast.imageUrl = info.imageUrl
                     podcast.rssUrl = urlString
                     (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
                     self.getPodcasts()
                     self.episodesVC?.updateView(pod: podcast)
                     DispatchQueue.main.async {
                        self.podcastUrlTextField.stringValue = "";
                     }
                  }
               }
               }.resume()
         }
      }
   }
   
   func getPodcasts() {
      if let context = self.getContext() {
         let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
         fetchy.sortDescriptors = [NSSortDescriptor(key: "title", ascending:true)]
         
         do {
            
            podcasts = try context.fetch(fetchy)
            
         } catch { }
         DispatchQueue.main.async {
            self.tableView.reloadData()
         }
         
      }
   }
   
   
   func getContext() -> NSManagedObjectContext? {
      return (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext
   }
   
   func podcastExist(rssUrl:String) -> Bool {
      if let context = self.getContext() {
         let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
         fetchy.predicate = NSPredicate(format: "rssUrl == %@", rssUrl)

         do {
            
            let mat = try context.fetch(fetchy)
            
            if mat.count > 0 {
               return true;
            }
            
         } catch { }
      }
      return false;
   }
   
   // MARK: - Table Stuff
   
   func numberOfRows(in tableView: NSTableView) -> Int {
      return podcasts.count;
   }
   
   func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
      let cell = tableView.make(withIdentifier: "podcastcell", owner: self) as? NSTableCellView
      let podcast = podcasts[row]
      if podcast.title != nil {
         cell?.textField?.stringValue = podcasts[row].title!
      } else {
         cell?.textField?.stringValue = "UNKNOWN TITLE"
      }
      return cell;
   }
   
   func tableViewSelectionDidChange(_ notification: Notification) {
      if tableView.selectedRow >= 0 {
         let podcast = podcasts[tableView.selectedRow];
         episodesVC?.updateView(pod: podcast)
      }
   }
}
