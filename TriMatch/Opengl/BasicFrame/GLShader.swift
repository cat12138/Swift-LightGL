//
//  GLProgram.swift
//  TriMatch
//
//  Created by sj on 2018/7/5.
//  Copyright © 2018 sj. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES


class GLShader {
    var program: GLuint = 0
    var vertexFile: String
    var fragmentFile: String
    var vertexShader: GLuint = 0
    var fragmentShader: GLuint = 0
    
    
    //@param fileName: 1）着色器文件，支持.vsh, .fsh, .glsl；2）着色器代码(有问题）
    init(vertexFileName: String, fragmentFileName: String) {
        self.vertexFile = vertexFileName
        self.fragmentFile = fragmentFileName
    }
    
    
    
    //MARK: program
    func use(){
        if program != 0 {
            glUseProgram(program)
        }
    }
    
    func validate() -> Bool {
        if program != 0 {
            glValidateProgram(program)
            
            var status: GLint = 0
            glGetProgramiv(program, GLenum(GL_VALIDATE_STATUS), &status)
            if status == 0 {
                outputProgramError()
                return false
            } else {
                return true
            }
        } else {
            print("[Error]: have no program \n")
            return false
        }
    }
    
    fileprivate func link() -> Bool {
        program = glCreateProgram()
        glAttachShader(program, vertexShader)
        glAttachShader(program, fragmentShader)
        glLinkProgram(program)
        
        var status: GLint = 0
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &status)
        if status == 0 {
            outputProgramError()
            glDeleteProgram(program)
            return false
        }
        return true
    }
    
    fileprivate func outputProgramError(){
        var logLen: GLint = 0
        glGetProgramiv(program, GLenum(GL_INFO_LOG_LENGTH), &logLen)
        if logLen > 0 {
            var log: [GLchar] = [GLchar](repeating: 0, count: Int(logLen))
            glGetProgramInfoLog(program, GLsizei(logLen), &logLen, &log)
            let logString = String(cString: &log, encoding: String.Encoding.utf8)
            print("[Program Error]: %s \n", logString ?? "[Program Error]: no]")
        }
    }
    
    func getAttribLocation(name: String)  -> GLuint? {
        let t = glGetAttribLocation(program, name.cString(using: String.Encoding.utf8))
        return t == -1 ? nil : GLuint(t)
    }
    
    func getUniformLocation(name :String) -> GLint? {
        let t = glGetUniformLocation(program, name.cString(using: String.Encoding.utf8))
        return t == -1 ? nil : t
    }
    
    
    
    //MARK: shader
    func compileShaders() -> Bool {
        if !compileShader(shader: &vertexShader, type: GLenum(GL_VERTEX_SHADER), shaderFile: vertexFile) {
            return false
        }
        if !compileShader(shader: &fragmentShader, type: GLenum(GL_FRAGMENT_SHADER), shaderFile: fragmentFile) {
            return false
        }
        return true
    }
    
    
    
    func compileShader(shader: inout GLuint, type: GLenum, shaderFile: String) -> Bool {
        shader = glCreateShader(type)
        
        //工作1: 判断是文件还是代码
        //工作2: 修正着色器，加入预设量
        var rawSrc: UnsafePointer<Int8>?
        var fixedSrc: String
        if let content = readFile(fileName: shaderFile) {
            fixedSrc = fix(type: type, shaderSource: content)
        } else {
            fixedSrc = fix(type: type, shaderSource: shaderFile)
        }
        rawSrc = NSString(string: fixedSrc).utf8String

        
        glShaderSource(shader, 1, &rawSrc, nil)
        glCompileShader(shader)
        
        var status: GLint = 0
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        if status == 0 {
            outputShaderError(shader: shader, type: type)
            glDeleteShader(shader)
            return false
        }
        
        return true
    }
    
    
    fileprivate func outputShaderError(shader: GLuint, type: GLenum){
        var logLen: GLint = 0
        glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logLen)
        if logLen > 0 {
            let log: UnsafeMutablePointer<GLchar> = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLen))
            log.initialize(to: 0)
            glGetShaderInfoLog(shader, logLen, &logLen, log)
            
            let logString = String(cString: log, encoding: String.Encoding.utf8)
            let typeString = (type == GL_VERTEX_SHADER) ? "vertex" : "fragment"
            print("[\(typeString) Shader Error]: \(logString) \n")
            
            log.deinitialize(count: Int(logLen))
            log.deallocate()
        }
    }
    
    
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
    
    
    fileprivate func fix(type: GLenum, shaderSource: String ) -> String {
        var rawTotal: String = shaderSource
       
        
        do {
            var matchString: String = ""    //匹配到
            var remainString: String = ""   //剩下的
            
            //匹配#version实现
            //匹配注释（单行和多行）
            let reg = try NSRegularExpression(pattern: "(\\s#version.*\\n)+", options: .caseInsensitive)
            let matches = reg.matches(in: shaderSource, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, shaderSource.count))
            for m in matches {
                let regString = (shaderSource as NSString).substring(with: m.range)
                matchString += regString
                remainString = (shaderSource as NSString).replacingCharacters(in: m.range, with: "")
            }
            
            if type == GLenum(GL_VERTEX_SHADER ) {
                rawTotal = matchString + vertexHeader + remainString
            } else {
                rawTotal = matchString + fragmentHeader + remainString
            }
            
        } catch {
            print(error)
        }
        
        
        
        return rawTotal
       
    }
    
    
    //final
    @discardableResult
    func loadShaders() -> Bool {
        if !compileShaders() {
            return false
        }
        if !link() {
            return false
        }
        return true
    }
    
    
    
    

    
    // Headers are prepended to the sources to provide some automatic functionality.
    var header: String = "precision highp float; \n" +
    "uniform mat3 d_NormalMatrix; \n" +
    "uniform mat4 d_ModelViewMatrix; \n" +
    "uniform mat4 d_ProjectionMatrix; \n" +
    "uniform mat4 d_ModelViewProjectionMatrix; \n" +
    "uniform mat4 d_ModelViewMatrixInverse; \n" +
    "uniform mat4 d_ProjectionMatrixInverse; \n" +
    "uniform mat4 d_ModelViewProectionMatrixInverse; \n"
    
    
    var vertexHeader: String { return self.header +
    "layout (location = 0) in vec3 d_Vertex; \n" +
    "layout (location = 1) in vec3 d_Tangent; \n" +
    "layout (location = 2) in vec3 d_Bitangent; \n" +
    "layout (location = 3) in vec3 d_Normal; \n" +
    "layout (location = 4) in vec2 d_TexCoord; \n" +
    "out vec2 v_TexCoord; \n" +
    "layout (location = 5) in vec3 d_Color; \n" +
    "out vec3 v_Color; \n"
    }

    var fragmentHeader: String { return self.header +
        "in vec3 v_TexCoord; \n" +
        "out vec3 f_TexCoord; \n" +
        "in vec3 v_Color; \n" +
        "out vec4 f_Color; \n"
    }
    
    
    
}
