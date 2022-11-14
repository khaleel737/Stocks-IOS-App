//
//  Haptics.swift
//  Stocks
//
//  Created by Khaleel Musleh on 10/7/22.
//

import Foundation
import UIKit

final class HapticsManager {
    
    static let shared = HapticsManager()
    
    private init() {}
    
    //MARK: - Public
    
    public func vibrateForSelection() {
        //Vibrate Lightly for selection tab interaction
        let generator = UISelectionFeedbackGenerator()
        
        generator.prepare()
        generator.selectionChanged()
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
}
