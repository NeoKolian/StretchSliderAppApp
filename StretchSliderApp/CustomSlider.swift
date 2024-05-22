//
//  CustomSlider.swift
//  StretchSliderApp
//
//  Created by Nikolay Pochekuev on 22.05.2024.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var sliderProgress: CGFloat
    var symbol: Symbol?
    var axis: SliderAxis
    var tint: Color

    @State private var progress: CGFloat = .zero
    @State private var dragOffset: CGFloat = .zero
    @State private var lastDragOffset: CGFloat = .zero

    var body: some View {
        GeometryReader {
            let size = $0.size
            let orientationSize = axis == .horizontal ? size.width : size.height
            let progressValue = (max(progress, .zero)) * orientationSize
            
            ZStack(alignment: axis == .horizontal ? .leading : .bottom) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                
                Rectangle()
                    .fill(tint)
                    .frame (width: axis == .horizontal ? progressValue : nil,
                            height: axis == .vertical ? progressValue : nil)
                
                if let symbol, symbol.display {
                    Image(systemName: symbol.icon)
                        .font(symbol.font)
                        .foregroundStyle(symbol.tint)
                        .padding(symbol.padding)
                        .frame(width: size.width, height: size.height, alignment: symbol.alignment)
                }
            }
            .clipShape(.rect(cornerRadius: 16))
            .contentShape(.rect(cornerRadius: 16))
            .optionalSizingModifiers(
                axis: axis,
                size: size,
                progress: progress,
                orientationSize: orientationSize
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged {
                        let translation = $0.translation
                        let movement = (axis == .horizontal ? translation.width : -translation.height) + lastDragOffset
                        dragOffset = movement
                        calculateProgress(orientationSize: orientationSize)
                    }
                    .onEnded { _ in
                        withAnimation(.smooth) {
                            dragOffset = dragOffset > orientationSize ? orientationSize :
                            (dragOffset < 0 ? 0 : dragOffset)
                            calculateProgress (orientationSize: orientationSize)
                        }
                        lastDragOffset = dragOffset
                    }
            )
            .frame(
                maxWidth: size.width,
                maxHeight: size.height,
                alignment: axis == .vertical ? (progress < 0 ? .top : .bottom) : .leading
            )
        }
    }
     
    private func calculateProgress(orientationSize: CGFloat) {
        let topAndTrailingExcessOffset = orientationSize + (dragOffset - orientationSize) * 0.15
        let bottomAndLeadingExcessOffset = dragOffset < 0 ? (dragOffset * 0.15) : dragOffset
        let progress = (dragOffset > orientationSize ? topAndTrailingExcessOffset : bottomAndLeadingExcessOffset) / orientationSize
        self.progress = progress
    }
    
    struct Symbol {
        var icon: String
        var tint: Color
        var font: Font
        var padding: CGFloat
        var display: Bool = true
        var alignment: Alignment = .center
    }

    enum SliderAxis {
        case vertical
        case horizontal
    }
}

fileprivate extension View {
    @ViewBuilder
    func optionalSizingModifiers(
        axis: CustomSlider.SliderAxis,
        size: CGSize,
        progress: CGFloat,
        orientationSize: CGFloat
    ) -> some View {
        self
            .frame (
                height: axis == .vertical && progress < 0 ? size.height + (-progress * size.height) : nil
            )
    }
}

#Preview {
    ContentView()
}
