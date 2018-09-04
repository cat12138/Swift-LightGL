//
//  GameConfig.swift
//  TriMatch
//
//  Created by sj on 2018/7/3.
//  Copyright © 2018 sj. All rights reserved.
//

import Foundation
/*
 游戏流程：
 加载界面，就在下载游戏资源
 进入主界面，提示框询问用户是否需要注册
 不，进入游戏
 */

struct GameConfig{
    struct Music {
        static let bgMusic = ""
        static let clickMusic = ""
        static let passMusic = ""
        static let failMusic = ""
    }
    struct User {
        var deviceName: String
        var deviceToken: UInt32
        var UUID: UInt32
        var deviceType: String
        var username: String
        var password: String
    }
    
}
