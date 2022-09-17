//
//  ExpandableText.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import SwiftUI

struct ButtonAttributes {
  let text: NSAttributedString
  let color: Color
  
  let font: Font = .body
  
  init(text: String, color: Color) {
    self.text = NSAttributedString(string: text)
    self.color = color
  }
}



struct ExpandableText: View {
  
  let text: String
  
  @State private var isExpanded = false
  
  var attributedText: AttributedString {
    return AttributedString(text)
  }
  
  var font: Font = .body
  var lineLimit = 3
  var foregroundColor: Color = .primary
  var animation: Animation = .easeInOut
  
  let expandButtonAttributes = ButtonAttributes(text: "More", color: .blue)
  let collapseButtonAttributes = ButtonAttributes(text: "less", color: .purple)
  
  var body: some View {
      ZStack(alignment: .bottomTrailing) {
        Text(attributedText)
          .font(font)
          .lineLimit(isExpanded ? nil : lineLimit)
          .foregroundColor(foregroundColor)
          .animation(animation, value: isExpanded)
          .mask {
            VStack(spacing: 0) {
              Rectangle()
              HStack(alignment: .bottom, spacing: 0) {
                Rectangle()
                LinearGradient(gradient: Gradient(stops: [Gradient.Stop(color: .black, location: 0),
                                                          Gradient.Stop(color: .clear, location: 0.85)]),
                               startPoint: .leading,
                               endPoint: .trailing)
              }
              .frame(height: expandButtonAttributes.text.size().height * 1.2)
            }
          }
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity, alignment: .topLeading)
        if text != "" {
          Button(action: {
            isExpanded.toggle()
          }) {
            Text(isExpanded ? collapseButtonAttributes.text.string : expandButtonAttributes.text.string)
              .foregroundColor(isExpanded ? collapseButtonAttributes.color : expandButtonAttributes.color)
              .font(font)
              .padding([.trailing], 5)
          }
        }
      }
    }
}


extension ExpandableText {
  
  public func font(_ font: Font) -> ExpandableText {
    var updatedText = self
    updatedText.font = font
    return updatedText
  }
  
  public func lineLimt(_ int: Int) -> ExpandableText {
    var updatedText = self
    updatedText.lineLimit = int
    return updatedText
  }
  
  public func foregroundColor(_ color: Color) -> ExpandableText {
    var updatedText = self
    updatedText.foregroundColor = color
    return updatedText
  }
  
  public func animation(_ animation: Animation) -> ExpandableText {
    var updatedText = self
    updatedText.animation = animation
    return updatedText
  }
  
}
