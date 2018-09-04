//
// Example 2
// Files: RoundPoint.swift
// Single UIView draw Opengl content: a point
// Swift Version
// Author: Shark
// github: muerbingsha


import Foundation
import OpenGLES
import GLKit


class RoundPoint: UIView {
    var glLayer: CAEAGLLayer!
    var context: EAGLContext!
    var fbo: GLuint = 0
    var rbo: GLuint = 0
    var vao: GLuint = 0
    var vbo: [GLuint] = [GLuint](repeating: 0, count: 3)
    var program: GLuint = 0
    
    
    
    override class var layerClass : AnyClass {
        return CAEAGLLayer.self
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createCanvas()
        loadShader()
        loadData()
        setDisplay()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func createCanvas() {
        //context
        context = EAGLContext(api: .openGLES2)!
        EAGLContext.setCurrent(context)
        
        //layer
        glLayer = self.layer as! CAEAGLLayer
        glLayer.contentsScale = UIScreen.main.scale
        glLayer.isOpaque = true
        
        //rbo
        glGenRenderbuffers(1, &rbo)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), rbo)
        context.renderbufferStorage(Int(GL_RENDERBUFFER), from: glLayer)
        
        //fbo
        glGenFramebuffers(1, &fbo)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), fbo)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), rbo)
     
        let status = glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER))
        if status == GLenum(GL_FRAMEBUFFER_COMPLETE) {
            print("frameBuffer complete\n")
        }
        
        glClearColor(1, 1, 1, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        //viewport
        var width: GLint = 0
        var height: GLint = 0
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_WIDTH), &width)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_HEIGHT), &height)
        glViewport(0, 0, width, height)
    
    }
  
    
    func loadShader() {
        //shader
        let vs = "#version 100 \n" +
            "attribute vec2 position; " +
            "attribute float point_size; " +
            "attribute vec4 color;" +
            "varying vec4 fragColor;" +
            "void main() { " +
            "gl_Position = vec4(position, 0, 1); " +
            "gl_PointSize = point_size;" +
            "fragColor = color;" +
            //"gl_PointSize = sin(u_time) * 30.0 + 30;" +
            "}"
        
        let fs = "#version 100 \n" +
            "precision highp float; " +
            "varying vec4 fragColor; " +
            "uniform vec4 backColor;" +
            "void main() { " +
            "if (length(gl_PointCoord - vec2(0.5)) > 0.5) {" +
            "discard;" +
            "} else {" +
            "gl_FragColor = fragColor;" +
            //"gl_FragColor = fragColor;" +
            "}}"
        
        createProgram(vs: vs, fs: fs)
    }
    
    
    var red: GLfloat = 0
    var green: GLfloat = 0
    var blue: GLfloat = 0
    func loadData() {
        //注：和Objective-C版的区别在于：要有buffer放顶点数据
        
        //data
        let vertices: [GLfloat] = [0.0, 0.0]
        let colors: [GLfloat] = [red, green, blue, red]
        let pointSize: [GLfloat] = [100.0]
            
        glGenVertexArrays(1, &vao)
        glBindVertexArray(vao)
        
        //vbos
        glGenBuffers(3, &vbo)
        
        //pos
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo[0])
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * vertices.count, vertices, GLenum(GL_STATIC_DRAW))
        
        let _pos = getAttribLocation(name: "position")
        if let positonSlot = _pos {
            glEnableVertexAttribArray(positonSlot)
            glVertexAttribPointer(positonSlot, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 2), UnsafeRawPointer(bitPattern: 0))
        }
    
        //color
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo[1])
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * colors.count, colors, GLenum(GL_STATIC_DRAW))
        
        let _color = getAttribLocation(name: "color")
        if let colorSlot = _color {
            glEnableVertexAttribArray(colorSlot)
            glVertexAttribPointer(colorSlot, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 4), UnsafeRawPointer(bitPattern: 0))
        }
        
        //point_size
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo[2])
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * pointSize.count, pointSize, GLenum(GL_STATIC_DRAW))
        
        let _size = getAttribLocation(name: "point_size")
        if let sizeSlot = _size {
            glEnableVertexAttribArray(sizeSlot)
            glVertexAttribPointer(sizeSlot, 1, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size), UnsafeRawPointer(bitPattern: 0))
        }
        
        //画圆， 配合fragment着色器中
        //if (length(gl_PointCoord - vec2(0.5, 0.5)) > 0.5 ) { discard; }
        //else { gl_FragColor = fragColor; }
        glEnable(GLenum(GL_POINT_SMOOTH))
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        
        glDrawArrays(GLenum(GL_POINTS), 0, 1)
        context.presentRenderbuffer(Int(GL_RENDERBUFFER))//展示图形，所以放在draw后面
        glBindVertexArray(0)
    }



    //MAKR: opengl framework
    fileprivate func createProgram(vs: String, fs: String){
        program = glCreateProgram()
    
        let _vsShader = createShader(src: vs, type: GLenum(GL_VERTEX_SHADER))
        let _fsShader = createShader(src: fs, type: GLenum(GL_FRAGMENT_SHADER))
        if let vsShader = _vsShader {
            glAttachShader(program, vsShader)
            glDeleteShader(vsShader)
        }
        if let fsShader = _fsShader {
            glAttachShader(program, fsShader)
            glDeleteShader(fsShader)
        }
        
        glLinkProgram(program)
        
        var status: GLint = 0
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &status)
        if status == GL_FALSE {
            print("link program error\n")
            var logLen: GLint = 0
            glGetProgramiv(program, GLenum(GL_INFO_LOG_LENGTH), &logLen)
            if logLen > 0 {
                let logChar: UnsafeMutablePointer<GLchar> = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLen))
                logChar.initialize(to: 0)
                glGetProgramInfoLog(program, logLen, &logLen, logChar)
                _ = String(cString: logChar)
                logChar.deinitialize(count: Int(logLen))
                logChar.deallocate()
            }
            glDeleteProgram(program)
            return
        }
        
        glUseProgram(program)
        
    }
    
    
    fileprivate func createShader(src: String, type: GLenum) -> GLuint? {
        let shader = glCreateShader(type)
        var srcUtf = NSString(string: src).utf8String
        glShaderSource(shader, 1, &srcUtf, nil)
        glCompileShader(shader)
        
        var status: GLint = 0
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        if status == GL_FALSE {
            let typeString = (type == GL_VERTEX_SHADER) ? "vertex" : "fragment"
            print("\(typeString) shader compile error \n")
            var logLen: GLint = 0
            glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logLen)
            if logLen > 0{
                var logChar = [GLchar](repeating: 0, count: Int(logLen))
                glGetShaderInfoLog(shader, logLen, &logLen, &logChar)
                let logString = String(cString: logChar)
                print("shader compile errro: \(logString)")
                glDeleteShader(shader)
            }
            return nil
        }
        return shader
    }
    
    
    fileprivate func getAttribLocation(name: String) -> GLuint? {
        let t = glGetAttribLocation(program, name.cString(using: String.Encoding.utf8))
        return t == -1 ? nil : GLuint(t)
    }
    
    
    fileprivate func getUniformLocation(name: String) -> GLuint? {
        let t = glGetUniformLocation(program, name.cString(using: String.Encoding.utf8))
        return t == -1 ? nil : GLuint(t)
    }
    
    //MARK: render loop
    func setDisplay() {
        let display = CADisplayLink(target: self, selector: #selector(self.render))
        display.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
    }
    
    
    @objc func render() {
        //print("render in good\n")
        
        //更新颜色
        
        //y = r * cos(a)
        let t = CFAbsoluteTimeGetCurrent()
        red = GLfloat(cos(t) / 2 + 0.5)
        green = GLfloat(sin(t) / 2 + 0.5)
        blue = red * green
        
        glBindVertexArray(vao) //指明vbo
        
        let colors: [GLfloat] = [red, green, blue, red]
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo[1]) //指明buffer
        glBufferSubData(GLenum(GL_ARRAY_BUFFER), 0, MemoryLayout<GLfloat>.size * 4, colors) //更新buffer数据
       
        glDrawArrays(GLenum(GL_POINTS), 0, 1)
        context.presentRenderbuffer(Int(GL_RENDERBUFFER))//展示图形，所以放在draw后面
        glBindVertexArray(0)
 
    }
    
    
    deinit {
        if fbo != 0 {
            glDeleteFramebuffers(1, &fbo)
            fbo = 0
        }
        if rbo != 0 {
            glDeleteRenderbuffers(1, &rbo)
            rbo = 0
        }
        if context != nil {
            EAGLContext.setCurrent(nil)
        }
    }
}




