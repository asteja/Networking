//
//  ManageThread.swift
//  Networking
//
//  Created by Saiteja Alle on 3/24/17.
//  Copyright © 2017 Saiteja Alle. All rights reserved.
//

import Foundation

class ManageThread {
    
    func networkingQueue(work:DispatchWorkItem) {
        let queue = DispatchQueue(label: "com.apple.Networking")
        queue.async(execute: work)
    }
    
    func dataQueue(work:DispatchWorkItem) {
        let queue = DispatchQueue(label: "com.apple.dataTask")
        queue.async(execute: work)
    }
    
    func mainQueue(work:DispatchWorkItem) {
        let queue = DispatchQueue.main
        queue.async(execute: work)
        
    }
    
}
