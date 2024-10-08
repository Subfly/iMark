//
//  CreateBookmarkVM.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class CreateBookmarkVM {
    var linkText: String = ""
    var labelText: String = ""
    var tags: [PersistentIdentifier] = []
    var selectedIcon: String?
    var description: String?
    var imageUrl: String?
    var folderId: PersistentIdentifier?
}
