//
//  Date.swift
//  TerminalCrypto
//
//  Created by Ben Stacy on 12/13/24.
//

import Foundation

extension Date {
        
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
}
