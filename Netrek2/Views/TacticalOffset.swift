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
    func planetWidth(screenWidth: CGFloat) -> CGFloat {
        return CGFloat(NetrekMath.planetDiameter) * screenWidth / CGFloat(NetrekMath.displayDistance)
    }
    func playerWidth(screenWidth: CGFloat) -> CGFloat {
        return CGFloat(NetrekMath.playerSize) * screenWidth / CGFloat(NetrekMath.displayDistance)
    }
    func torpedoWidth(screenWidth: CGFloat) -> CGFloat {
        return CGFloat(NetrekMath.torpedoSize) * screenWidth / CGFloat(NetrekMath.displayDistance)
    }

    func viewXOffset(positionX: Int, myPositionX: Int, tacticalWidth: CGFloat) -> CGFloat {
        // from NSView coordinates
        let screenDelta = CGFloat(positionX) - tacticalWidth / 2
        let screenPercentDelta = screenDelta / tacticalWidth
        let screenNetrekDelta = screenPercentDelta * CGFloat(NetrekMath.displayDistance)
        return CGFloat(myPositionX) + screenNetrekDelta
    }
    func viewYOffset(positionY: Int, myPositionY: Int, tacticalHeight: CGFloat) -> CGFloat {
        // from NSView coordinates
        let screenDelta = CGFloat(positionY) - tacticalHeight / 2
        let screenPercentDelta = screenDelta / tacticalHeight
        let screenNetrekDelta = screenPercentDelta * CGFloat(NetrekMath.displayDistance)
        return CGFloat(myPositionY) + screenNetrekDelta
    }

    
    func xOffset(positionX: Int, myPositionX: Int, tacticalWidth: CGFloat) -> CGFloat {
        let viewPositionX: Int
        if myPositionX > -20000 && myPositionX < 20000 {
            viewPositionX = myPositionX
        } else {
            viewPositionX = 5000
        }
        let x = CGFloat(positionX - viewPositionX) * (CGFloat(NetrekMath.displayDistance) / CGFloat(NetrekMath.galacticSize)) * tacticalWidth / 1000
        return x
    }
    func yOffset(positionY: Int, myPositionY: Int, tacticalHeight: CGFloat) -> CGFloat {
        let viewPositionY: Int
        if myPositionY > -20000 && myPositionY < 20000 {
            viewPositionY = myPositionY
        } else {
            viewPositionY = 5000
        }
        let y = CGFloat(viewPositionY - positionY) * (CGFloat(NetrekMath.displayDistance) / CGFloat(NetrekMath.galacticSize)) * tacticalHeight / 1000
        return y
    }
}
