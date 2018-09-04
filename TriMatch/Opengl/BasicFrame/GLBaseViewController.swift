//
//  GLBaseViewController.swift
//  TriMatch
//
//  Created by sj on 2018/7/5.
//  Copyright © 2018 sj. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES

class GLBaseViewController: GLKViewController {

    var ctx: GLContext!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            ctx = try GLContext()
        } catch GLError.notSupportES3 {
            print("[Error]: not support ES3 \n")
        } catch {
            print("[Error]: in Context \n")
        }
        
        let gameView = self.view as! GLKView
        gameView.context = ctx.ctx!
        ctx.activate()
        
        gameView.drawableColorFormat = .RGBA8888
        gameView.drawableDepthFormat = .format24
        gameView.drawableMultisample = .multisample4X
        
        self.pauseOnWillResignActive = true
        self.resumeOnDidBecomeActive = true
        self.preferredFramesPerSecond = 60
        
        
        glEnable(GLenum(GL_DEPTH_TEST))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
