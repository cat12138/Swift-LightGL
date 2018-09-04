//
//  GLProtocol.swift
//  TriMatch
//
//  Created by sj on 2018/7/5.
//  Copyright © 2018 sj. All rights reserved.
//

import Foundation


protocol GLProtocol {
    var shaderProgram: GLShader { get set }
    
    func loadShader()
    func bindVertexData()
    func draw()
}
