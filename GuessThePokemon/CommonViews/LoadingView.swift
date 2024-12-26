//
//  LoadingView.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
            Text("Loading...")
                .padding()
        }
    }
}
