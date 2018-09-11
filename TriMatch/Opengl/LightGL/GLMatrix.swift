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


// m[0], m[1], m[2], m[3]
// m[4], m[5], m[6], m[7],
// m[8], m[9], m[10], m[11],
// m[12], m[13], m[14], m[15]

class GLMatrix {
    var m: [GLfloat] = []
    
    //三个初始化
    init() {
        self.m = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    }
    
    init(_ m: [GLfloat]) {
        self.m = m
    }
    
    init(m0: GLfloat, m1: GLfloat, m2: GLfloat, m3: GLfloat,
         m4: GLfloat, m5: GLfloat, m6: GLfloat, m7: GLfloat,
         m8: GLfloat, m9: GLfloat, m10: GLfloat, m11: GLfloat,
         m12: GLfloat, m13: GLfloat, m14: GLfloat, m15: GLfloat) {
        
        self.m[0] = m0
        self.m[1] = m1
        self.m[2] = m2
        self.m[3] = m3
        
        self.m[4] = m4
        self.m[5] = m5
        self.m[6] = m6
        self.m[7] = m7
        
        self.m[8] = m8
        self.m[9] = m9
        self.m[10] = m10
        self.m[11] = m11
        
        self.m[12] = m12
        self.m[13] = m13
        self.m[14] = m14
        self.m[15] = m15
        
    }
    
    func inverse() -> GLMatrix {
        return GLMatrix.inverse(self)
    }
 
    func transpose() -> GLMatrix {
        return GLMatrix.transpose(self)
    }
    
    func multiply(_ m: GLMatrix) -> GLMatrix {
        return GLMatrix.multiply(left: self, right: m)
    }
    
    func transformPoint(_ m: GLMatrix) {
        
    }
    
    
    func transformVector() {
        
    }
    
    
    //行列式
    func detaminate() -> GLfloat {
        let a11 = m[5]*m[10]*m[15] - m[5]*m[11]*m[14]
        let a12 = m[6]*m[9]*m[15] - m[6]*m[11]*m[13]
        let a13 = m[7]*m[9]*m[14] - m[7]*m[10]*m[13]
        let a = m[0] * (a11 - a12 + a13)
 
        let b11 = m[4]*m[10]*m[15] - m[4]*m[11]*m[14]
        let b12 = m[6]*m[8]*m[15] - m[6]*m[11]*m[12]
        let b13 = m[7]*m[8]*m[14] - m[7]*m[10]*m[12]
        let b = m[1] * (b11 - b12 + b13)

        let c11 = m[4]*m[9]*m[5] - m[4]*m[11]*m[13]
        let c12 = m[5]*m[8]*m[15] - m[5]*m[11]*m[12]
        let c13 = m[7]*m[8]*m[13] - m[7]*m[9]*m[12]
        let c = m[2] * (c11 - c12 + c13)
   
        let d11 = m[4]*m[9]*m[14] - m[4]*m[10]*m[13]
        let d12 = m[5]*m[8]*m[14] - m[5]*m[10]*m[12]
        let d13 = m[6]*m[8]*m[13] - m[6]*m[9]*m[12]
        let d = m[3] * (d11 - d12 + d13)
    
        return a - b + c - d
    }
    
    
    //伴随矩阵
    func adjoint() -> GLMatrix {
        let result = GLMatrix()
        var r = result.m
        
        r[0] = m[5]*m[10]*m[15] - m[5]*m[11]*m[14] - m[6]*m[9]*m[15] + m[6]*m[11]*m[13] + m[7]*m[9]*m[14] - m[7]*m[10]*m[13]
        r[1] = -m[1]*m[10]*m[15] + m[1]*m[11]*m[14] + m[2]*m[9]*m[15] - m[2]*m[11]*m[13] - m[3]*m[9]*m[14] + m[3]*m[10]*m[13]
        r[2] = m[1]*m[6]*m[15] - m[1]*m[7]*m[14] - m[2]*m[5]*m[15] + m[2]*m[7]*m[13] + m[3]*m[5]*m[14] - m[3]*m[6]*m[13]
        r[3] = -m[1]*m[6]*m[11] + m[1]*m[7]*m[10] + m[2]*m[5]*m[11] - m[2]*m[7]*m[9] - m[3]*m[5]*m[10] + m[3]*m[6]*m[9]
        
        r[4] = -m[4]*m[10]*m[15] + m[4]*m[11]*m[14] + m[6]*m[8]*m[15] - m[6]*m[11]*m[12] - m[7]*m[8]*m[14] + m[7]*m[10]*m[12]
        r[5] = m[0]*m[10]*m[15] - m[0]*m[11]*m[14] - m[2]*m[8]*m[15] + m[2]*m[11]*m[12] + m[3]*m[8]*m[14] - m[3]*m[10]*m[12]
        r[6] = -m[0]*m[6]*m[15] + m[0]*m[7]*m[14] + m[2]*m[4]*m[15] - m[2]*m[7]*m[12] - m[3]*m[4]*m[14] + m[3]*m[6]*m[12]
        r[7] = m[0]*m[6]*m[11] - m[0]*m[7]*m[10] - m[2]*m[4]*m[11] + m[2]*m[7]*m[8] + m[3]*m[4]*m[10] - m[3]*m[6]*m[8]

        r[8] = m[4]*m[9]*m[15] - m[4]*m[11]*m[13] - m[5]*m[8]*m[15] + m[5]*m[11]*m[12] + m[7]*m[8]*m[13] - m[7]*m[9]*m[12]
        r[9] = -m[0]*m[9]*m[15] + m[0]*m[11]*m[13] + m[1]*m[8]*m[15] - m[1]*m[11]*m[12] - m[3]*m[8]*m[13] + m[3]*m[9]*m[12]
        r[10] = m[0]*m[5]*m[15] - m[0]*m[7]*m[13] - m[1]*m[4]*m[15] + m[1]*m[7]*m[12] + m[3]*m[4]*m[13] - m[3]*m[5]*m[12]
        r[11] = -m[0]*m[5]*m[11] + m[0]*m[7]*m[9] + m[1]*m[4]*m[11] - m[1]*m[7]*m[8] - m[3]*m[4]*m[9] + m[3]*m[5]*m[8]
        
        r[12] = -m[4]*m[9]*m[14] + m[4]*m[10]*m[13] + m[5]*m[8]*m[14] - m[5]*m[10]*m[12] - m[6]*m[8]*m[13] + m[6]*m[10]*m[12]
        r[13] = m[0]*m[9]*m[14] - m[0]*m[10]*m[13] - m[1]*m[8]*m[14] + m[1]*m[8]*m[14] + m[2]*m[8]*m[13] - m[2]*m[8]*m[13]
        r[14] = -m[0]*m[5]*m[14] + m[0]*m[6]*m[13] + m[1]*m[4]*m[14] - m[1]*m[6]*m[12] - m[2]*m[4]*m[13] + m[2]*m[5]*m[12]
        r[15] = m[0]*m[5]*m[10] - m[0]*m[6]*m[9] - m[1]*m[4]*m[10] + m[1]*m[6]*m[8] + m[2]*m[4]*m[9] - m[2]*m[5]*m[8]
        
        result.m = r
        return result
    }
    
    
    //MARK: class funcs
    // ### GLMatrix.inverse(matrix[, result])
    //
    // Returns the matrix that when multiplied with `matrix` results in the
    // identity matrix. You can optionally pass an existing matrix in `result`
    // to avoid allocating a new matrix. This implementation is from the Mesa
    // OpenGL function `__gluInvertMatrixd()` found in `project.c`.
    // A^-1 = A* / |A|
    
    class func inverse(_ matrix: GLMatrix, result: GLMatrix? = nil) -> GLMatrix {
        let _result = result == nil ? GLMatrix() : result!
        var m = matrix.m, r = _result.m
        
        //伴随矩阵
        r[0] = m[5]*m[10]*m[15] - m[5]*m[11]*m[14] - m[6]*m[9]*m[15] + m[6]*m[11]*m[13] + m[7]*m[9]*m[14] - m[7]*m[10]*m[13]
        r[1] = -m[1]*m[10]*m[15] + m[1]*m[11]*m[14] + m[2]*m[9]*m[15] - m[2]*m[11]*m[13] - m[3]*m[9]*m[14] + m[3]*m[10]*m[13]
        r[2] = m[1]*m[6]*m[15] - m[1]*m[7]*m[14] - m[2]*m[5]*m[15] + m[2]*m[7]*m[13] + m[3]*m[5]*m[14] - m[3]*m[6]*m[13]
        r[3] = -m[1]*m[6]*m[11] + m[1]*m[7]*m[10] + m[2]*m[5]*m[11] - m[2]*m[7]*m[9] - m[3]*m[5]*m[10] + m[3]*m[6]*m[9]
        
        r[4] = -m[4]*m[10]*m[15] + m[4]*m[11]*m[14] + m[6]*m[8]*m[15] - m[6]*m[11]*m[12] - m[7]*m[8]*m[14] + m[7]*m[10]*m[12]
        r[5] = m[0]*m[10]*m[15] - m[0]*m[11]*m[14] - m[2]*m[8]*m[15] + m[2]*m[11]*m[12] + m[3]*m[8]*m[14] - m[3]*m[10]*m[12]
        r[6] = -m[0]*m[6]*m[15] + m[0]*m[7]*m[14] + m[2]*m[4]*m[15] - m[2]*m[7]*m[12] - m[3]*m[4]*m[14] + m[3]*m[6]*m[12]
        r[7] = m[0]*m[6]*m[11] - m[0]*m[7]*m[10] - m[2]*m[4]*m[11] + m[2]*m[7]*m[8] + m[3]*m[4]*m[10] - m[3]*m[6]*m[8]
        
        r[8] = m[4]*m[9]*m[15] - m[4]*m[11]*m[13] - m[5]*m[8]*m[15] + m[5]*m[11]*m[12] + m[7]*m[8]*m[13] - m[7]*m[9]*m[12]
        r[9] = -m[0]*m[9]*m[15] + m[0]*m[11]*m[13] + m[1]*m[8]*m[15] - m[1]*m[11]*m[12] - m[3]*m[8]*m[13] + m[3]*m[9]*m[12]
        r[10] = m[0]*m[5]*m[15] - m[0]*m[7]*m[13] - m[1]*m[4]*m[15] + m[1]*m[7]*m[12] + m[3]*m[4]*m[13] - m[3]*m[5]*m[12]
        r[11] = -m[0]*m[5]*m[11] + m[0]*m[7]*m[9] + m[1]*m[4]*m[11] - m[1]*m[7]*m[8] - m[3]*m[4]*m[9] + m[3]*m[5]*m[8]
        
        r[12] = -m[4]*m[9]*m[14] + m[4]*m[10]*m[13] + m[5]*m[8]*m[14] - m[5]*m[10]*m[12] - m[6]*m[8]*m[13] + m[6]*m[10]*m[12]
        r[13] = m[0]*m[9]*m[14] - m[0]*m[10]*m[13] - m[1]*m[8]*m[14] + m[1]*m[8]*m[14] + m[2]*m[8]*m[13] - m[2]*m[8]*m[13]
        r[14] = -m[0]*m[5]*m[14] + m[0]*m[6]*m[13] + m[1]*m[4]*m[14] - m[1]*m[6]*m[12] - m[2]*m[4]*m[13] + m[2]*m[5]*m[12]
        r[15] = m[0]*m[5]*m[10] - m[0]*m[6]*m[9] - m[1]*m[4]*m[10] + m[1]*m[6]*m[8] + m[2]*m[4]*m[9] - m[2]*m[5]*m[8]
        
        //行列式
        let det = m[0]*r[0] + m[1]*r[4] + m[2]*r[8] + m[3]*r[12]
        for i in 0..<16 { r[i] /= det}
        
        _result.m = r
        return _result
    
    }
    

    //转置
    class func transpose(_ matrix: GLMatrix, result: GLMatrix? = nil)  -> GLMatrix {
        let _result = result == nil ? GLMatrix() : result!
        var m = matrix.m, r = _result.m
      
        r[0] = m[0]
        r[1] = m[4]
        r[2] = m[8]
        r[3] = m[12]
        
        r[4] = m[1]
        r[5] = m[5]
        r[6] = m[9]
        r[7] = m[13]
        
        r[8] = m[2]
        r[9] = m[6]
        r[10] = m[10]
        r[11] = m[14]
        
        r[12] = m[3]
        r[13] = m[7]
        r[14] = m[11]
        r[15] = m[15]
        
        _result.m = r
        return _result
    }
    
    
    /// GLMatrix.multiply(left, right[, result])
    /// glMutlMatrix()
    /// @param result: an optional matrix to avoud allocating a new matrix
    class func multiply(left: GLMatrix, right: GLMatrix, result: GLMatrix? = nil) -> GLMatrix {
        let _result = result == nil ? GLMatrix() : result!
        var a = left.m, b = right.m, r = _result.m
        r[0] = a[0] * b[0] + a[1] * b[4] + a[2] * b[8] + a[3] * b[11]
        r[1] = a[0] * b[1] + a[1] * b[5] + a[2] * b[9] + a[3] * b[12]
        r[2] = a[0] * b[2] + a[1] * b[6] + a[2] * b[10] + a[3] * b[13]
        r[3] = a[0] * b[3] + a[1] * b[7] + a[2] * b[11] + a[3] * b[14]
        
        r[4] = a[4] * b[0] + a[5] * b[4] + a[6] * b[8] + a[7] * b[11]
        r[5] = a[4] * b[1] + a[5] * b[5] + a[6] * b[9] + a[7] * b[12]
        r[6] = a[4] * b[2] + a[5] * b[6] + a[6] * b[10] + a[7] * b[13]
        r[7] = a[4] * b[3] + a[5] * b[7] + a[6] * b[11] + a[7] * b[14]
        
        r[8] = a[8] * b[0] + a[9] * b[4] + a[10] * b[8] + a[11] * b[11]
        r[9] = a[8] * b[1] + a[9] * b[5] + a[10] * b[9] + a[11] * b[12]
        r[10] = a[8] * b[2] + a[9] * b[6] + a[10] * b[10] + a[11] * b[13]
        r[11] = a[8] * b[3] + a[9] * b[7] + a[10] * b[11] + a[11] * b[14]
        
        r[12] = a[12] * b[0] + a[13] * b[4] + a[14] * b[8] + a[15] * b[11]
        r[13] = a[12] * b[1] + a[13] * b[5] + a[14] * b[9] + a[15] * b[12]
        r[14] = a[12] * b[2] + a[13] * b[6] + a[14] * b[10] + a[15] * b[13]
        r[15] = a[12] * b[3] + a[13] * b[7] + a[14] * b[11] + a[15] * b[14]
        
        _result.m = r
        return _result
    }
    
    
    /// GLMatrix.identity([result])
    /// glLoadIdentity()
    /// @param result: an optional matrix to avoud allocating a new matrix
    /// @return an identity matrix
    class func identity(_ result: GLMatrix? = nil) -> GLMatrix {
        let _result = result == nil ? GLMatrix() : result!
        _result.m = [1, 0, 0, 0,
                     0, 1, 0, 0,
                     0, 0, 1, 0,
                     0, 0, 0, 1]
        
        //result.m = [xi, yi, zi, 0,
        //            xj, yj, zj, 0,
        //            xk, yk, zk, 0,
        //            0, 0, 0, 1] //基矩阵
        return _result
    }
    
    
    
    ///        model matrix      view matrix   projection matrix  projection division
    /// model space ---> world space ---> camera space ---> clip space ----> NDC space ----> screen space
    
    
    
    // MARK: 三个transform
    // 对
    /// 1 - from model space to world space
    /// GLMatrix.scale(x, y, z[, result])
    /// glScale()
    /// |Sx, 0, 0, 0|   |x|
    /// |0, Sy, 0, 0|   |y|
    /// |0, 0, Sz, 0|   |z|
    /// |0, 0, 0, 1 |   |1|
    class func scale(Sx: GLfloat, Sy: GLfloat, Sz: GLfloat, result: GLMatrix? = nil) -> GLMatrix {
        let _result = result == nil ? GLMatrix() : result!
        var r = _result.m
        
        r[0] = Sx
        r[1] = 0
        r[2] = 0
        r[3] = 0
        
        r[4] = 0
        r[5] = Sy
        r[6] = 0
        r[7] = 1
        
        r[8] = 0
        r[9] = 0
        r[10] = Sz
        r[11] = 1
        
        r[12] = 0
        r[13] = 0
        r[14] = 0
        r[15] = 1
        
        return _result
    }
    
    
    //|1, 0, 0, Tx|   |x|
    //|0, 1, 0, Ty|   |y|
    //|0, 0, 1, Tz|   |z|
    //|0, 0, 0, 1 |   |1|
    class func translate(Tx: GLfloat, Ty: GLfloat, Tz: GLfloat, result: GLMatrix? = nil) -> GLMatrix {
        let _result = result == nil ? GLMatrix() : result!
        var r = _result.m
        
        r[0] = 1
        r[1] = 0
        r[2] = 0
        r[3] = Tx
        
        r[4] = 0
        r[5] = 1
        r[6] = 0
        r[7] = Ty
        
        r[8] = 0
        r[9] = 0
        r[10] = 1
        r[11] = Tz
        
        r[12] = 0
        r[13] = 0
        r[14] = 0
        r[15] = 1
        
        return _result
    }
    
    
    /// GLMatrix.rotate(a, x, y, z[, result])
    /// glRotate()
    /// @a: rotate angle anticlockwise
    /// @return a matrix that rotates by `a` degrees around the vector `x, y, z`.
    class func rotate(a: GLfloat, Rx: GLfloat, Ry: GLfloat, Rz: GLfloat, result: GLMatrix? = nil) -> GLMatrix {
        let _result = result == nil ? GLMatrix() : result!
        var r = _result.m
        
        let au = GLVector(x: Rx, y: Ry, z: Rz).unit() //旋转轴单位化
        let radian = a * .pi / 180 //转弧度制
        let c = cos(radian), s = sin(radian), t = 1 - c
        
        //大致推导
        /*
        let v = GLVector(x: 1, y: 0, z: 0) //要旋转的点 //v=(0,1,0), v=(0,0,1)
        let va = au.multiply(au.dot(v)) //在旋转轴上的分量，不参与旋转
        let v1 = v.substract(va) //垂直旋转轴的分量，旋转
        
        let v2 = v1.cross(au)
        let v11 = v1.multiply(c).add(v2.multiply(s))
        
        let vv = va.add(v11)
        */
        
        r[0] = au.x*au.x*t + c
        r[1] = au.x*au.y*t - au.z*s
        r[2] = au.x*au.z*t + au.y*s
        r[3] = 0
        
        r[4] = au.y*au.x*t + au.z*s
        r[5] = au.y*au.y*t + c
        r[6] = au.y*au.z*t - au.x*s
        r[7] = 0
        
        r[8] = au.z*au.x*t - au.y*s
        r[9] = au.z*au.y*t + au.x*s
        r[10] = au.z*au.z*t + c
        r[11] = 0
        
        r[12] = 0
        r[13] = 0
        r[14] = 0
        r[15] = 1
      
        
        
        
        
        
        
        
        
        _result.m = r
        return _result
    }
    
    
    ///pitch俯仰角 绕x轴转
    //|1, 0, 0, 0|
    //|0, cos(t), -sin(t), 0|
    //|0, sin(t), cos(t), 0|
    //|0, 0, 0, 1|
    class func rotateX(_ angle: GLfloat, result: GLMatrix? = nil) -> GLMatrix {
        let _result = result == nil ? GLMatrix() : result!
        var r = _result.m
        
        let t = angle * .pi / 180
        r[0] = 1
        r[1] = 0
        r[2] = 0
        r[3] = 0
        
        r[4] = 0
        r[5] = cos(t)
        r[6] = -sin(t)
        r[7] = 0
        
        r[8] = 0
        r[9] = sin(t)
        r[10] = cos(t)
        r[11] = 0
        
        r[12] = 0
        r[13] = 0
        r[14] = 0
        r[15] = 1
        
        _result.m = r
        return _result
    }
   
    
    //yaw偏航角 绕y轴转
    // ^x
    // | /
    // |/
    // -------> z
    //|cos(t), 0, sin(t), 0|
    //|0, 1, 0, 0|
    //|-sin(t), 0, cos(t), 0|
    //|0, 0, 0, 1|
    class func rotateY(_ angle: GLfloat, result: GLMatrix? = nil) -> GLMatrix {
        let _result = result == nil ? GLMatrix() : result!
        var r = _result.m
        
        let t = angle * .pi / 180
        r[0] = cos(t)
        r[1] = 0
        r[2] = sin(t)
        r[3] = 0
        
        r[4] = 0
        r[5] = 1
        r[6] = 0
        r[7] = 0
        
        r[8] = -sin(t)
        r[9] = 0
        r[10] = cos(t)
        r[11] = 0
        
        r[12] = 0
        r[13] = 0
        r[14] = 0
        r[15] = 1
        
        _result.m = r
        return _result
    }
    
    
    //roll翻滚角 绕z轴转
    //正交矩阵，A^t = A^-1
    //绕谁转，谁是1
    //|cos(t), -sin(t), 0, 0|
    //|sin(t), cos(t), 0, 0|
    //|0, 0, 1, 0|
    //|0, 0, 0, 1|
    class func rotateZ(_ angle: GLfloat, result: GLMatrix? = nil) -> GLMatrix {
        let _result = result == nil ? GLMatrix() : result!
        var r = _result.m
        
        let t = angle * .pi / 180
        r[0] = cos(t)
        r[1] = -sin(t)
        r[2] = 0
        r[3] = 0
        
        r[4] = sin(t)
        r[5] = cos(t)
        r[6] = 0
        r[7] = 0
        
        r[8] = 0
        r[9] = 0
        r[10] = 1
        r[11] = 0
        
        r[12] = 0
        r[13] = 0
        r[14] = 0
        r[15] = 1
        
        _result.m = r
        return _result
    }
    
    /// @param pitch x
    /// @param yaw y
    /// @param roll z
    class func euler(pitch: GLfloat, yaw: GLfloat, roll: GLfloat, _ result: GLMatrix? = nil) -> GLMatrix {
        var _result = result == nil ? GLMatrix() : result!
        
        let Rx = GLMatrix.rotateX(pitch)
        let Ry = GLMatrix.rotateY(yaw)
        let Rz = GLMatrix.rotateZ(roll)
        
        _result = Rz.multiply(Ry.multiply(Rx))
        
        return _result
    }
    
    
    class func quaternion(angle: GLfloat, x: GLfloat, y: GLfloat, z: GLfloat) {
        
    }
    
    
    
   

    
    /// 2 - from world space to camera space
    /// @param ex ey ex: eye point
    /// @param cx cy cz: target point
    /// @param ux uy uz: up direction
    /// default eye = (0, 0, 0), up = (0, 1, 0, center = (0, 0, -z)
    class func lookAt(ex: GLfloat, ey: GLfloat, ez: GLfloat, cx: GLfloat, cy: GLfloat, cz: GLfloat, ux: GLfloat, uy: GLfloat, uz: GLfloat, _ result: GLMatrix? = nil)  -> GLMatrix {
        let _result = result == nil ? GLMatrix() : result!
        var m = _result.m
        
        let e = GLVector(x: ex, y: ey, z: ez)
        let c = GLVector(x: cx, y: cy, z: cz)
        let u = GLVector(x: ux, y: uy, z: uz)
        
        //camera coordinate
        let f = e.substract(c).unit()   //z
        let s = u.cross(f).unit()     //x
        let t = f.cross(s).unit()     //y
        
        
        //相机坐标相对世界坐标进行了旋转/平移，M=T*R（顶点不动）
        //因为opengl，世界坐标和相机坐标重合，所以定点做了M的逆矩阵，即M^-1 = R^-1 * T^-1
        //M^-1 is what we need
        /*
         let transInverse = GLMatrix(m0: 1, m1: 0, m2: 0, m3: -ex,
         m4: 0, m5: 1, m6: 0, m7: -ey,
         m8: 0, m9: 0, m10: 1, m11: -ez,
         m12: 0, m13: 0, m14: 0, m15: 1)
         
         let camera = GLMatrix(m0: s.x, m1: t.x, m2: f.x, m3: 0,
         m4: s.y, m5: t.y, m6: f.y, m7: 0,
         m8: s.z, m9: t.z, m10: f.z, m11: 0,
         m12: 0, m13: 0, m14: 0, m15: 1)
         
         let cameraInverse = GLMatrix(m0: s.x, m1: s.y, m2: s.z, m3: 0,
         m4: t.x, m5: t.y, m6: t.z, m7: 0,
         m8: f.x, m9: f.y, m10: f.z, m11: 0,
         m12: 0, m13: 0, m14: 0, m15: 1)
         
         //let MI: GLMatrix = cameraInverse.multiply(transInverse)
         let MI = GLMatrix(m0: s.x, m1: s.y, m2: s.z, m3: -s.dot(e),
         m4: t.x, m5: t.y, m6: t.z, m7: -t.dot(e),
         m8: f.x, m9: f.y, m10: f.z, m11: -f.dot(e),
         m12: 0, m13: 0, m14: 0, m15: 1)
         */
        m[0] = s.x
        m[1] = s.y
        m[2] = s.z
        m[3] = -s.dot(e)
        
        m[4] = t.x
        m[5] = t.y
        m[6] = t.z
        m[7] = -t.dot(e)
        
        m[8] = f.x
        m[9] = f.y
        m[10] = f.z
        m[11] = -f.dot(e)
        
        m[12] = 0
        m[13] = 0
        m[14] = 0
        m[15] = 1
        
        _result.m = m
        return _result
    }
    
    
    /// 3 - from camera space to clip space
    /// GLMatrix.frustum(l, r, b, t, n, f[, result])
    /// glFrustum()
    /// @return a projection matrix(general)
    class func frustum(l: GLfloat, r: GLfloat, b: GLfloat, t: GLfloat, n: GLfloat, f: GLfloat, _ result: GLMatrix? = nil) -> GLMatrix {
        let _result = result == nil ? GLMatrix() : result!
        var m = _result.m
        
        m[0] = 2 * n / (r - l);
        m[1] = 0;
        m[2] = (r + l) / (r - l);
        m[3] = 0;
        
        m[4] = 0;
        m[5] = 2 * n / (t - b);
        m[6] = (t + b) / (t - b);
        m[7] = 0;
        
        m[8] = 0;
        m[9] = 0;
        m[10] = -(f + n) / (f - n);
        m[11] = -2 * f * n / (f - n);
        
        m[12] = 0;
        m[13] = 0;
        m[14] = -1;
        m[15] = 0;
        
        _result.m = m
        return _result
    }
    
    
    /// GLMatrix.perspective(fov, aspect, near, far[, result])
    /// gluPerspective()
    /// @return a projectio matrix, with fov parameters
    class func perspective(fov: GLfloat, aspect: GLfloat, near: GLfloat, far: GLfloat, result: GLMatrix? = nil) -> GLMatrix{
        let _result = result == nil ? GLMatrix() : result!
        
        let y = tan(fov * .pi / 360) * near
        let x = y * aspect
        
        return GLMatrix.frustum(l: -x, r: x, b: -y, t: y, n: near, f: far, _result)
    }
    
    
    /// GLMatrix.ortho()
    class func ortho(l: GLfloat, r: GLfloat, b: GLfloat, t: GLfloat, n: GLfloat, f: GLfloat, _ result: GLMatrix? = nil) -> GLMatrix {
        let _result = result == nil ? GLMatrix() : result!
        var m = _result.m
        
        m[0] = 2 / (r - l);
        m[1] = 0;
        m[2] = 0;
        m[3] = -(r + l) / (r - l);
        
        m[4] = 0;
        m[5] = 2 / (t - b);
        m[6] = 0;
        m[7] = -(t + b) / (t - b);
        
        m[8] = 0;
        m[9] = 0;
        m[10] = -2 / (f - n);
        m[11] = -(f + n) / (f - n);
        
        m[12] = 0;
        m[13] = 0;
        m[14] = 0;
        m[15] = 1;
        
        _result.m = m
        return _result
    }
    
    
    
    /// 5 - from NDC space to screen space
    /// glViewport(GLint sx, GLint sy, GLsizei ws, GLsizei hs);
    /// glDepthRangef(GLclampf ns, GLclampf fs);
    class func viewport(sx: GLfloat, sy: GLfloat, w: GLfloat, h: GLfloat, n: GLfloat, f: GLfloat, _ result: GLMatrix? = nil) -> GLMatrix {
        let _result = result == nil ? GLMatrix() : result!
        var m = _result.m
        
        m[0] = w/2
        m[1] = 0
        m[2] = 0
        m[3] = sx + w/2
        
        m[4] = 0
        m[5] = h/2
        m[6] = 0
        m[7] = sy + h/2
        
        m[8] = 0
        m[9] = 0
        m[10] = (f - n)/2
        m[11] = (f + n)/2
        
        m[12] = 0
        m[13] = 0
        m[14] = 0
        m[15] = 1
        
        _result.m = m
        return _result
    }
    
    
    
    

}
