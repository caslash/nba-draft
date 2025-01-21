//
//  WrappingCollectionView.swift
//  Drafter
//
//  Created by Cameron S Slash on 1/21/25.
//

import SwiftUI

public struct WrappingCollectionView<Data: RandomAccessCollection, Content: View, InBetweenContent: View>: View {
    private var data: Data
    private var spacing: CGFloat
    private var content: (Data.Element) -> Content
    private var inBetweenContent: () -> InBetweenContent?
    @State private var totalHeight: CGFloat = .zero
    
    public init(
        _ data: Data,
        spacing: CGFloat = 8,
        @ViewBuilder content: @escaping (Data.Element) -> Content,
        @ViewBuilder inBetweenContent: @escaping () -> InBetweenContent? = { return nil }
    ) {
        self.data = data
        self.spacing = spacing
        self.content = content
        self.inBetweenContent = inBetweenContent
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geometry in
                generateContent(in: geometry)
                    .background(GeometryReader { geo in
                        Color.clear.preference(key: HeightPreferenceKey.self, value: geo.size.height)
                    })
            }
        }
        .onPreferenceChange(HeightPreferenceKey.self) { height in
            totalHeight = height
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                HStack {
                    content(item)
                    
                    if index < self.data.count - 1 {
                        inBetweenContent()
                    }
                }
                .alignmentGuide(
                    .leading,
                    computeValue: { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= dimension.height + spacing
                        }
                        
                        let result = width
                        if index == data.count - 1 {
                            width = 0
                        } else {
                            width -= dimension.width + spacing
                        }
                        return result
                    }
                )
                .alignmentGuide(
                    .top,
                    computeValue: { _ in
                        let result = height
                        if index == data.count - 1 {
                            height = 0
                        }
                        return result
                    }
                )
            }
        }
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
