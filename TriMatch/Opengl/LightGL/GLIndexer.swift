/*
 * lightgl.js
 * http://github.com/evanw/lightgl.js/
 *
 * Copyright 2011 Evan Wallace
 * Released under the MIT license
 *
 * Swift Version Translator: Shark
 * http://www.jobyme88.com
 */

import Foundation
import GLKit
import OpenGLES

struct GLIndexer {
    var unique: [[GLuint]] = [] //要画的线索引，取名unique是去掉triangle转line中重复的线
    var indices: [Int] = []     //线的编号
    var map: Dictionary<[GLuint], Int> = [:] //[unique, indices]

    //computerWireFrame
    //from triangle to 3 lines
    @discardableResult
    mutating func add(_ obj: [GLuint]) -> Int?
    {
        let key = obj
    
        if !map.keys.contains(key) //重复的不要
        {
            map[key] = self.unique.count;
            self.unique.append(obj)
        }

        return map[key]

    }
}
