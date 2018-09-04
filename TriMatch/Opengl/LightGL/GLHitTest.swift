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


class HitTest {
    
    var t: GLfloat
    var hit: GLVector    //碰撞点
    var normal: GLVector //碰撞法线
    
    init(t: GLfloat? = nil, hit: GLVector, normal: GLVector) {
        self.t = t ?? GLfloat.infinity
        self.hit = hit
        self.normal = normal
    }
    
    //more precise HitTest
    func mergeWith(other: HitTest)
    {
        if other.t > 0 && other.t < self.t
        {
            self.t = other.t
            self.hit = other.hit
            self.normal = other.normal
        }
    }
    
}
