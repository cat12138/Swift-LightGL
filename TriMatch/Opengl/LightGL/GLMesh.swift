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
import OpenGLES
import GLKit


// for convenient
enum GLVertexAttribType: String {
    case vertices = "vertices"
    case tangents = "tangents"
    case bitangents = "bitangents"
    case normals = "normals"
    case texcoords = "texcoords"
    case colors = "colors"
    case triangles = "triangles"
    case lines = "lines"
}

class GLMesh: GLProtocol {
    var shaderProgram: GLShader
    var vao: GLuint = 0
    
    var options: Dictionary<String, Any> = [:]
    
    var vertexBuffers: [(name: String, layout: GLuint, buffer: GLBuffer)] = []
    var indexBuffers: [(name: String, buffer: GLBuffer)] = []
    
    //原始数据，按点存，glBufferData要压缩成一维
    var rawData: Dictionary<String, [[Any]]> = [
        "vertices" : [],
        "tangents" : [],
        "bitangents" : [],
        "normals" : [],
        "texcoords" : [],
        "colors" : [],
        "triangles" : [], //画三角形
        "lines" : []   //画线
    ]
    
    
    
    // Example usage:
    //
    //     var mesh = new GL.Mesh({ coords: true, lines: true });
    //
    //     // Default attribute "vertices", available as "gl_Vertex" in
    //     // the vertex shader
    //     mesh.vertices = [[0, 0, 0], [1, 0, 0], [0, 1, 0], [1, 1, 0]];
    //
    //     // Optional attribute "coords" enabled in constructor,
    //     // available as "gl_TexCoord" in the vertex shader
    //     mesh.coords = [[0, 0], [1, 0], [0, 1], [1, 1]];
    //
    //     // Custom attribute "weights", available as "weight" in the
    //     // vertex shader
    //     mesh.addVertexBuffer('weights', 'weight');
    //     mesh.weights = [1, 0, 0, 1];
    //
    //     // Default index buffer "triangles"
    //     mesh.triangles = [[0, 1, 2], [2, 1, 3]];
    //
    //     // Optional index buffer "lines" enabled in constructor
    //     mesh.lines = [[0, 1], [0, 2], [1, 3], [2, 3]];
    //
    //     // Upload provided data to GPU memory
    //     mesh.compile();
    
    // ### new GL.Indexer()
    init(_ options: Dictionary<String, Any>? = nil) {
        shaderProgram = GLShader(vertexFileName: "mesh.vsh", fragmentFileName: "mesh.fsh")
        
        //生成托盘
        glGenVertexArrays(1, &vao)
  
        //生成缓存区
        addVertexBuffer(name: "vertices", layout: 0)
        var t: Bool = true
        
        if let o = options {
            self.options = o
            for (k, v) in o {
                if k == "tangents" && v as! Bool == true { addVertexBuffer(name: "tangents", layout: 1) }
                if k == "bitangents" && v as! Bool == true { addVertexBuffer(name: "bitangents", layout: 2) }
                if k == "normals" && v as! Bool == true { addVertexBuffer(name: "normals", layout: 3) }
                if k == "texcoords" && v as! Bool == true { addVertexBuffer(name: "texcoords", layout: 4) }
                if k == "colors" && v as! Bool == true { addVertexBuffer(name: "colors", layout: 5) }
                if k == "triangles" && v as! Bool == false { t = false } //explictly close triangles
                if k == "lines" && v as! Bool == true { addIndexBuffer(name: "lines") } //explictly open lines
            }
        }
        
        if t == true { addIndexBuffer(name: "triangles") }
        
        print("opened \(vertexBuffers.count) vertexBuffers")
        print("opened \(indexBuffers.count) indexBuffers")

    }
    
    
    func loadShader() {
        shaderProgram.loadShaders()
    }
 
    
    func bindVertexData() {
     
        glBindVertexArray(vao)

        for vb in vertexBuffers {
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vb.buffer.id)
    
            let component = rawData[vb.name]!.first!.count
            glEnableVertexAttribArray(vb.layout)
            glVertexAttribPointer(vb.layout, GLint(component), GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * component), UnsafeRawPointer(bitPattern: 0))
        }
        
        glBindVertexArray(0)
    }
    
    
    func draw() {
        shaderProgram.use() //如果drawElement没有反应，查看use是否打开。
        
        glBindVertexArray(vao)

        //6种组合
        //triangles: _/true/false
        //lines: _/true/false
        //3种结果
        //glDrawArray
        //glDrawElements(GL_LINES/GL_TRIANGLES)
        let drawType = getDrawType()
        switch drawType {
        case .arrayTriangle:
            glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(rawData["vertices"]!.count * 3))
        case .elementLine:
            
            for i in 0..<indexBuffers.count {
                if indexBuffers[i].name == "lines" {
                    glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffers[i].buffer.id)
                }
            }
            glLineWidth(20)
            glDrawElements(GLenum(GL_LINES), GLsizei(rawData["lines"]!.count * 2), GLenum(GL_UNSIGNED_INT), UnsafeRawPointer(bitPattern: 0))
        case .elementTriangle:
            for i in 0..<indexBuffers.count {
                if indexBuffers[i].name == "triangles" {
                    glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffers[i].buffer.id)
                }
            }
            glDrawElements(GLenum(GL_TRIANGLES), GLsizei(rawData["triangles"]!.count * 3), GLenum(GL_UNSIGNED_INT), UnsafeRawPointer(bitPattern: 0))
        }
        
        glBindVertexArray(0)
    }
    
    
    enum DrawType {
        case arrayTriangle
        case elementLine
        case elementTriangle
    }
    
    fileprivate func getDrawType() -> DrawType {
        //对应init开缓存区
        //triangles: false              arrayTriangle
        //lines: true                   elementLine
        //lines: true, triangles: false elementLine
        if let lines = options["lines"] {
            let l = lines as! Bool
            if l == true  { return .elementLine }
        }
        
        if let triangles = options["triangles"] {
            let t = triangles as! Bool
            if t == false { return .arrayTriangle}
        }
        
        return .elementTriangle
    }
    
    //@param name: 顶点属性名字
    //@param layout: 顶点属性编号
    func addVertexBuffer(name: String, layout: Int32)
    {
        self.vertexBuffers.append((name, GLuint(layout), GLBuffer(target: GLenum(GL_ARRAY_BUFFER), type: .glFloat)))
    }
    
    
    func addIndexBuffer(name: String)
    {
        self.indexBuffers.append((name, GLBuffer(target: GLenum(GL_ELEMENT_ARRAY_BUFFER), type: .gluint)))
    }
    
    
    func compile()
    {
        glBindVertexArray(vao)
        
        for (name, _, vBuffer) in self.vertexBuffers
        {
            vBuffer.data = self.rawData[name]!.flatMap{ $0 }
            print(name, vBuffer.data)
            vBuffer.compile()
        }
        
        for (name, iBuffer) in self.indexBuffers {
            iBuffer.data = self.rawData[name]!.flatMap{ $0 }
            print(name, iBuffer.data)
            iBuffer.compile()
        }
        
        glBindVertexArray(0)
    }
    
    
    func transform()
    {
        
    }
    
    func computeNormal()
    {
        
    }
    
    
    // ### .computeWireframe()
    //
    // Populate the `lines` index buffer from the `triangles` index buffer.
    func computeWireframe()
    {
        var index = GLIndexer()
        for i in 0..<rawData["triangles"]!.count {
            //single triangle
            let t = rawData["triangles"]![i]
            //to 3 lines
            for j in 0..<t.count {
                let a = t[j] as! GLuint
                let b = t[(j+1) % t.count] as! GLuint
                index.add([min(a, b), max(a, b)])
            }
        }
        
        var hasLines: Bool = false
        for i in 0..<indexBuffers.count {
            if indexBuffers[i].name == "lines" { hasLines = true }
        }
        if hasLines == false { addIndexBuffer(name: "lines") }
        rawData["lines"] = index.unique 
        compile()
        
    }
    
    //[Shark]
    func getAABB() -> (min: GLVector, max: GLVector)
    {
        var aabb: (min: GLVector, max: GLVector)
        aabb.min = GLVector(x: GLfloat.infinity, y: GLfloat.infinity, z: GLfloat.infinity)
        aabb.max = aabb.min.negative()
    
        for i in 0..<self.rawData["vertices"]!.count {
            let v = GLVector.fromArray(self.rawData["vertices"]![i] as! [GLfloat])
            aabb.min = GLVector.min(aabb.min, v)
            aabb.max = GLVector.max(aabb.max, v)
        }
        
        return aabb
    }
    
    
    func getBoundingSphere() -> (center: GLVector, radius: GLfloat)
    {
        var aabb = self.getAABB()
        let sphere = (center: GLVector.init(x: 0, y: 0, z: 0), radius: GLfloat(10))
        return sphere
    }

    
    
    
    // ### GLMesh.plane([options])
    //
    // Generates a square 2x2 mesh the xy plane centered at the origin. The
    // `options` argument specifies options to pass to the mesh constructor.
    // Additional options include `detailX` and `detailY`, which set the tesselation
    // in x and y, and `detail`, which sets both `detailX` and `detailY` at once.
    // Two triangles are generated by default.
    // Example usage:
    //
    //     var mesh1 = GL.Mesh.plane();
    //     var mesh2 = GL.Mesh.plane(["detail": 5]);
    //     var mesh3 = GL.Mesh.plane(["detailX": 20, "detailY": 40]);
    //

    // GLMesh的三步曲
    class func plane(_ options: Dictionary<String, Any>? = nil) -> GLMesh
    {
        //1
        let mesh = GLMesh(options)
    
        //2
        var detailX: Int = 1, detailY: Int = 1
        if options != nil {
            detailX = (options!["detailX"] as? Int ) ?? ((options!["detail"] as? Int) ?? 1)
            detailY = (options!["detailY"] as? Int ) ?? ((options!["detail"] as? Int) ?? 1)
        }
        
        for y in 0...detailY {
            let t: Float = Float(y) / Float(detailY)
            
            for x in 0...detailX {
                let s: Float = Float(x) / Float(detailX) //to get fraction
        
                mesh.rawData["vertices"]!.append([Float(2 * s - 1), Float(2 * t - 1), Float(0.0)]) //Float datatype transform for GLBufferData
                mesh.rawData["texcoords"]!.append([Float(s), Float(t)])
                mesh.rawData["normals"]!.append([Float(0.0), Float(0.0), Float(1.0)])
                
                if (x < detailX && y < detailY)
                {
                    let i: GLuint = GLuint(x + y * (detailX + 1))
                    mesh.rawData["triangles"]!.append([i, i + 1, i + GLuint(detailX) + 1])
                    mesh.rawData["triangles"]!.append([i + GLuint(detailX) + 1, i + 1, i + GLuint(detailX) + 2])
                }
            }
        }
        
        //3
        mesh.compile()
        return mesh
    }
    
    
    // ### GLMesh.cube([options])
    //
    // Generates a 2x2x2 box centered at the origin. The `options` argument
    // specifies options to pass to the mesh constructor.
    class func box(_ options: Dictionary<String, Any>? = nil) -> GLMesh
    {
        //1
        let mesh = GLMesh(options)
        
        //2
        let cubeData = [
            [0, 4, 2, 6, -1, 0, 0], // -x
            [1, 3, 5, 7, +1, 0, 0], // +x
            [0, 1, 4, 5, 0, -1, 0], // -y
            [2, 6, 3, 7, 0, +1, 0], // +y
            [0, 2, 1, 3, 0, 0, -1], // -z
            [4, 5, 6, 7, 0, 0, +1]  // +z
        ]
        
        for i in 0..<cubeData.count {
            let data = cubeData[i], v: GLuint = GLuint(i * 4) //4个点一面
            
            for j in 0..<4 {
                let d = data[j]
                mesh.rawData["vertices"]!.append(mesh.pickOctant(d))
                mesh.rawData["texcoords"]!.append([j & 1, (j & 2) / 2])
                mesh.rawData["normals"]!.append(Array(data.suffix(3)))
            }
            mesh.rawData["triangles"]!.append([v, v+1, v+2])
            mesh.rawData["triangles"]!.append([v+2, v+1, v+3])
        }
        
        //3
        mesh.compile()
        
        return mesh
    }
    

    fileprivate func pickOctant(_ i: Int) -> [GLfloat]
    {
        //0 -> -1, 非0 -> 1
        let x = (i & 1) * 2 - 1
        let y = (i & 2) - 1
        let z = (i & 4) / 2 - 1
        return [Float(x), Float(y), Float(z)]
    }
    
    
    // ### GLMesh.sphere([options])
    //
    // Generates a geodesic sphere of radius 1. The `options` argument specifies
    // options to pass to the mesh constructor in addition to the `detail` option,
    // which controls the tesselation level. The detail is `6` by default.
    // Example usage:
    //
    //     var mesh1 = GL.Mesh.sphere();
    //     var mesh2 = GL.Mesh.sphere({ detail: 2 });
    //
    class func sphere(_ options: Dictionary<String, GLfloat>? = nil) -> GLMesh {
        let mesh = GLMesh(options)
        
        return mesh
    }
    
    
    class func cylinder() {
        
    }
    
    
    // ### GLMesh.load(json[, options])
    //
    // Creates a mesh from the JSON generated by the `convert/convert.py` script.
    // Example usage:
    //
    //     var data = {
    //       vertices: [[0, 0, 0], [1, 0, 0], [0, 1, 0]],
    //       triangles: [[0, 1, 2]]
    //     };
    //     var mesh = GL.Mesh.load(data);
    //
    class func load(_ options: Dictionary<String, GLfloat>? = nil) -> GLMesh {
        let mesh = GLMesh(options)
        
        return mesh
    }
}

