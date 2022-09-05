//
//  Song.swift
//  Player
//
//  Created by Pavel Poddubotskiy on 5.09.22.
//

import UIKit

struct Song {
    var image: UIImage
    var name: String
    var artist: String
    var length: Int
    
    static let songs: [Self] = [
        Self(image: UIImage(named: "Prodigy")!, name: "Smack My Bitch Up", artist: "The Prodigy", length: 306),
        Self(image: UIImage(named: "Mobb")!, name: "Shook Ones Pt.2", artist: "Mobb Deep", length: 269),
        Self(image: UIImage(named: "Crazy")!, name: "Butterfly", artist: "Crazy Town", length: 218)
    ]
}
