//
//  ReelsView.swift
//  OnBoardView
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 24/11/25.
//

import SwiftUI

struct ReelsView: View {
    let videos: [Reels] = [
        Reels(
            url:
                "https://player.vimeo.com/external/425864361.sd.mp4?s=2c7fec7c5b41b0350c19f936d3ca50b6931e6bab&profile_id=165&oauth2_token_id=57447761",
            title: "Reel1"
        ),
        Reels(
            url:
                "https://player.vimeo.com/external/479728625.hd.mp4?s=84b5a866b5b24de0e1d3bc20fbd0a98d544bda93&profile_id=174&oauth2_token_id=57447761",
            title: "Reel2"
        ),
        Reels(
            url:
                "https://player.vimeo.com/external/505557796.hd.mp4?s=11bb279ddf18533b56a8c3d858f2ddee0cb5e8aa&profile_id=173&oauth2_token_id=57447761",
            title: "Reel 3"
        ),

    ]

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            TabView {
                ForEach(videos) { video in
                    VStack {
                        Text(video.title)
                            .foregroundColor(.white)
                            .bold()
                            .padding(.bottom, 10)

                        Player(url: video.url).aspectRatio(
                            9 / 16,
                            contentMode: .fit
                        )
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                    .padding()
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
        }
    }
}
