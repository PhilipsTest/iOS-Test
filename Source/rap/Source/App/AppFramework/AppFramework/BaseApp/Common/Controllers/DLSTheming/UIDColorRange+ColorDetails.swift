/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsUIKitDLS

extension UIDColorRange {
    
    func colorDisplayName() -> String {
        switch self {
        case .groupBlue:
            return "GB"
        case .blue:
            return "BL"
        case .aqua:
            return "AQ"
        case .green:
            return "GR"
        case .orange:
            return "OR"
        case .pink:
            return "PI"
        case .purple:
            return "PU"
        case .gray:
            return "GR"
        default:
            return ""
        }
    }
    
    func checkMarkIconColors() -> UIDColorLevel {
        return .color0
    }
    
    func gradientColorLevels() -> [UIDColorLevel] {
        return [.color50, .color45, .color40, .color35]
    }
}
