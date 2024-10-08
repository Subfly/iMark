//
//  HomeVM.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI

@Observable
class HomeVM {
    private(set) var shouldShowMiniButtons: Bool = false
    var searchQuery: String = ""

    func toggleCreateMenu() {
        self.shouldShowMiniButtons.toggle()
    }
}
