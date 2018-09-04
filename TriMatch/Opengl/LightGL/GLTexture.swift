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

class GLTexture {
    static var canUseFloatingPointTextures: Bool = false
    static var canUseFloatingPointLinearFiltering: Bool = false
    static var canUseHalfFloatingPointTextures: Bool = false
    static var canUseHalfFloatingPointLinearFiltering: Bool = false
    
    
    var width: Int = 0
    var height: Int = 0
    var id: GLuint = GLuint()
    var options: [String: Any] = [:]
    var format: GLenum = GLenum(GL_RGBA)
    var type: GLenum = GLenum(GL_UNSIGNED_BYTE)
    var magFilter: GLenum = GLenum(GL_LINEAR)
    var minFilter: GLenum = GLenum(GL_LINEAR)
    
    
    init(options: [String: Any]? = nil, fileName: String) {
        if let o = options {
            self.options = o
            self.format = o["format"] as! GLenum
            self.type = o["type"] as! GLenum
            self.magFilter = o["magFilter"] as! GLenum
            self.minFilter = o["magFilter"] as! GLenum
        }

        //
        let filePath = Bundle.main.resourcePath! + "/" + fileName
        let _cgImg = UIImage(named: filePath)?.cgImage
        if let cgImg = _cgImg {
            self.width = cgImg.width
            self.height = cgImg.height
            
        }
        glGenTextures(1, &id)
        glBindTexture(GLenum(GL_TEXTURE_2D), id)
    
        
       
        
    }
    
    func bind(unit: Int){
       glBindTexture(GLenum(GL_TEXTURE_2D), id)
    }
    
    func unbind(unit: Int) {
        glBindTexture(GLenum(GL_TEXTURE_2D), 0)
    }
    
    class func loadFromImage(fileName: String) {
        
    }
    
}
