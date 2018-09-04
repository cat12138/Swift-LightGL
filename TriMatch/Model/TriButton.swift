
//
//  TriButton.swift
//  TriMatch
//
//  Created by sj on 2018/7/3.
//  Copyright © 2018 sj. All rights reserved.
//

import Foundation
import UIKit

class TriButton: UIButton {
    var name: String!
    var id: Int!
    
    var scale: CGFloat!
    var width: CGFloat
    

 
    init(){
        let deviceWidth = UIScreen.main.bounds.size.width
        width = deviceWidth / 10
        let f = CGRect(origin: .zero, size: CGSize(width: width, height: width))
        super.init(frame: f)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
