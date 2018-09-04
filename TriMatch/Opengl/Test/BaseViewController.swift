//
// Example 3
// Files: BaseViewController.swift
// Function: Using GLKBaseEffect to render texture






import UIKit
import GLKit
import OpenGLES


class BaseViewController: GLKViewController {

    var vao: GLuint = 0
    var vbo: GLuint = 0
    var effect: GLKBaseEffect!
    var vertices: [GLfloat] = []
    var mode: GLenum!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gameView = self.view as! GLKView
        gameView.context = EAGLContext(api: .openGLES3)!
        EAGLContext.setCurrent(gameView.context)
        gameView.drawableDepthFormat = .format24
        gameView.drawableColorFormat = .RGBA8888
        
        mode = GLenum(GL_TRIANGLE_STRIP)
        
        effect = GLKBaseEffect()
        effect.useConstantColor = GLboolean(GL_TRUE)
        effect.constantColor = GLKVector4(v: (1.0, 1.0, 1.0, 1.0))
        
        
        var rawData: [[[GLfloat]]] = []
        if mode == GLenum(GL_TRIANGLES) {
            rawData = [
                [[-0.5, -0.5, 0.0], [0.0, 0.0], [0.0, 0.0, 1.0]],
                [[0.5, -0.5, 0.0], [1.0, 0.0], [0.0, 0.0, 1.0]],
                [[-0.5, 0.5, 0.0], [0.0, 1.0], [0.0, 0.0, 1.0]],
                
                [[0.5, -0.5, 0.0], [1.0, 0.0], [0.0, 0.0, 1.0]],
                [[0.5, 0.5, 0.0], [1.0, 1.0], [0.0, -0.0, 1.0]],
                [[-0.5, 0.5, 0.0], [0.0, 1.0], [0.0, 0.0, 1.0]]
            ]
            
        } else if mode == GLenum(GL_TRIANGLE_STRIP) {
            rawData = [
            [[-0.5, -0.5, 0.0], [0.0, 0.0], [0.0, 0.0, 1.0]],
            [[0.5, -0.5, 0.0], [1.0, 0.0], [0.0, 0.0, 1.0]],
            [[-0.5, 0.5, 0.0], [0.0, 1.0], [0.0, 0.0, 1.0]],
            [[0.5, 0.5, 0.0], [1.0, 1.0], [0.0, -0.0, 1.0]]
            ]

        }
        vertices = rawData.flatMap { $0.flatMap { $0 } }
   
        print(vertices)
        
        //纹理
        let file = Bundle.main.url(forResource: "texture", withExtension: "jpg")
        let info: GLKTextureInfo = try! GLKTextureLoader.texture(withContentsOf: file!, options: nil)
        effect.texture2d0.name = info.name
        effect.texture2d0.target = GLKTextureTarget(rawValue: info.target)!
        
        //漫反射
        /*
        effect.light0.enabled = GLboolean(GL_TRUE)
        effect.light0.diffuseColor = GLKVector4(v: (1.0, 0.0, 0.0, 1.0))
        effect.light0.position = GLKVector4(v: (0.0, 0.0, 1.0, 1.0)) 
        effect.light0.constantAttenuation = 0.02
 */
        
        //顶点缓存区
        glGenBuffers(1, &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(MemoryLayout<GLfloat>.size * vertices.count), vertices, GLenum(GL_STATIC_DRAW))
        
        
        //启动顶点属性
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue));
        glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue),
                              3,
                              GLenum(GL_FLOAT),
                              GLboolean(GL_FALSE),
                              GLsizei(MemoryLayout<GLfloat>.size * 8),
                              UnsafeRawPointer(bitPattern: 0) )
    
        //启动纹理属性
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.texCoord0.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.texCoord0.rawValue),
                              2,
                              GLenum(GL_FLOAT),
                              GLboolean(GL_FALSE),
                              GLsizei(MemoryLayout<GLfloat>.size * 8),
                              UnsafeRawPointer(bitPattern: 3 * MemoryLayout<GLfloat>.size));
        /* get tex attrib */
        var texResult: GLfloat = 0
        
        glGetVertexAttribfv(GLuint(GLKVertexAttrib.texCoord0.rawValue), GLenum(GL_VERTEX_ATTRIB_ARRAY_ENABLED), &texResult)
        print("enabled", texResult)
        
        glGetVertexAttribfv(GLuint(GLKVertexAttrib.texCoord0.rawValue), GLenum(GL_VERTEX_ATTRIB_ARRAY_STRIDE), &texResult)
        print("stride", texResult)
        
        glGetVertexAttribfv(GLuint(GLKVertexAttrib.texCoord0.rawValue), GLenum(GL_VERTEX_ATTRIB_ARRAY_SIZE), &texResult)
        print("size", texResult)

        glGetVertexAttribfv(GLuint(GLKVertexAttrib.texCoord0.rawValue), GLenum(GL_CURRENT_VERTEX_ATTRIB), &texResult)
        print("current", texResult)
        
        glGetVertexAttribfv(GLuint(GLKVertexAttrib.texCoord0.rawValue), GLenum(GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING), &texResult)
        print("buffer_binding", texResult)
        
        glGetVertexAttribfv(GLuint(GLKVertexAttrib.texCoord0.rawValue), GLenum(GL_VERTEX_ATTRIB_ARRAY_TYPE), &texResult)
        print("type", texResult)

        glGetVertexAttribfv(GLuint(GLKVertexAttrib.texCoord0.rawValue), GLenum(GL_VERTEX_ATTRIB_ARRAY_NORMALIZED), &texResult)
        print("normalized", texResult)
        
        glGetVertexAttribfv(GLuint(GLKVertexAttrib.texCoord0.rawValue), GLenum(GL_VERTEX_ATTRIB_ARRAY_DIVISOR), &texResult)
        print("divisor", texResult)
        
        glGetVertexAttribfv(GLuint(GLKVertexAttrib.texCoord0.rawValue), GLenum(GL_VERTEX_ATTRIB_ARRAY_INTEGER), &texResult)
        print("integer", texResult)
        
        
        //启动法向量
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.normal.rawValue));
        glVertexAttribPointer(GLuint(GLKVertexAttrib.normal.rawValue),
                              3,
                              GLenum(GL_FLOAT),
                              GLboolean(GL_FALSE),
                              GLsizei(MemoryLayout<GLfloat>.size * 8),
                              UnsafeRawPointer(bitPattern: 5 * MemoryLayout<GLfloat>.size));
 

    }
    
    

    func unitNormal(v1: GLKVector3, v2: GLKVector3) -> GLKVector3 {
        return GLKVector3Normalize(GLKVector3CrossProduct(v1, v2))
    }
    
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(1.0, 1.0, 0.0, 1.0)
        glClearStencil(0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT))
        
        effect.prepareToDraw()
    
        if mode == GLenum(GL_TRIANGLES) {
            glDrawArrays(GLenum(GL_TRIANGLES), 0, 6)
            
        } else if mode == GLenum(GL_TRIANGLE_STRIP ){
            glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
        }
    
 
    }
}
