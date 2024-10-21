//
//  CreateBookmarkNavigationManager.swift
//  YABA
//
//  Created by Ali Taha on 21.10.2024.
//

import Foundation
import SwiftUI

@Observable
class CreateBookmarkNavigationManager {
    var routes: NavigationPath = .init()
    
    func navigate(to destination: CreateBookmarkDestination) {
        self.routes.append(destination)
    }
    
    func pop() {
        self.routes.removeLast()
    }
}
