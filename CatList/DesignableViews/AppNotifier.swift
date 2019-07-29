//
//  AppNotifier.swift
//  CatList
//
//  Created by Nitesh Tak on 29/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import Foundation
import Whisper
import AudioToolbox

final class AppNotifier {
    
    class func whisper(message: String) {
        let errorString = Whisper.Murmur(title: message, backgroundColor: UIColor(red: 0.75, green: 0.07, blue: 0.07, alpha: 1), titleColor: .white, font: UIFont.boldSystemFont(ofSize: 14.0), action: nil)
        Whisper.show(whistle: errorString, action: .show(3.0))
        
        let feedback = UINotificationFeedbackGenerator()
        feedback.prepare()
        feedback.notificationOccurred(.error)
    }
    
    class func info(message: String) {
        let infoString = Whisper.Murmur(title: message, backgroundColor: .gray, titleColor: UIColor.white, font: UIFont.systemFont(ofSize: 14.0), action: nil)
        Whisper.show(whistle: infoString, action: .show(3.0))
    }
    
    class func success(message: String) {
        let infoString = Whisper.Murmur(title: message, backgroundColor: UIColor(red: 0.26, green: 0.6, blue: 0.1, alpha: 1), titleColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 14.0), action: nil)
        Whisper.show(whistle: infoString, action: .show(3.0))
    }
}

