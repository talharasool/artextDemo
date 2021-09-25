//
//  ViewController.swift
//  ARTextDemoApp
//
//  Created by talha on 23/09/2021.
//

import UIKit
import SceneKit
import ARKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var placeARBtn : UIButton!
    
    let defaults = UserDefaults.standard
    
    let session = ARSession()
    var textNode:SCNNode?
    var textSize:CGFloat = 5
    var textDistance:Float = 15
    var textData : String = ""
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

extension ViewController : ARSCNViewDelegate {
    
    func setupScene() {
        // set up sceneView
        sceneView.delegate = self
        sceneView.session = session
        sceneView.antialiasingMode = .multisampling4X
        sceneView.automaticallyUpdatesLighting = false
        
        sceneView.preferredFramesPerSecond = 60
        sceneView.contentScaleFactor = 1.3
        //sceneView.showsStatistics = true
        
        enableEnvironmentMapWithIntensity(25.0)
        
        DispatchQueue.main.async {
            //self.screenCenter = self.sceneView.bounds.mid
        }
        
        if let camera = sceneView.pointOfView?.camera {
            camera.wantsHDR = true
            //camera.wantsExposureAdaptation = true
            //camera.exposureOffset = -1
            //camera.minimumExposure = -1
        }
        
     //   sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
        if sceneView.scene.lightingEnvironment.contents == nil {
            if let environmentMap = UIImage(named: "Models.scnassets/sharedImages/environment_blur.exr") {
                sceneView.scene.lightingEnvironment.contents = environmentMap
            }
        }
        sceneView.scene.lightingEnvironment.intensity = intensity
    }
}


extension ViewController  {
    
    @IBAction func restartButton(_ sender: UIButton) {
        
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) -> Void in
            node.removeFromParentNode()
        }
        
    }
    
    @IBAction func placeButton(_ sender: UIButton) {
    
        self.showText(text: textData)
    }
    
}

extension ViewController{
    
    
    func showText(text:String) -> Void{

        let fontSize : CGFloat = 150
        let textDistance : CGFloat  = 98.30975
        print("The font size",fontSize,textDistance)
        
        let textScn = ARText(text: text, font: UIFont .systemFont(ofSize: fontSize), color: UIColor.white, depth: fontSize/10)
        let textNode = TextNode(distance: Float(textDistance)/10, scntext: textScn, sceneView: self.sceneView, scale: 1/100.0)
        self.sceneView.scene.rootNode.addChildNode(textNode)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
       // sceneView.session.pause()
    }
}


extension ViewController  {
    

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
}

