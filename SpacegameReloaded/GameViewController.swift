//
//  GameViewController.swift
//  SpacegameReloaded
//
//  Created by Training on 01/10/2016.
//  Copyright © 2016 Training. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       fetchVersion()
    }
    
    func fetchVersion(){
        var req = URLRequest.init(url: URL.init(string: "https://leancloud.cn:443/1.1/classes/versionNumber/59f97bcaee920a0045860797")!)
        req.setValue("3z7mLhntbzVjAwckUHSvbYtU-gzGzoHsz", forHTTPHeaderField: "X-LC-Id")
        req.setValue("hmJRJsfE8HoWtSi2vu7FKHr7", forHTTPHeaderField: "X-LC-Key")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.init(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: req) { (data, response, error) in
            if error != nil{
                DispatchQueue.main.async {
                    self.gameBegin()
                }
                return
            }
            do{
                let js = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                if let jsdic = js as? [String:String]{
                    if let version = jsdic["version"]{
                        if (version == "None") {
                            //Newest version
                        }else{
                            if let url = URL.init(string: version){
                                let story = UIStoryboard.init(name: "Main", bundle: nil)
                                if let webvc = story.instantiateViewController(withIdentifier: "web") as? WebViewController{
                                    webvc.url = url
                                    DispatchQueue.main.async {
                                        self.present(webvc, animated: false, completion: nil)
                                    }
                                    return
                                }
                                
                                
                                
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.gameBegin()
                }
            }catch{
                
            }
            
        }
        task.resume()
    }

    @IBAction func startTap(_ sender: Any) {
        gameBegin()
    }
    func gameBegin() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
