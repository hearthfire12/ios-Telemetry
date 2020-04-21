//
//  UIView.swift
//  Telemetry
//
//  Created by feelsgood on 19.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import SwiftUI

extension UIImageView {
    convenience init(fromUrl:String) {
        self.init()
        self.load(url: URL(string: fromUrl)!)
    }
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
