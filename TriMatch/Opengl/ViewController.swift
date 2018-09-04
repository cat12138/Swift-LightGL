//
//  ViewController.swift
//  TriMatch
//
//  Created by sj on 2018/8/18.
//  Copyright © 2018 sj. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES

class ViewController: GLKViewController {

    var effect: GLKBaseEffect!
    var stencilVertices: [GLfloat] = []
    var stencilIndices: [GLuint] = []
    var drawVertices: [GLfloat] = []
    var drawIndices: [GLuint] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        
        let gameView = self.view as! GLKView
        gameView.context = EAGLContext(api: .openGLES2)!
        EAGLContext.setCurrent(gameView.context)
        
        
        
        
        
        glMatrixMode(GLenum(GL_MODELVIEW));
        glLoadIdentity();
        
        glEnable(GLenum(GL_STENCIL_TEST));
        glStencilFunc(GLenum(GL_NEVER), 0x0, 0x0);
        glStencilOp(GLenum(GL_INCR), GLenum(GL_INCR), GLenum(GL_INCR));
    
        
        effect = GLKBaseEffect()
        effect.constantColor = GLKVector4(v: (1.0, 1.0, 1.0, 1.0))
        effect.useConstantColor = GLboolean(GL_TRUE)
        
        var dRaidus: GLfloat = 1.0
        //在模板缓冲区绘制(因为模板测试失败不能在颜色缓冲区写入)
        var i: GLuint = 0
        for angle in stride(from: 0.0, to: 400.0, by: 0.1) {
            stencilVertices.append(dRaidus * Float(cos(angle)))
            stencilVertices.append(dRaidus * Float(sin(angle)))
           stencilVertices.append(0)
            dRaidus += 1.002
            
            stencilIndices.append(i)
            i+=1
        }
        
       
   
        
        //现在与颜色缓冲区在模板缓冲区对应处有线的地方不会绘制
        glStencilFunc(GLenum(GL_NOTEQUAL), 0x1, 0x1);
        glStencilOp(GLenum(GL_KEEP), GLenum(GL_KEEP), GLenum(GL_KEEP));
        
        effect.constantColor = GLKVector4(v: (0.0, 1.0, 1.0, 1.0))

        

    }
    

    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(1, 0, 0, 1)
        glClearStencil(0);
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
 
        
        effect.prepareToDraw()
        glDrawElements(GLenum(GL_LINE_STRIP), GLsizei(stencilIndices.count), GLenum(GL_UNSIGNED_INT), stencilIndices)
    }
}
