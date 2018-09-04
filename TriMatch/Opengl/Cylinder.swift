//
//  Mesh.swift
//  TriMatch
//
//  Created by sj on 2018/8/22.
//  Copyright © 2018 sj. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit



class Cylinder: NSObject {
    var division: Int = 6
    var heightDivision: Int = 0
    var height: Int = 2
    var radius: Int = 1
    
    var p: [GLfloat] = []   //position
    var t: [GLfloat] = []   //tangent
    var bt: [GLfloat] = []  //bitangent
    var n: [GLfloat] = []   //normal
    var uv: [GLfloat] = []   //texCoord
    
    
    var vao: GLuint = 0
    var vbo: [GLuint] = [GLuint](repeating: 0, count: 5)
    
    
    override init() {
        let divisionf = Float(division)
        for i in 0...division {
            let r1 = (Float.pi * 2 * Float(i)) / divisionf
            let r2 = r1 + Float.pi / 2
            let c1 = cosf(r1)
            let s1 = sinf(r1)
            let c2 = cosf(r2)
            let s2 = sinf(r2)
            
            let j = i * 6 //pos: 2 vertex 2*(x,y,z)
            let k = i * 4 //uv: 2*(u,v)
            //position
            p[j+0] = c1
            p[j+1] = 1
            p[j+2] = -s1
            p[j+3] = c1
            p[j+4] = 1
            p[j+5] = -s1
            
            //normal
            n[j+0] = c1
            n[j+1] = 0
            n[j+2] = -s1
            n[j+3] = c1
            n[j+4] = 0
            n[j+5] = -s1
            
            //uv
            uv[k+0] = 1
            uv[k+1] = 1
            uv[k+2] = 1
            uv[k+3] = 1
            
            //tangent
            t[j+0] = c2
            t[j+1] = 0
            t[j+2] = s2
            t[j+3] = c2
            t[j+4] = 0
            t[j+5] = s2
            
            //bitangent
            bt[j+0] = 0
            bt[j+1] = 1
            bt[j+2] = 0
            bt[j+3] = 0
            bt[j+4] = 1
            bt[j+5] = 0
            
        }
    }
    
    
    convenience init(division: Int, heightDivision: Int, height: Int, radius: Int) {
        self.init()
        
        self.division = division
        self.heightDivision = heightDivision
        self.height = height
        self.radius = radius
        
        
    }
    
    func loadData() {
        let tmp = division + 1
        let numVertex = tmp * 2
        let size = numVertex * 3
        let tcSize = numVertex * 2
        
        glGenVertexArrays(1, &vao)
        glBindVertexArray(vao)
        
        glGenBuffers(3, &vbo)
        
        //position
        glBindBuffer(GLenum(GL_VERTEX_ARRAY), vbo[0])
        glBufferData(GLenum(GL_VERTEX_ARRAY), MemoryLayout<GLfloat>.size * size, p, GLenum(GL_STATIC_DRAW))
        
        glEnableVertexAttribArray(0)
        glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 3), UnsafeRawPointer(bitPattern: 0))
        
        
        //tangent
        glBindBuffer(GLenum(GL_VERTEX_ARRAY), vbo[1])
        glBufferData(GLenum(GL_VERTEX_ARRAY), MemoryLayout<GLfloat>.size * size, p, GLenum(GL_STATIC_DRAW))
        
        glEnableVertexAttribArray(1)
        glVertexAttribPointer(1, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 3), UnsafeRawPointer(bitPattern: 0))
        
        
        //bitangent
        glBindBuffer(GLenum(GL_VERTEX_ARRAY), vbo[2])
        glBufferData(GLenum(GL_VERTEX_ARRAY), MemoryLayout<GLfloat>.size * size, p, GLenum(GL_STATIC_DRAW))
        
        glEnableVertexAttribArray(2)
        glVertexAttribPointer(2, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 3), UnsafeRawPointer(bitPattern: 0))
        
        
        //normal
        glBindBuffer(GLenum(GL_VERTEX_ARRAY), vbo[3])
        glBufferData(GLenum(GL_VERTEX_ARRAY), MemoryLayout<GLfloat>.size * size, p, GLenum(GL_STATIC_DRAW))
        
        glEnableVertexAttribArray(3)
        glVertexAttribPointer(3, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 3), UnsafeRawPointer(bitPattern: 0))
        
        
        //uv
        glBindBuffer(GLenum(GL_VERTEX_ARRAY), vbo[4])
        glBufferData(GLenum(GL_VERTEX_ARRAY), MemoryLayout<GLfloat>.size * tcSize, p, GLenum(GL_STATIC_DRAW))
        glEnableVertexAttribArray(4)
        glVertexAttribPointer(4, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 2), UnsafeRawPointer(bitPattern: 0))
        
        glBindVertexArray(0)
        
    }
}
