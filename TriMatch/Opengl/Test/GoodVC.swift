//
//  ViewController.swift
//  TriMatch
//
//  Created by sj on 2018/8/30.
//  Copyright © 2018 sj. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES

class GoodVC: GLKViewController {

    var effect: GLKBaseEffect!
    var vao: GLuint = 0
    var vbo: [GLuint] = [GLuint](repeating: 0, count: 4)
    
    
    //data
    let rawV: [[GLfloat]] = [[-0.5, -0.5, 0.0], [0.0, -0.5, 0.0], [0.5, -0.5, 0.0],
                             [-0.5, 0.5, 0.0], [0.0, 0.5, 0.0], [0.5, 0.5, 0.0]]
    let rawL: [[GLuint]] = [[0, 1], [1, 3], [0, 3], [1, 4], [3, 4], [1, 2], [2, 4], [2, 5], [4, 5]]
    let rawT: [[GLuint]] = [[0, 1, 3], [3, 1, 4], [1, 2, 4], [4, 2, 5]]
    let rawC: [[GLfloat]] = [[1, 0, 0], [0, 1, 0], [0, 0, 1],
                             [1, 1, 0], [1, 0, 1], [0, 1, 1]]
    var vertices: [GLfloat] { return rawV.flatMap{ $0 } }
    var lines: [GLuint] { return rawL.flatMap{ $0 }  }
    var triangles: [GLuint] { return rawT.flatMap{ $0 } }
    var colors: [GLfloat] { return rawC.flatMap{ $0 } }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gameView = self.view as! GLKView
        gameView.context = EAGLContext(api: .openGLES3)!
        EAGLContext.setCurrent(gameView.context)
        
        effect = GLKBaseEffect()
        //effect.useConstantColor = GLboolean(GL_TRUE)
        //effect.constantColor = GLKVector4(v: (1, 1, 0, 1))
        
        
        glGenVertexArrays(1, &vao)
        glBindVertexArray(vao)
        
       
        glGenBuffers(4, &vbo)
    
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo[0])
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * vertices.count, vertices, GLenum(GL_STATIC_DRAW))
        
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), vbo[1])
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), MemoryLayout<GLuint>.size * lines.count, lines, GLenum(GL_STATIC_DRAW))
    
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), vbo[2])
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), MemoryLayout<GLuint>.size * triangles.count, triangles, GLenum(GL_STATIC_DRAW))

        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo[3])
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * colors.count, colors, GLenum(GL_STATIC_DRAW))
        
            
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo[0])
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue), 3, GLenum((GL_FLOAT)), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 3), UnsafeRawPointer(bitPattern: 0))
        
    
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo[3])
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.color.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.color.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 3), UnsafeRawPointer(bitPattern: 0))
        
        
        glBindVertexArray(vao)
        
        
    }
    

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        effect.prepareToDraw()
        glClearColor(1, 0, 0, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT))
        
        glBindVertexArray(vao)
        glLineWidth(10)
        
        
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), vbo[1])
        glDrawElements(GLenum(GL_LINES), GLsizei(lines.count), GLenum(GL_UNSIGNED_INT), UnsafeRawPointer(bitPattern: 0))
        
        /*
        glEnableClientState(GLenum(GL_VERTEX_ARRAY))
        glVertexPointer(<#T##size: GLint##GLint#>, <#T##type: GLenum##GLenum#>, <#T##stride: GLsizei##GLsizei#>, <#T##pointer: UnsafeRawPointer!##UnsafeRawPointer!#>)
        */
        
   
        //glDrawElements(GLenum(GL_TRIANGLES), GLsizei(triangles.count), GLenum(GL_UNSIGNED_INT), UnsafeRawPointer(bitPattern: 0))
        
        
        glBindVertexArray(0)
    }

}
