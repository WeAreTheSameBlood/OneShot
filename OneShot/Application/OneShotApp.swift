//
//  OneShotApp.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 01.07.2024.
//

import SwiftUI

@main
struct OneShotApp: App {
    var body: some Scene {
        WindowGroup {
            TranlatorView()
                .onAppear {
                    setupWindow()
                }
        }
    }
}

private extension OneShotApp {
    func setupWindow() {
        if let window = NSApplication.shared.windows.first {
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
            window.backgroundColor = .clear
            window.isOpaque = false
            window.hasShadow = true
            window.styleMask = [.fullSizeContentView, .closable, .miniaturizable]
            window.setContentSize(NSSize(width: 400, height: 90))
        }
    }
}
