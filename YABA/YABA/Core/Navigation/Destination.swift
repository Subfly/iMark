//
//  Destination.swift
//  YABA
//
//  Created by Ali Taha on 8.10.2024.
//

import SwiftData

enum Destination: Hashable {
    case home
    case folder(id: PersistentIdentifier)
    case bookmark(id: PersistentIdentifier)
}
