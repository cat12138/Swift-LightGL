//
//  Test.swift
//  TriMatch
//
//  Created by sj on 2018/8/18.
//  Copyright © 2018 sj. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES



class Test: GLKView {

    //framebuffer
    var fbo: GLuint = 0
    var colorRenderBuffer: GLuint = 0
    var depthRenderBuffer: GLuint = 0
    var stencilRenderBuffer: GLuint = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let effect =  GLKBaseEffect()
        effect.useConstantColor = GLboolean(GL_FALSE)
        
        glEnable(GLenum(GL_DEPTH_TEST))
        glEnable(GLenum(GL_ALPHA_TEST))
        glEnable(GLenum(GL_STENCIL_TEST))
        
        /* Stencil Buffer */
        glStencilMask(0xFF)
        //@param func
        //GL_NEVER
        //GL_ALWAYS
        //GL_LESS
        //GL_LEQUAL
        //GL_EQUAL
        //GL_GEQUAL
        //GL_GREATER
        //GL_NOTEQUAL
        //glStencilFunc(GLenum(GL_NEVER), <#T##ref: GLint##GLint#>, <#T##mask: GLuint##GLuint#>)
        
        //@param fail 未通过处理
        //@param zfail 模版通过，深度未通过处理
        //@param zpass 模版深度都通过处理
        //GL_KEEP
        //GL_ZERO
        //GL_REPLACE 使用测试条件中的设定值来代替当前模板值
        //GL_INCR
        //GL_INCR_WRAP
        //GL_DECR 减少1，但如果已经是零，则保持不变
        //GL_DECR_WRAP 减少1，但如果已经是零，则重新设置为最大值
        //GL_INVERT 按位取反
       // glStencilOp(<#T##fail: GLenum##GLenum#>, <#T##zfail: GLenum##GLenum#>, <#T##zpass: GLenum##GLenum#>)
        
        
        var n: GLint = 0
        glGetIntegerv(GLenum(GL_MAX_RENDERBUFFER_SIZE), &n)
        print("MAX_RENDERBUFFER_SIZE", n)
        glGetIntegerv(GLenum(GL_MAX_COLOR_ATTACHMENTS), &n)
        print("MAX_COLOR_ATTACHMENS", n)
        
        
        self.context = EAGLContext(api: .openGLES2)!
        EAGLContext.setCurrent(self.context)
    
        
        glGenFramebuffers(1, &fbo)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), fbo)
        
        //颜色缓冲区
        //调用context的renderbufferStorage:fromDrawable:方法并传递层对象作为参数来分配其存储空间
        //宽度，高度和像素格式取自层,用于为renderbuffer分配存储空间
        glGenRenderbuffers(1, &colorRenderBuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderBuffer)
        glRenderbufferStorageOES(GLenum(GL_RENDERBUFFER), GLenum(GL_RGBA), 200, 200)
        //@param 彩色渲染（GL_RGB，GL_RGBA等），深度可渲染（GL_DEPTH_COMPONENT）或模板可渲染格式（GL_STENCIL_INDEX）
        //@param witdh/height 应小于GL_MAX_RENDERBUFFER_SIZE，否则会生成GL_INVALID_VALUE错误。
        
        //深度缓冲区
        glGenRenderbuffers(1, &depthRenderBuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), depthRenderBuffer)
        glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_DEPTH_COMPONENT), 200, 200)
        
        //模版缓冲区
        //为屏幕上的每个像素点保存一个无符号整数值。
        //这个值的具体意义视程序的具体应用而定。在渲染的过程中，可以用这个值与一个预先设定的参考值相比较，根据比较的结果来决定是否更新相应的像素点的颜色值。这个比较的过程被称为模板测试。
        //透明度测试（alpha test)->模版测试->深度测试（depth test)。
        //当启动模板测试时，通过模板测试的片段像素点会被替换到颜色缓冲区中，从而显示出来，未通过的则不会保存到颜色缓冲区中
        glGenRenderbuffers(1, &stencilRenderBuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), stencilRenderBuffer)
        /*
        glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_STencil_Co), <#T##width: GLsizei##GLsizei#>, <#T##height: GLsizei##GLsizei#>)
 */
        
        //把图像绑到fbo
        //@param 2th 连接点。GL_COLOR_ATTACHMENT0-15，GL_DEPTH_ATTACHMENT和GL_STENCIL_ATTACHMENT
        //fbo可附加2种图像; 纹理图像（渲染到纹理）和renderbuffer图像（屏幕外渲染）
        //fbo至少有1个颜色连接点
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), colorRenderBuffer)
        
        var width: GLint = 0
        var height: GLint = 0
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_WIDTH), &width)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_HEIGHT), &height)
        print(width, height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        glClearColor(1, 0, 0, 1)
        
        print("hellllo")
    }
    


    
    
}
