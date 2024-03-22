//
//  WelcomeView.swift
//  AitheleteZoneApp Watch App
//
//  Created by Andrew Ho on 3/22/24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Image("AIthleteZoneAppIcon").resizable().frame(width: 80, height: 80)
            Text("AIthlete Zone").font(.title2).foregroundStyle(gradient1).shadow(color: .secondary, radius: 0)
            NavigationButton(destination: HeightSettingView(), text: "Let's Begin!", width: 135, height: 54)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
