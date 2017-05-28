//
//  EpisodeCell.swift
//  Pod Player
//
//  Created by Guilherme B V Bahia on 27/05/17.
//  Copyright © 2017 Planet Bang. All rights reserved.
//

import Cocoa
import WebKit

class EpisodeCell: NSTableCellView {

   @IBOutlet weak var titleLabel: NSTextField!
   
   @IBOutlet weak var webview: WebView!
   
   @IBOutlet weak var pubDateLabel: NSTextField!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
