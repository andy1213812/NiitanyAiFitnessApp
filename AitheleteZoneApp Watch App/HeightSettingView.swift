//
//  HeightSettingView.swift
//  AitheleteZoneApp Watch App
//
//  Created by Andrew Ho on 3/22/24.
//

import SwiftUI

struct HeightSettingView: View {
    @State private var feet = 5
    @State private var inches = 8
    var body: some View {
        VStack {
            Text("Set Your Height").font(.headline).padding([.bottom], 5)
            HStack {
                Picker("Feet", selection: $feet) { ForEach(0..<8) { Text("\($0) ft").tag($0) } }.labelsHidden().pickerStyle(.wheel).frame(width: 60, height: 85).clipped()
                Picker("Inches", selection: $inches) { ForEach(0..<12) { Text("\($0) in").tag($0) } }.labelsHidden().pickerStyle(.wheel).frame(width: 60, height: 85).clipped()
            }
            NavigationButton(destination: WeightSettingView(), text: "Next", width: 135, height: 54)
        }
    }
}

struct HeightSettingView_Previews: PreviewProvider {
    static var previews: some View {
        HeightSettingView()
    }
}
