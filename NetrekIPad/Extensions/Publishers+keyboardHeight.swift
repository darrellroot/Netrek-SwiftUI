//
//  Publishers+keyboardHeight.swift
//  NetrekIPad
//
//  Created by Darrell Root on 6/10/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//
// From https://www.vadimbulavin.com/how-to-move-swiftui-view-when-keyboard-covers-text-field/

import Foundation
import Combine
import SwiftUI

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat,Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
    
}
