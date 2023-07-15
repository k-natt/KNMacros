//
//  EnumCaseParameterSyntax+usableName.swift
//
//
//  Created by Kevin on 7/15/23.
//

import Foundation
import SwiftSyntax

public extension EnumCaseParameterSyntax {
    func usableName() -> String? {
        if let secondName, secondName != "_" {
            return secondName.text
        }
        if let firstName, firstName != "_" {
            return firstName.text
        }
        return nil
    }
}
