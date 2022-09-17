//
//  File.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//


import SwiftUI

struct LoadingSpinner: View {

  @State private var rotate = false
  
  private let outerDiamiter: CGFloat = 40
  private let innerDiamiter: CGFloat = 35
  
  var body: some View {
    ZStack {
      Circle()
        .fill(AngularGradient(colors: [.white, .gray], center: .center))
        .frame(width: outerDiamiter, height: outerDiamiter)
        .rotationEffect(Angle.degrees(rotate ? 360 : 0))
        .animation(.linear.repeatForever(autoreverses: false), value: rotate)
      Circle()
        .fill(Color(uiColor: .systemBackground))
        .frame(width: innerDiamiter, height: innerDiamiter)
    }
    .onAppear() { self.rotate.toggle() }
  }
}

struct LoadingSpinner_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSpinner()
    }
}
