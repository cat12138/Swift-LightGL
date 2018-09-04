//
//  File.swift
//  TriMatch
//
//  Created by sj on 2018/7/5.
//  Copyright © 2018 sj. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit

enum GLError: Error {
    case notSupportES3
}

class GLContext {
    var ctx: EAGLContext?
    
    init() throws {
        ctx = EAGLContext(api: .openGLES3)
        if ctx == nil {
            throw GLError.notSupportES3
        }
        
        checkEnvironment()
    }
    
    func activate(){
        if EAGLContext.current() != ctx {
            EAGLContext.setCurrent(ctx!)
        }
    }
    
    func deactivate() {
        if EAGLContext.current() != nil {
            EAGLContext.setCurrent(nil)
        }
    }
    
    func checkEnvironment(){
        var n: GLint = 0
        glGetIntegerv(GLenum(GL_MAX_VERTEX_ATTRIBS), &n)
        print("max vertex attribs \(n)")
        
        glGetIntegerv(GLenum(GL_MAX_TEXTURE_SIZE), &n)
        print("max texture size \(n)")
        
        glGetIntegerv(GLenum(GL_MAX_TEXTURE_UNITS), &n)
        print("max texture units \(n)")
        
    }
    
   
}
