//
//  LocationView.swift
//  MapKitIOS17
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import MapKit
import SwiftUI

struct LocationView: View {

    @Binding var markerSelection: MKMapItem?
    @Binding var showLocation: Bool
    @State var lookAroundScene: MKLookAroundScene?
    @Binding var getDirections: Bool

    var body: some View {
        VStack {
            Text(markerSelection?.placemark.name ?? "")
                .font(.title)
                .bold()
                .padding(.top, 10)

            Text(markerSelection?.placemark.title ?? "")
                .font(.footnote)
                .bold()
                .foregroundStyle(.gray)
                .lineLimit(2)
                .padding(.trailing)

            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene).frame(height: 200)
                    .cornerRadius(12)
                    .padding(.all)
            } else {
                ContentUnavailableView(
                    "Sin vista previa",
                    systemImage: "eye.slash"
                )
            }
        }.padding(.all)
            .onAppear {
                fetchAroundPreview()
            }
            .onChange(of: markerSelection) { oldValue, newValue in
                fetchAroundPreview()
            }

        HStack(spacing: 30) {
            Button {
                if let markerSelection {
                    markerSelection.openInMaps()

                }
            } label: {
                Image(systemName: "map.circle")
            }.buttonStyle(.borderedProminent)
                .tint(.blue)

            Button {
                getDirections = true
                showLocation = false

            } label: {
                Image(systemName: "arrow.triangle.turn.up.right.circle")
            }.buttonStyle(.borderedProminent)
                .tint(.green)
        }
    }
}

extension LocationView {
    func fetchAroundPreview() {
        if let markerSelection {
            lookAroundScene = nil

            Task {
                let request = MKLookAroundSceneRequest(mapItem: markerSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }
}
