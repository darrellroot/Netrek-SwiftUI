//
//  Laser.swift
//  Netrek
//
//  Created by Darrell Root on 3/5/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftUI

class Laser: ObservableObject {
    lazy var appDelegate = NSApplication.shared.delegate as! AppDelegate

    private(set) var laserId: Int
    @Published private(set) var status = 0
    @Published private(set) var directionNetrek: UInt8 = 0 // 256= full circle
    private(set) var direction = 0.0 //radians
    @Published private(set) var positionX = 0
    @Published private(set) var positionY = 0
    @Published private(set) var targetPositionX = 0
    @Published private(set) var targetPositionY = 0
    private(set) var target = 0
    var laserNode = SKShapeNode()
    //let waitAction = SKAction.wait(forDuration: 1.0)
    //let removeAction = SKAction.removeFromParent()
    //let laserAction = SKAction.sequence([SKAction.fadeOut(withDuration: 1.0),SKAction.removeFromParent()])
    let laserRange = 600.0 // game units
    
    init(laserId: Int) {
        self.laserId = laserId
    }
    
    public func reset() {
        self.positionX = 0
        self.positionY = 0
        self.targetPositionX = 0
        self.targetPositionY = 0
        self.status = 0
    }
    
    public func update(laserId: Int, status: Int, directionNetrek: UInt8, positionX: Int, positionY: Int, target: Int) {
        DispatchQueue.main.async {
            self.laserId = laserId
            self.status = status
            self.directionNetrek = directionNetrek
            self.direction = 2.0 * Double.pi * Double(directionNetrek) / 256.0
            self.positionX = self.appDelegate.universe.players[laserId].positionX
            self.positionY = self.appDelegate.universe.players[laserId].positionY
            self.target = target
            if self.status != 0 {
                self.displayLaser()
            }
        }
    }
    public func displayLaser() {
        guard let source = appDelegate.universe.players[safe: self.laserId] else { return }
        let me = appDelegate.universe.me
        let taxiDistance = abs(appDelegate.universe.players[me].positionX - source.positionX) + abs(appDelegate.universe.players[me].positionY - source.positionY)
        guard taxiDistance < NetrekMath.displayDistance / 2 else { return }
        let volume = 1.0 - (2.0 * Float(taxiDistance) / (NetrekMath.displayDistanceFloat))
        appDelegate.soundController?.play(sound: .laser, volume: volume)
        switch self.status{
            
        case 1: // hit
            guard let target = appDelegate.universe.players[safe: target] else {
                return
            }
            //let sourcePoint = CGPoint(x: source.positionX, y: source.positionY)
            self.targetPositionX = target.positionX
            self.targetPositionY = target.positionY
            //let destinationPoint = CGPoint(x: target.positionX, y: target.positionY)
            //var points = [sourcePoint, destinationPoint]
            //laserNode = SKShapeNode(points: &points, count: 2)
            //laserNode.strokeColor = .red
            /*laserNode.lineWidth = 10
                DispatchQueue.main.async {
                    debugPrint("displaying laser hit source \(sourcePoint) destination \(destinationPoint)")
                //self.appDelegate.tacticalViewController?.scene.addChild(self.laserNode)
                    self.laserNode.run(self.laserAction)
 
            }*/
        case 2: // miss
            self.direction = NetrekMath.directionNetrek2radian(self.directionNetrek)
            //let sourcePoint = CGPoint(x: source.positionX, y: source.positionY)
            self.targetPositionX = Int(Double(source.positionX) + cos(self.direction) * laserRange)
            self.targetPositionY = Int(Double(source.positionY) + sin(self.direction) * laserRange)
            //let destinationPoint = CGPoint(x: destinationX, y: destinationY)
            /*var points = [sourcePoint, destinationPoint]
            laserNode = SKShapeNode(points: &points, count: 2)
            laserNode.strokeColor = .red
            laserNode.lineWidth = 10
            DispatchQueue.main.async {
                debugPrint("displaying laser miss source \(sourcePoint) destination \(destinationPoint)")
                //self.appDelegate.tacticalViewController?.scene.addChild(self.laserNode)
                self.laserNode.run(self.laserAction)
            }*/
        case 4: // hit plasma TODO
            break

        default: // should not get here
            debugPrint("Laser.displayLaser invalid status \(status)")
        }
    }
    
}
