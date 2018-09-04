//
//  NormalDistribution.swift
//  TriMatch
//
//  Created by sj on 2018/8/17.
//  Copyright © 2018 sj. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit


enum FuncType {
    case sigmoid
    case normalDistribution
    case spiral
    case rose
    case heart
    case circle
    case rectangle
}


class Shape: GLProtocol {
    var shaderProgram: GLShader

    var vao: GLuint = 0
    var vertices: [GLfloat] = []
    var indices: [GLuint] = []
    
    var sample: Int!
    var type: FuncType!
    
    var range: GLfloat?

    
    init(){
        shaderProgram = GLShader(vertexFileName: "shape.vsh", fragmentFileName: "shape.fsh")
    }
    

    //circle
    convenience init(radius: GLfloat, center: (GLfloat, GLfloat), sample: Int) {
        self.init()
        self.type = FuncType.circle
        self.sample = sample

        
        //x = r * cos(a)
        //y = r * sin(a)
        for i in 0..<sample {
            
            let x = center.0 + radius * cos(Float(i) * (Float.pi * Float(2) / Float(sample)))
            let y = center.1 + radius * sin(Float(i) * (Float.pi * Float(2) / Float(sample)))
            vertices.append(x)
            vertices.append(y)
            vertices.append(0)
            
            indices.append(GLuint(i))
        }
        
    }
    

    
    //rectangle
    convenience init(width: GLfloat, height: GLfloat) {
        self.init()
        self.type = FuncType.rectangle
        
        self.vertices = [
            width / 2, height / 2, 0.0,
            -width / 2, height / 2, 0.0,
            -width / 2, -height / 2, 0.0,
            width / 2, -height / 2, 0.0
        ]
        
        self.indices = [
            0, 1, 3,
            1, 2, 3
        ]
    }
    
    convenience init(type: FuncType, sample: Int, range: GLfloat) {
        self.init()
        self.sample = sample
        self.type = type
        
        if range <= 0 {
            fatalError("range should be bigger tahn 0")
        } else {
            self.range = range
        }
        
        
        for i in 0...sample {
            var x: GLfloat = 0;
            var y: GLfloat = 0;
            
            switch type {
            case .normalDistribution:
                //y = e^(-x^2) Gaussian
                let space: GLfloat = 2 * range / GLfloat(sample)
                x = -range + GLfloat(i) * space
                y = pow(log(Float(10)), -(x * x))
                break
                
            case .sigmoid:
                //y = 1 / (1+e^(-x)) sigmoid
                let space: GLfloat = 2 * range / GLfloat(sample)
                x = -range + GLfloat(i) * space
                y = 1 / (1 + pow(log(Float(10)), x))
                break
                
            case .spiral:
                //y = e^a 对数螺线
                let space = range / Float(sample)
                let a = Float(i) * space
                let r = pow(log(Float(10)), a) / Float(50)
                x = r * cos(a)
                y = r * sin(a)
                break
                
            default:
                break
            }

            vertices.append(x)
            vertices.append(y)
            vertices.append(0)
            
    
            indices.append(GLuint(i))
        }
        
    }
 
    
    //y = a*sin(3b)
    //@param leafCount: 奇数，叶子为 lefCount 个；偶数，叶子为 2 * leafCount 个
    convenience init(sample: Int, petalRadius: GLfloat, leafCount: GLfloat) {
        self.init()
        self.sample = sample
        self.type = FuncType.rose
        
        for i in 0...sample
        {
            let angle = Float(i) * (Float.pi * 2 / Float(sample))
            let radius = petalRadius * sin(leafCount * angle)
            let x = radius * cos(angle)
            let y = radius * sin(angle)
            vertices.append(x)
            vertices.append(y)
            vertices.append(0)
            indices.append(GLuint(i))
        }
    }
    
    
    func loadShader() {
        shaderProgram.loadShaders()
    }
    
    
    func bindVertexData() {
        glGenVertexArrays(1, &vao)
        glBindVertexArray(vao)
        
        GLBuffer(target: GLenum(GL_ARRAY_BUFFER), type: BufferDataType.glFloat, data: vertices)
        GLBuffer(target: GLenum(GL_ELEMENT_ARRAY_BUFFER), type: BufferDataType.gluint, data:  indices)
        
        //vbo数组的数据如何读
        glVertexAttribPointer(0,
                              GLint(3),
                              GLenum(GL_FLOAT),
                              GLboolean(GL_FALSE),
                              GLsizei(MemoryLayout<GLfloat>.size * 3),
                              UnsafeRawPointer(bitPattern: 0))
        glEnableVertexAttribArray(0)
        
        /* 老版本的shader，获取attribute的location */
        let bb = glGetAttribLocation(shaderProgram.program, "normal")
        print(bb)
        
        //给顶点大小赋值
        glVertexAttrib1f(1, 10)

        glBindVertexArray(0)
        
        
        
    }
    
    
    func draw() {
        shaderProgram.use()
     
        //指明vao，必须有，不然会报内存访问错误
        glBindVertexArray(vao)
        
        glLineWidth(10)
        //glPointSize(10) //has no use
        
        //veo缓存数组的数据如何读
        if self.type == FuncType.circle {
            //line的话，用户只要指明每点的index
            glDrawElements(GLenum(GL_LINE_LOOP), GLsizei(indices.count), GLenum(GL_UNSIGNED_INT), UnsafeRawPointer(bitPattern: 0))
            
        } else if self.type == FuncType.rectangle {
            glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_INT), UnsafeRawPointer(bitPattern: 0))
            
        } else {
            glDrawElements(GLenum(GL_LINE_STRIP), GLsizei(indices.count
            ), GLenum(GL_UNSIGNED_INT), UnsafeRawPointer(bitPattern: 0))
        }
        
        glBindVertexArray(0)
    }
    
    
}
