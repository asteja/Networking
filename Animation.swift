//
//  Animation.swift
//  Networking
//
//  Created by Saiteja Alle on 3/25/17.
//  Copyright © 2017 Saiteja Alle. All rights reserved.
//

import Foundation
import UIKit

class Animation:UITableView {
    
    var likeButtonCenter:CGPoint = CGPoint(x: 0, y: 0)
    var labelButtonCenter:CGPoint = CGPoint(x: 0, y: 0)
    
    
    override func draw(_ rect: CGRect) {
        print("Drawing Started")
        
        let path = UIBezierPath()
        path.move(to: self.likeButtonCenter)
        
        let x = (self.likeButtonCenter.x - self.labelButtonCenter.x)/2
        let y = self.likeButtonCenter.y-30
        
        path.addQuadCurve(to: self.labelButtonCenter, controlPoint: CGPoint(x: x, y: y))
        
        path.lineWidth = 4
        
        path.fill()
        path.stroke()
        
        
    }
    
    
}
