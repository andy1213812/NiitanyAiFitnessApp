//
//  NavigationButton.swift
//  AitheleteZoneApp Watch App
//
//  Created by Andrew Ho on 3/22/24.
//

import SwiftUI

struct NavigationButton<Content: View>: View {
    let destination: Content
    let text: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        NavigationLink(destination: destination) {
            Text(text)
        }
        .frame(width: width, height: height)
        .background(Capsule().fill(Color.blue))
        .foregroundColor(.white)
    }
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButton(destination: ContentView(), text: "example", width: 135, height: 54)
    }
}
