//
//  NSlayoutConstraint.swift
//  Wardah
//
//  Created by Nour  on 11/5/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import Foundation


class XNSLayoutConstraint: NSLayoutConstraint {
    override func awakeFromNib() {
        let ratio = Double(UIScreen.main.bounds.height / 1334 ) * 2.0
        self.constant = self.constant * CGFloat(ratio)
    }
}
