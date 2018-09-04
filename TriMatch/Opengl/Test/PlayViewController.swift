//
// Example 5
// Files: PlayViewController.swift / Shape.swift / shape.vsh / shape.fsh
// Multiple 2D shapes


import UIKit
import GLKit
import OpenGLES

class PlayViewController: GLBaseViewController {

    var s: Shape!
    var m: GLMesh!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //circle
        //s = Shape(radius: 0.5, center: (0.0, 0.0), sample: 30)
        
        //rectangle
        //s = Shape(width: 1, height: 1)
        
        //s = Shape(type: FuncType.normalDistribution, sample: 20, range: 1)
        //s = Shape(type: FuncType.spiral, sample: 30, range: Float.pi * 2)
        
        /*
        s = Shape(sample: 200, petalRadius: 1, leafCount: 4)
        s.loadShader()
        s.bindVertexData()
        */
        
     
        m = GLMesh.plane(["detailX": 5, "detailY": 5, "lines": true, "triangles": false])
        //m = GLMesh.box()
        //m = GLMesh()
        m.loadShader()
        m.bindVertexData()
        m.computeWireframe()
        

        
    
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        super.glkView(view, drawIn: rect)
        
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT) | GLbitfield(GL_STENCIL_BUFFER_BIT))
        glClearColor(1, 0, 1, 1)
        
        //s.draw()
    
        m.draw()
       

    }
}
