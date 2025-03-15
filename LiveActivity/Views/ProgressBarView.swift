//
//  ProgressBarView.swift
//  LiveActivity-Sample
//
//  Created by KavinduDissanayake on 2025-03-09.
//
import SwiftUI
import WidgetKit

// MARK: - ProgressBarView Component
struct ProgressBarView: View {
    let progress: CGFloat

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 5)
                .foregroundColor(.gray.opacity(0.3))
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: max(progress * 3, 0), height: 5)
                .foregroundColor(.green)
                .animation(.easeInOut(duration: 1.5), value: progress)
            
            Image(.icCarIcon)
                .resizable()
                .frame(width: 40, height: 17)
                .offset(x: min(max(progress * 3 - 15, 0), UIScreen.main.bounds.width - 50)) // Ensures car stays within bounds
                .animation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.5), value: progress)
        }
    }
}

// MARK: - Previews
struct ProgressBarViewPreviews: PreviewProvider {

  static var previews: some View {
    VStack {
        ProgressBarView(progress: 60)
            .widgetBackground(Color.black)

    }
    .previewContext(WidgetPreviewContext(family: .systemLarge))
  }
}
