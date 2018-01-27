//
//  Branding.swift
//  iPRETIX
//
//  Created by Nathan Mattes on 27.01.18.
//  Copyright © 2018 Nathan Mattes. All rights reserved.
//

import UIKit

class Branding {
    
    static let shared = Branding()
    
    //MARK: - Colors
    
    private let pretixPurpleColor = UIColor(red: 59.0/255.0, green: 28.0/255.0, blue: 74.0/255.0, alpha: 1.0) //#3B1C4A
    private let pretixWhiteColor = UIColor.white
    private let pretixGreenColor = UIColor(red: 43.0/255.0, green: 74.0/255.0, blue: 28.0/255.0, alpha: 1.0) //#2B4A1C
    
    var whiteTextColor: UIColor {
        return self.pretixWhiteColor
    }
    
    var purpleTextColor: UIColor {
        return self.pretixPurpleColor
    }
    
    var defaultButtonTextColor: UIColor {
        return self.purpleTextColor
    }
    
    var defaultBackgroundColor: UIColor {
        return self.pretixWhiteColor
    }

    //MARK: - Fonts
    
    /*
     default font: 20pt
     large font: 24pt
     */
    
    private var defaultFontRegular = UIFont.systemFont(ofSize: 20.0, weight: .regular)
    private var defaultFontBold = UIFont.systemFont(ofSize: 20.0, weight: .bold)
    private var largeFontRegular = UIFont.systemFont(ofSize: 24.0, weight: .regular)
    private var largeFontBold = UIFont.systemFont(ofSize: 24.0, weight: .bold)
    
    var defaultButtonFont: UIFont {
        return self.largeFontBold
    }
    
    //MARK: - Icons
}
