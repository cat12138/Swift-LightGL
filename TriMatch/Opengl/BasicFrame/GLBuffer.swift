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


enum BufferDataType: Int {
    case glFloat = 0
    case gluint
}

class GLBuffer {
    var target: GLenum
    var type: BufferDataType
    var data: [Any] = []
    var id: GLuint = 0

    
    @discardableResult
    init(target: GLenum, type: BufferDataType, data: [Any]? = nil) {
        self.target = target
        self.type = type
        
        if data != nil {
            self.data = data!
            compile()
        }
        //or let a = GLBuffer
        //a.data =
        //a.compile()
    }
    
    func compile(usage: GLenum? = nil){
        glGenBuffers(1, &id)
        
        glBindBuffer(self.target, id)
        
        switch type {
        case .glFloat:
            let size = MemoryLayout<GLfloat>.size
            glBufferData(self.target, GLsizeiptr(size * data.count), data as! [GLfloat], usage ?? GLenum(GL_STATIC_DRAW))
        case .gluint:
            let size = MemoryLayout<GLuint>.size
            glBufferData(self.target, GLsizeiptr(size * data.count), data as! [GLuint], usage ?? GLenum(GL_STATIC_DRAW))
        }
       
    }
}
