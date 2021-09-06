//
//  BoardingScreen.swift
//  On Boarding
//
//  Created by akhmad khalif on 28/08/21.
//

import Foundation

struct BoardingScreen: Identifiable {
    var id = UUID().uuidString
    var image: String
    var title: String
    var description: String
}

let title = "Explore \nthe fuckin world"
let description = "A Journey of a thousand \nmiles must begin with a single step"


var boardingScreens: [BoardingScreen] = [
    BoardingScreen(image: "screen1", title: title, description: description),
    BoardingScreen(image: "screen2", title: "Enjoy your time", description: description),
    BoardingScreen(image: "screen1", title: title, description: description),
    BoardingScreen(image: "screen2 ", title: title, description: description),
]
