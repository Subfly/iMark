//
//  Sorting.swift
//  YABA
//
//  Created by Ali Taha on 11.10.2024.
//

enum Sorting: Int, Codable, CaseIterable {
    case alphabetical
    case reverseAlphabetical
    case date
    case reverseDate
    
    func getNaming() -> String {
        switch self {
        case .alphabetical:
            "Alphabetical (A-Z)"
        case .reverseAlphabetical:
            "Alphabetical (Z-A)"
        case .date:
            "Date"
        case .reverseDate:
            "Date Inversed"
        }
    }
}
