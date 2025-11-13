//
//  ContentView.swift
//  CoreDataUI
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 12/11/25.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var context

    var body: some View {
        HomeView(context: context)
    }
}
