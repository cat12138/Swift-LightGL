//
// Example 4
// Files: Rect.swift / Rect.vsh / Rect.fsh
// Single glkView that can be aatached anywhere


import Foundation
import OpenGLES
import GLKit


class Rect: GLKView {
    
    var program: GLuint = GLuint()
    var vao: GLuint = GLuint()
    var vbo: [GLuint] = [GLuint](repeating: 0, count: 4)
    
    let vertices: [GLfloat] = [
        -0.5, -0.5,
        0.5, -0.5,
        0.5, 0.5,
        -0.5, 0.5
    ]
    let colors: [GLfloat] = [
        1, 0, 0, 1,
        0, 1, 0, 1,
        0, 0, 1, 1,
        0, 0, 0, 1
    ]
    let uvs: [GLfloat] = [
        0, 0,
        1, 0,
        1, 1,
        0, 1
    ]
    let indices: [GLubyte] = [0, 1, 2, 0, 2, 3]

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContext()
        setupShader(vs: "rect.vsh", fs: "rect.fsh")
        setupData()
        setupTexture(fileName: "result.jpg")
        setupDisplay()
        

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        EAGLContext.setCurrent(nil)
    }
    
    
    func setupContext() {
        context = EAGLContext(api: .openGLES3)!
        EAGLContext.setCurrent(context)
    }
    

    func setupShader(vs: String, fs: String) {
        //1
        program = glCreateProgram()
        
        //2
        let _vs = compileShader(src: vs, type: GLenum(GL_VERTEX_SHADER))
        if let vertexShader = _vs {
            glAttachShader(program, vertexShader)
            glDeleteShader(vertexShader)
        }
        
        let _fs = compileShader(src: fs, type: GLenum(GL_FRAGMENT_SHADER))
        if let fragmentShader = _fs {
            glAttachShader(program, fragmentShader)
            glDeleteShader(fragmentShader)
        }
        
        //3
        glLinkProgram(program)
        
        var status: GLint = 0
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &status)
        if status == GL_FALSE {
            print("program link error\n")
            
            var logLen: GLint = 0
            glGetProgramiv(program, GLenum(GL_INFO_LOG_LENGTH), &logLen)
            if logLen > 0 {
                var logChar: [GLchar] = [GLchar](repeating: 0, count: Int(logLen))
                glGetProgramInfoLog(program, logLen, &logLen, &logChar)
                let logStr = String(cString: logChar)
                print(logStr)
            }
           
            glDeleteProgram(program)
            return
        }
        
        //4
        useProgram()
    }
    
    
    func setupData() {
        
        glGenVertexArrays(1, &vao)
        glBindVertexArray(vao)
        
        glGenBuffers(GLsizei(vbo.count), &vbo)
        
        //pos
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo[0])
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * vertices.count, vertices, GLenum(GL_STATIC_DRAW))
        
        glEnableVertexAttribArray(0)
        glVertexAttribPointer(0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 2), UnsafeRawPointer(bitPattern: 0))
        
        
        //colors
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo[1])
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * colors.count, colors, GLenum(GL_STATIC_DRAW))
        
        glEnableVertexAttribArray(1)
        glVertexAttribPointer(1, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 4), UnsafeRawPointer(bitPattern: 0))
        
        
        //uv
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo[2])
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * uvs.count, uvs, GLenum(GL_STATIC_DRAW))
        
        glEnableVertexAttribArray(2)
        glVertexAttribPointer(2, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 2), UnsafeRawPointer(bitPattern: 0))
        
    
        //indices
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), vbo[3])
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), MemoryLayout<GLubyte>.size * indices.count, indices, GLenum(GL_STATIC_DRAW))
        
   
        glBindVertexArray(0)
        
    }
    
  
    func setupTexture(fileName: String) {
        //cgImage得到二进制数据
        let imgPath = Bundle.main.resourcePath! + "/" + fileName
        let _cgImg: CGImage? = UIImage(named: imgPath)?.cgImage
        if let cgImg = _cgImg {
            let width = cgImg.width
            let height = cgImg.height
            let size = width * height * 4
            
            let spriteData = UnsafeMutablePointer<GLubyte>.allocate(capacity: size)
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            let spriteContext: CGContext = CGContext(data: spriteData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: cgImg.colorSpace!, bitmapInfo: bitmapInfo.rawValue)!
            spriteContext.draw(cgImg, in: CGRect(x: 0, y: 0, width: width, height: height))
            
            
            glEnable(GLenum(GL_TEXTURE_2D))
            glActiveTexture(GLenum(GL_TEXTURE0))
            var textureId: GLuint = 0
            glGenTextures(1, &textureId)
            glBindTexture(GLenum(GL_TEXTURE_2D), textureId)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_R), GLint(GL_CLAMP_TO_EDGE))
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GLint(GL_CLAMP_TO_EDGE))
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GLint(GL_LINEAR))
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GLint(GL_LINEAR))
            glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), spriteData)
            
            free(spriteData)
            
            
      
            //打开showTex开关
            let _showTex = getUniformLocation(name: "showTex")
            if let showTex = _showTex {
                print(showTex)
                glUniform1f(showTex, 1)
            
                var value: GLfloat = 0
                glGetUniformfv(program, showTex, &value)
                print("showTex", value)
            }
            
            
            
        
        } else {
            print("load texture \(fileName) failed \n")
        }
        
        
        
    }
    
    
    //MARK: draw
    func setupDisplay() {
        let display = CADisplayLink(target: self, selector: #selector(render))
        display.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
    }
    
    
    @objc func render() {
        //remove these 2, you'll get flash
        glClearColor(1, 0, 0, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))

        
        /* doesn't matter */
        var width: GLint = 0
        var height: GLint = 0
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_WIDTH), &width)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_HEIGHT), &height)
        glViewport(0, 0, width, height)
        
        
        glBindVertexArray(vao)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_BYTE), UnsafeRawPointer(bitPattern: 0))
        //glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, GLsizei(vertices.count))
        self.context.presentRenderbuffer(Int(GL_RENDERBUFFER))
        glBindVertexArray(0)
 
    }
    
    //第1帧
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        glClearColor(1, 0, 0, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        //画图放在这里
        glBindVertexArray(vao)
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_BYTE), UnsafeRawPointer(bitPattern: 0))
        context.presentRenderbuffer(Int(GL_RENDERBUFFER))
        glBindVertexArray(0)
    }
    
    
    //MARK: private funcs
    fileprivate func isFile(src: String) -> Bool {
        let reg = try! NSRegularExpression(pattern: "(\\.vsh$|\\.fsh$|\\.glsl$)", options: .caseInsensitive)
        let matches = reg.matches(in: src, options:NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, src.count))
        if matches.count > 0 {
            print("is File")
            return true
        } else {
            return false
        }
    }
    
    
    fileprivate func readFile(fileName: String) -> String? {
        if !isFile(src: fileName) {
            return nil
        }

        let filePath = Bundle.main.resourcePath! + "/" + fileName
        var fileContent: String
        do {
            fileContent = try String(contentsOfFile: filePath)
            return fileContent
        } catch {
            print(errno)
        }
 
        return nil
    }
    
    
    fileprivate func compileShader(src: String, type: GLenum) -> GLuint? {
    
        let shader = glCreateShader(type)
        
        var rawSrc: UnsafePointer<Int8>?
        if let content = readFile(fileName: src) {
            rawSrc = NSString(string: content).utf8String
        } else {
            rawSrc = NSString(string: src).utf8String
        }
  
        glShaderSource(shader, 1, &rawSrc, nil)
        glCompileShader(shader)
        
        var status: GLint = 0
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        if status == GL_FALSE {
            var logLen: GLint = 0
            glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logLen)
            if logLen > 0{
                let logChar: UnsafeMutablePointer<GLchar> = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLen))
                logChar.initialize(to: 0)
                glGetShaderInfoLog(shader, logLen, &logLen, logChar)
                let logStr = String(cString: logChar)
                let typeString = (type == GL_VERTEX_SHADER) ? "vertex" : "fragment"
                print("\(typeString)", logStr)
            }
            glDeleteShader(shader)
            return nil
        }
        return shader
    }
    
    
    fileprivate func useProgram() {
        if program != 0 {
            glUseProgram(program)
            print("program \(program) is used\n")
        }
    }

    
    fileprivate func getAttribLocation(name: String) -> GLuint? {
        let t = glGetAttribLocation(program, name.cString(using: String.Encoding.utf8))
        print(name, t)
        return t == -1 ? nil : GLuint(t)
    }

    
    fileprivate func getUniformLocation(name: String) -> GLint? {
        let t = glGetUniformLocation(program, name.cString(using: String.Encoding.utf8))
        print(name, t)
        return t == -1 ? nil : t
    }
}


