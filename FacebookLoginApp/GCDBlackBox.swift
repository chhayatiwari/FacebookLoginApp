//
//  GCDBlackBox.swift
//  FacebookLoginApp
//
//  Created by Chhaya Tiwari on 10/9/18.
//  Copyright © 2018 chhayatiwari. All rights reserved.
//

import Foundation
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
