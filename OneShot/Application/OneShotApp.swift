//
//  OneShotApp.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 01.07.2024.
//

import SwiftUI
import HotKey

@main
struct OneShotApp: App {
    // MARK: - Properties
    @State private var isFirstResponder: Bool = true
    private var hotKey = HotKey(key: .l, modifiers: [.command])     /// Global --> Cmd + L
    
    // MARK: - Init
    init() {
        setupHotKey()
    }
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            TranslatorView(isFirstResponder: $isFirstResponder)
                .onAppear { setupWindow() }
        }
    }
}

// MARK: - Private
private extension OneShotApp {
    func setupWindow() {
        if let window = NSApplication.shared.windows.first {
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
            window.backgroundColor = .clear
            window.hasShadow = true
            window.styleMask = [.fullSizeContentView, .closable, .miniaturizable]
            window.setContentSize(NSSize(width: 400, height: 90))
        }
    }
    
    func setupHotKey() {
        hotKey.keyDownHandler = { self.toggleAppWindow() }
    }
    
    func toggleAppWindow() {
        NSApp.activate(ignoringOtherApps: true)
        if let window = NSApplication.shared.windows.first {
            if window.isVisible {
                window.orderOut(nil)
            } else {
                window.makeKeyAndOrderFront(nil)
                DispatchQueue.main.async { isFirstResponder = true }
            }
        }
    }
}
