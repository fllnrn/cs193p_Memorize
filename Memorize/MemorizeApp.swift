//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Андрей Гавриков on 22.06.2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var themeStore = ThemeStore()

    
    var body: some Scene {
        WindowGroup {
            ThemeChooser().environmentObject(themeStore)
        }
    }
}
