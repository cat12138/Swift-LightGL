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
import OpenGLES
import GLKit

class GLVector {
    var x: GLfloat = 0
    var y: GLfloat = 0
    var z: GLfloat = 0
    
    init(x: GLfloat, y: GLfloat, z: GLfloat) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func negative() -> GLVector
    {
        return GLVector(x: -self.x, y: -self.y, z: -self.z)
    }
    
    func add(_ v: GLVector) -> GLVector
    {
        return GLVector(x: self.x + v.x, y: self.y + v.y, z: self.z + v.z)
    }
    
    func add(_ v: GLfloat) -> GLVector
    {
        return GLVector(x: self.x + v, y: self.y + v, z: self.z + v)
    }
    
    func substract(_ v: GLVector) -> GLVector
    {
        return GLVector(x: self.x - v.x, y: self.y - v.y, z: self.z - v.z)
    }
    
    func substract(_ v: GLfloat) -> GLVector
    {
        return GLVector(x: self.x - v, y: self.y - v, z: self.z - v)
    }
    
    func multiply(_ v: GLVector) -> GLVector
    {
        return GLVector(x: self.x * v.x, y: self.y * v.y, z: self.z * v.z)
    }
    
    func multiply(_ v: GLfloat) -> GLVector
    {
        return GLVector(x: self.x * v, y: self.y * v, z: self.z * v)
    }

    func divide(_ v: GLVector) -> GLVector
    {
        return GLVector(x: self.x / v.x, y: self.y / v.y, z: self.z / v.z)
    }
    
    func divide(_ v: GLfloat) -> GLVector
    {
        return GLVector(x: self.x / v, y: self.y / v, z: self.z / v)
    }
    
    func equals(_ v: GLVector) -> Bool
    {
        return (self.x == v.x) && (self.y == v.y) && (self.z == v.z)
    }
    
    func dot(_ v: GLVector) -> GLfloat {
        return self.x * v.x + self.y * v.y + self.z * v.z
    }
    
    func cross(_ v: GLVector) -> GLVector {
        let nX = self.y * v.z - self.z * v.y
        let nY = self.x * v.z - self.z * v.x
        let nZ = self.x * v.y - self.y * v.x
        return GLVector(x: nX, y: nY, z: nZ)
    }
    
    func lengh() -> GLfloat {
        return sqrtf(self.dot(self))
    }
    
    func unit() -> GLVector {
        return self.divide(self.lengh())
    }
    
    func min() -> GLfloat {
        return Swift.min(Swift.min(self.x, self.y), self.z)
    }
    func max() -> GLfloat {
        return Swift.max(Swift.max(self.x, self.y), self.z)
    }
    
    func clone() -> GLVector {
        return GLVector(x: self.x, y: self.y, z: self.z)
    }
    
    

    class func min(_ a: GLVector, _ b: GLVector) -> GLVector
    {
        return GLVector(x: Swift.min(a.x, b.y), y: Swift.min(a.y, b.y), z: Swift.min(a.z, b.z))
    }
    
    class func max(_ a: GLVector, _ b: GLVector) -> GLVector
    {
        return GLVector(x: Swift.max(a.x, b.x), y: Swift.max(a.y, b.y), z: Swift.max(a.z, b.z))
    }
    
    class func lerp(_ a: GLVector, _ b: GLVector, fraction: GLfloat) -> GLVector
    {
        return a.add(b.substract(a).multiply(fraction))
    }
    
    class func fromArray(_ a: [GLfloat]) -> GLVector
    {
        return GLVector(x: a[0], y: a[1], z: a[2])
    }
}
