//
//  Player.swift
//  OnBoardView
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 24/11/25.
//

import AVKit
import SwiftUI

struct Player: View {
    @State private var player = AVPlayer()
    var url: String
    var body: some View {
        VideoPlayer(player: player).onAppear {
            player = AVPlayer(url: URL(string: url)!)
            player.play()
        }
    }
}
