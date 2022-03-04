//
//  StrategicOffset.swift
//  Netrek2
//
//  Created by Darrell Root on 5/9/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//

import Foundation

protocol StrategicOffset {
    
}

extension StrategicOffset {
    func screenX(netrekPositionX: Int,screenWidth: CGFloat) -> CGFloat {
        //return (screenWidth * CGFloat(netrekPositionX) / CGFloat(NetrekMath.galacticSize)) - screenWidth / 2
        return (screenWidth * CGFloat(netrekPositionX) / CGFloat(NetrekMath.galacticSize)) //- screenWidth / 2
    }
    func screenY(netrekPositionY: Int,screenHeight: CGFloat) -> CGFloat {
        //return -(screenHeight * CGFloat(netrekPositionY) / CGFloat(NetrekMath.galacticSize)) + screenHeight / 2
        return -(screenHeight * CGFloat(netrekPositionY) / CGFloat(NetrekMath.galacticSize)) + screenHeight /// 2
    }

}
