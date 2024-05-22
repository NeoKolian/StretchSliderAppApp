//
//  ContentView.swift
//  StretchSliderApp
//
//  Created by Nikolay Pochekuev on 22.05.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var progress: CGFloat = .zero
    @State private var axis: CustomSlider.SliderAxis = .vertical
    
    var body: some View {
        VStack {
            CustomSlider(
                sliderProgress: $progress,
                symbol: .init(icon: "airpodspro", tint: .gray, font: .system(size: 25), padding: 20, display: axis == .vertical, alignment: .bottom),
                axis: .vertical,
                tint: .white
            )
            .frame(width: 60, height: 180)
            .frame(maxHeight: .infinity)
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 3)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
    }
}

#Preview {
    ContentView()
}
