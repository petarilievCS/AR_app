//
//  ViewController.swift
//  AR Application
//
//  Created by Petar Iliev on 7/22/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        let cube = SCNBox(width: 0.15, height: 0.15, length: 0.15, chamferRadius: 0.01)
        let sphere = SCNSphere(radius: 0.15)
        
        // change cube color to red
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/earth-texture.jpeg")
        cube.materials = [material]
        sphere.materials = [material]
        
        // position box in 3D space
        let node = SCNNode()
        node.position = SCNVector3(0, 0.1, -0.5)
        // node.geometry = sphere
        
        // sceneView.scene.rootNode.addChildNode(node)
        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene with a dice
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(0, 0, -0.1)
            sceneView.scene.rootNode.addChildNode(diceNode)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
