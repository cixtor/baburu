//
//  IntervalFormatter.swift
//  Baburu
//
//  Created by cixtor on 02/10/19.
//  Copyright © 2019 cixtor. All rights reserved.
//

import Foundation

class IntervalFormatter: NumberFormatter {
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if partialString.isEmpty {
            return true
        }

        guard let number = Double(partialString) else {
        	print("Invalid interval: \(partialString)")
        	return false
        }

        if number < 1 || number > 86400 {
        	print("Unsupported interval: \(number)")
        	return false
        }

        return true
    }
}
