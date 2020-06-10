//
//  PointingView.swift
//  Netrek2
//
//  Created by Darrell Root on 5/7/20.
//  Copyright © 2020 Darrell Root. All rights reserved.
//
// Code in this file based don https://swiftui-lab.com/a-powerful-combo/

import Foundation
import SwiftUI

extension View {
    func pointingMouse(onPoint: @escaping (NSEvent,NSPoint) -> Void) -> some View {
        PointingAreaView(onPoint: onPoint) { self }
    }
}

struct PointingAreaView<Content>: View where Content : View {
    let onPoint: (NSEvent,NSPoint) -> Void
    let content: () -> Content
    
    init(onPoint: @escaping(NSEvent, NSPoint) -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.onPoint = onPoint
        self.content = content
    }
    var body: some View {
        PointingAreaRepresentable(onPoint: onPoint, content: self.content())
    }
}
struct PointingAreaRepresentable<Content>: NSViewRepresentable where Content: View {
    let onPoint: (NSEvent,NSPoint) -> Void
    let content: Content
    
    func makeNSView(context: Context) -> NSHostingView<Content> {
        return PointingNSHostingView(onPoint: onPoint, rootView: self.content)
    }
    
    func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {
    }
}

class PointingNSHostingView<Content>: NSHostingView<Content> where Content : View {
    let onPoint: (NSEvent,NSPoint) -> Void

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    init(onPoint: @escaping (NSEvent, NSPoint) -> Void, rootView: Content) {
        self.onPoint = onPoint
        
        super.init(rootView: rootView)
        
        //setupTrackingArea()
    }
    
    required init(rootView: Content) {
        fatalError("init(rootView:) has not been implemented")
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func keyDown(with event: NSEvent) {
        debugPrint("keydown")
        self.onPoint(event, self.convert(event.locationInWindow, from: nil))
    }
    override func mouseDown(with event: NSEvent) {
        self.onPoint(event, self.convert(event.locationInWindow, from: nil))
        //print("left mouse \(NSEvent.mouseLocation)")
    }
    override func rightMouseDown(with event: NSEvent) {
        self.onPoint(event, self.convert(event.locationInWindow, from: nil))
        //print("right mouse \(NSEvent.mouseLocation)")
    }
    override func mouseDragged(with event: NSEvent) {
        self.onPoint(event, self.convert(event.locationInWindow, from: nil))
        //print("right mouse \(NSEvent.mouseLocation)"
    }
    override func otherMouseDown(with event: NSEvent) {
        self.onPoint(event, self.convert(event.locationInWindow, from: nil))
        //print("right mouse \(NSEvent.mouseLocation)")
    }

}
