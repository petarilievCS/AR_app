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
    
    var dice = [SCNNode]()

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // check if there was a touch
        if let touch = touches.first {
            
            let location = touch.location(in: sceneView)
            let locationInSpace = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
            
            if let actualLocation = locationInSpace.first {
                // Create a new scene with a dice
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                    diceNode.position = SCNVector3(
                        actualLocation.worldTransform.columns.3.x,
                        actualLocation.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                        actualLocation.worldTransform.columns.3.z)
                    dice.append(diceNode)
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    roll(diceNode)
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(
                width: CGFloat(planeAnchor.extent.x),
                height: CGFloat(planeAnchor.extent.z))
            
            // position plane
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
            
            // rotate plane
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
             
            
            planeNode.geometry = plane
            node.addChildNode(planeNode)
        }
        return
    }
    
    @IBAction func rollAll(_ sender: Any) {
        rollAllDice()
    }
    
    @IBAction func removeDice(_ sender: UIBarButtonItem) {
        if !dice.isEmpty {
            for diceNode in dice {
                diceNode.removeFromParentNode()
            }
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAllDice()
    }
    
    func rollAllDice() {
        if !dice.isEmpty {
            for die in dice {
                roll(die)
            }
        }
    }
    
    func roll(_ diceNode: SCNNode) {
        
        // create random rotation angles
        let randomX = Float((arc4random_uniform(4) + 1)) * (Float.pi / 2)
        let randomZ = Float((arc4random_uniform(4) + 1)) * (Float.pi / 2)
        
        diceNode.runAction(SCNAction.rotateBy(
            x: CGFloat(randomX) * 5,
            y: 0.0,
            z: CGFloat(randomZ) * 5,
            duration: 0.5))
    }
}
