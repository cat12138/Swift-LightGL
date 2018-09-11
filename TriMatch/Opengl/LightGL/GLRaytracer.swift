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


class Raytracer {
    init() {
       
    }
    
    
    func getRayForPixel()
    {
        
    }
    
    
    class func hitTestBox(origin: GLVector, ray: GLVector, min: inout GLVector, max: inout GLVector) -> HitTest?
    {
        let tMin = min.substract(origin).divide(ray)
        let tMax = max.substract(origin).divide(ray)
        let t1 = GLVector.min(tMin, tMax)
        let t2 = GLVector.max(tMin, tMax)
        let tNear = t1.max()
        let tFar = t2.min()
        
        if (tNear > 0 && tNear < tFar)
        {
            let epsilon: Float = 1.0e6
            let hit = origin.add(ray.multiply(tNear))
            min = min.add(epsilon)
            max = max.substract(epsilon)
            
            return HitTest(t: tNear, hit: hit, normal:
                GLVector(x: (hit.x > max.x ? 1 : 0) - (hit.x < min.x ? 1 : 0),
                         y: (hit.y > max.y ? 1 : 0) - (hit.y < min.y ? 1 : 0),
                         z: (hit.z > max.z ? 1 : 0) - (hit.z < min.z ? 1 : 0)))
            
        }
        return nil
    }
    
    
    class func hitTestSphere(origin: GLVector, ray: GLVector, sphereCenter: GLVector, sphereRadius :GLfloat) -> HitTest?
    {
        let offset = origin.substract(sphereCenter)
        let a = ray.dot(ray)
        let b = 2 * offset.dot(ray)
        let c = offset.dot(offset) - sphereRadius * sphereRadius
        
        let discriminant = b*b - 4*a*c
        if (discriminant > 0)
        {
            let t = (-b - sqrtf(discriminant)) / (2*a)
            let hit = origin.add(ray.multiply(t))
            let normal = hit.substract(sphereCenter).divide(sphereRadius)
            return HitTest(t: t, hit: hit, normal: normal)
        }
        
        return nil
    }
    
    
    class func hitTestTriangle(origin: GLVector, ray: GLVector, a: GLVector, b: GLVector, c: GLVector) -> Any?
    {
        //求出法向量
        let ba = b.substract(a)
        let ca = c.substract(a)
        let normal = ba.cross(ca).unit()
        
        //光线源点距三角形所在平面的距离 / 光线方向在平面法线上的分量
        let t = normal.dot(a.substract(origin)) / normal.dot(ray)
        
        var np: Int = 0 //不确定
        if normal.dot(ray) > 0 {
            np = -1 //点在平面里（和法线同向）
        } else {
            np = 1//点在平面外
        }
        
        //ao = a.substruct(origin
        //ao和ray在同一个方向
        if (t > 0)
        {
            let hit = origin.add(ray.multiply(t)) //在平面上的交点
            
            //判断此点是否在三角面内
            //3重心法
            //P = A + u(C-A) + v(B-A)
            //P-A = u(C-A) + v(B-A)
            let toHit = hit.substract(a)
            let dot00 = ca.dot(ca)
            let dot01 = ca.dot(ba)
            let dot02 = ca.dot(toHit)
            let dot11 = ba.dot(ba)
            let dot12 = ba.dot(toHit)
            let divide = dot00 * dot11 - dot01 * dot01
            let u = (dot11 * dot02 - dot01 * dot12) / divide
            let v = (dot00 * dot12 - dot01 * dot02) / divide
            if (u >= 0 && v >= 0 && u + v <= 1)
            {
                return HitTest(t: t , hit: hit, normal: normal)
            }
            
            
            
            //1面积法：海伦公式（三角形周长面积关系公示）
            /*
            let bc = b.substract(c)
            let abL = sqrtf(ba.dot(ba))
            let caL = sqrtf(ca.dot(ca))
            let bcL = sqrtf(bc.dot(bc))
        
            let ap = a.substract(hit)
            let bp = b.substract(hit)
            let cp = c.substract(hit)
            let apL = sqrtf(ap.dot(ap))
            let bpL = sqrtf(bp.dot(bp))
            let cpL = sqrtf(cp.dot(cp))
            
            let perimeterABC = abL + bcL + caL
            let perimeterABP = abL + apL + bpL
            let perimeterBCP = bcL + bpL + cpL
            let perimeterCAP = caL + apL + cpL
            
            let areaABC = sqrtf(perimeterABC * (perimeterABC - abL) * (perimeterABC - bcL) * (perimeterABC - caL))
            let areaABP = sqrtf(perimeterABP * (perimeterABP - abL) * (perimeterABP - apL) * (perimeterABP - bpL))
            let areaBCP = sqrtf(perimeterBCP * (perimeterBCP - bcL) * (perimeterBCP - bpL) * (perimeterBCP - cpL))
            let areaCAP = sqrtf(perimeterCAP * (perimeterCAP - caL) * (perimeterCAP - apL) * (perimeterCAP - cpL))
            if areaABC == (areaABP + areaBCP + areaCAP)
            {
                return HitTest(t: t, hit: hit, normal: normal)
            }
            */
            
            
            //2面积法：向量法
            /*
            let areaABC = ca.cross(ba).lengh() / 2
            let ap = a.substract(hit)
            let bp = b.substract(hit)
            let cp = c.substract(hit)
            let areaABP = ap.cross(ba).length() / 2
            let areaBCP = bp.cross(cp).length() / 2
            let areaCAP = cp.cross(ap).length() / 2
            if areaABC == (areaABP + areaBCP + areaCAP)
            {
                return HitTest(t: t, hit: hit, normal: normal)
            }*/
            
            
            //
            
        }
        return nil
    }
    
    
    
    //detect whether a point in a AABB
    class func pointInAABB(point: GLVector, cubeMin: GLVector, cubeMax: GLVector) -> Bool
    {
        return (point.x >= cubeMin.x && point.x <= cubeMax.x) &&
            (point.y >= cubeMin.y && point.y <= cubeMax.y) &&
            (point.z >= cubeMin.z && point.z <= cubeMax.z);
    }
    
    //2 AABBs intersect
    func intersectAABB(cube1Min: GLVector, cube1Max: GLVector, cube2Min: GLVector, cube2Max: GLVector) -> Bool
    {
        return (cube1Min.x <= cube2Max.x && cube1Max.x >= cube2Min.x) &&
            (cube1Min.y <= cube2Max.y && cube1Max.y >= cube2Min.y) &&
            (cube1Min.z <= cube2Max.z && cube1Max.z >= cube2Min.z);
    }
}
