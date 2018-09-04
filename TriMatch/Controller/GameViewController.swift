//
//  GameViewController.swift
//  TriMatch
//
//  Created by sj on 2018/7/3.
//  Copyright © 2018 sj. All rights reserved.
//

import UIKit
import GameplayKit

class GameViewController: UIViewController {

    var timer: Timer!
   
    var origins: [TriButton] = []
    var sub: UIView!
    var show: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generateBtns()
        
    }
    

  
    
    
    func downloadResources() {
        
    }
    
    func generateBtns() {
        //此json从网上下载
        var file = Bundle.main.url(forResource: "res", withExtension: "json")
        if file == nil {
            print("[Error]: have no resource");
            //找到备份文件，确保游戏能玩
            file = Bundle.main.url(forResource: "res_bk", withExtension: "json")
        }
    
        let fileData = try! Data(contentsOf: file!)
        let fileJson: [[String: Any]] = try! JSONSerialization.jsonObject(with: fileData, options:.allowFragments) as! [[String : Any]]
        for i in 0..<fileJson.count {
            
            let oriBtn = TriButton()
            
            for (key, value) in fileJson[i] {
                if key == "name" {
                    oriBtn.name = value as? String
                }
                if key == "id" {
                    oriBtn.id = value as? Int
                }
                if key == "derivative_pic" {
                    //gameplay产生随机浮点数
                    //let a = GKRandomSource.sharedRandom().nextUniform()
                   
                    /* 随机颜色 */
                    //[0, 100)
                    let r: Int = Int(arc4random() % 256)
                    let g: Int = Int(arc4random() % 256)
                    let b: Int = Int(arc4random() % 256)
                    let randomColor = UIColor(red: CGFloat(r / 255), green: CGFloat(g / 255), blue: CGFloat(b / 255), alpha: 1.0)
                    oriBtn.backgroundColor = randomColor
                    
                }
            }
      
            origins.append(oriBtn)
        }
    }
    
    
    
  

    func layoutBtns() {
        
        GKRandomSource.sharedRandom().arrayByShufflingObjects(in: origins)
        
        var leftBtns: [TriButton] = []
        var rightBtns: [TriButton] = []
        
        var margin: CGFloat = 30
        var upMargin: CGFloat {
            return margin * 2
        }
        var leftMargin: CGFloat {
            return margin * 1.5
        }
        
        for i in 0..<4 {
            leftBtns.append(origins[i])
        }
        
    }
}


extension GKRandomSource {
    func dicByShufflingObjects(in dict: NSMutableDictionary) -> NSMutableDictionary {
        var keys = dict.allKeys
        self.arrayByShufflingObjects(in: keys)
        let final: NSMutableDictionary = [:]
        for i in 0..<keys.count {
            final[keys[i]] = dict.value(forKey: keys[i] as! String)
        }
        return final
    }
}



extension GameViewController: UIGestureRecognizerDelegate {

}
