//
//  TacticalOffset.swift
//  Netrek2
//
//  Created by Darrell Root on 5/6/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation
import SwiftUI

protocol TacticalOffset {
}

extension TacticalOffset {
    func planetWidth(screenWidth: CGFloat, visualWidth: CGFloat) -> CGFloat {
        //let width = CGFloat(NetrekMath.planetDiameter) * screenWidth / CGFloat(NetrekMath.displayDistance)
        let width = CGFloat(NetrekMath.planetDiameter) * screenWidth / visualWidth
        //debugPrint("planet width \(width)")
        return width
    }
    func playerWidth(screenWidth: CGFloat, visualWidth: CGFloat) -> CGFloat {
        let width = CGFloat(NetrekMath.playerSize) * screenWidth / visualWidth
        //debugPrint("player width \(width)")
        return width
    }
    func torpedoWidth(screenWidth: CGFloat, visualWidth: CGFloat) -> CGFloat {
        return CGFloat(NetrekMath.torpedoSize) * screenWidth / visualWidth
    }
    func plasmaWidth(screenWidth: CGFloat, visualWidth: CGFloat) -> CGFloat {
        return CGFloat(NetrekMath.plasmaSize) * screenWidth / visualWidth
    }


    //This calculation is relative to NSView
    func viewXOffset(positionX: Int, myPositionX: Int, tacticalWidth: CGFloat) -> CGFloat {
        // from NSView coordinates
        let screenDelta = CGFloat(positionX) - tacticalWidth / 2
        let screenPercentDelta = screenDelta / tacticalWidth
        let screenNetrekDelta = screenPercentDelta * CGFloat(NetrekMath.displayDistance)
        return CGFloat(myPositionX) + screenNetrekDelta
    }
    //This calculation is relative to NSView
    func viewYOffset(positionY: Int, myPositionY: Int, tacticalHeight: CGFloat) -> CGFloat {
        // from NSView coordinates
        let screenDelta = CGFloat(positionY) - tacticalHeight / 2
        let screenPercentDelta = screenDelta / tacticalHeight
        let screenNetrekDelta = -screenPercentDelta * CGFloat(NetrekMath.displayDistance)
        return CGFloat(myPositionY) + screenNetrekDelta
    }
    
    func xAbsolute(positionX: Int, myPositionX: Int, tacticalWidth: CGFloat, visualWidth: CGFloat) -> CGFloat {
        return xOffset(positionX: positionX, myPositionX: myPositionX, tacticalWidth: tacticalWidth, visualWidth: visualWidth) + tacticalWidth / 2
    }
    func yAbsolute(positionY: Int, myPositionY: Int, tacticalHeight: CGFloat, visualHeight: CGFloat) -> CGFloat {
        return yOffset(positionY: positionY, myPositionY: myPositionY, tacticalHeight: tacticalHeight, visualHeight: visualHeight) + tacticalHeight / 2
    }

    //This calculation is relative to SwiftUI view
    func xOffset(positionX: Int, myPositionX: Int, tacticalWidth: CGFloat, visualWidth: CGFloat) -> CGFloat {
        let viewPositionX: Int
        if myPositionX > -20000 && myPositionX < 20000 {
            viewPositionX = myPositionX
        } else {
            viewPositionX = 5000
        }
        //let x = CGFloat(positionX - viewPositionX) * (visualWidth / CGFloat(NetrekMath.galacticSize)) * tacticalWidth / 1000
        let x = CGFloat(positionX - viewPositionX) * tacticalWidth / visualWidth
        return x
    }
    //This calculation is relative to SwiftUI view
    func yOffset(positionY: Int, myPositionY: Int, tacticalHeight: CGFloat, visualHeight: CGFloat) -> CGFloat {
        let viewPositionY: Int
        if myPositionY > -20000 && myPositionY < 20000 {
            viewPositionY = myPositionY
        } else {
            viewPositionY = 5000
        }
        //let y = CGFloat(viewPositionY - positionY) * (visualHeight / CGFloat(NetrekMath.galacticSize)) * tacticalHeight / 1000
        let y = -1 * CGFloat(positionY - viewPositionY) * tacticalHeight / visualHeight

        return y
    }
}
