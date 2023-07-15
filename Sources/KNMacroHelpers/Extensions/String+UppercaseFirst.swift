//
//  String+UppercaseFirst.swift
//
//
//  Created by Kevin on 7/15/23.
//

import Foundation

public extension String {
    func uppercaseFirstLetter() -> String {
        guard let first else {
            return self
        }
        return first.uppercased() + dropFirst()
    }
}
