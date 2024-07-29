//
//  DebugAnimations.swift
//  UIElement
//
//  Created by cl d on 2024/7/28.
//

import SwiftUI

struct ConstantAnimation: CustomAnimation {
  var progress: Double
  func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V: VectorArithmetic {
    print(value)
    return value.scaled(by: progress)
  }

  func shouldMerge<V>(previous: Animation, value: V, time: TimeInterval, context: inout AnimationContext<V>) -> Bool where V: VectorArithmetic {
    return true
  }
}

struct DebugAnimation<Value: Equatable>: ViewModifier {
  @Binding var state: Value
  var from, to: Value
  @State private var progress: Double = 0

  func body(content: Content) -> some View {
    let anim = Animation(ConstantAnimation(progress: progress))
    content
      .animation(anim, value: state)
      .onChange(of: progress) {
        state = from
        withAnimation {
          state = to
        }
      }
      .overlay(alignment: .bottom) {
        Slider(value: $progress, in: 0 ... 1)
          .frame(width: 200, height: 3)
          .alignmentGuide(.bottom, computeValue: { dimension in
            dimension[.top]
          })
      }
  }
}

struct DebugAnimations: View {
  @Namespace var ns
  @State private var tapCount = 0

  var body: some View {
    let toggle = tapCount.isMultiple(of: 2)
    VStack {
      if toggle {
        Color.red
          .matchedGeometryEffect(id: "ID", in: ns)
          .frame(width: 50, height: 50)
      } else {
        Color.blue
          .matchedGeometryEffect(id: "ID", in: ns)
          .frame(width: 100, height: 100)
          .transition(.opacity.combined(with: .slide))
      }
    }
    .frame(height: 300)
    .frame(maxWidth: .infinity, alignment: toggle ? .leading : .trailing)
    .background {
      Text("Hello")
        .font(.largeTitle)
    }
    .modifier(DebugAnimation(state: $tapCount, from: 0, to: 1))
    .padding()
  }
}

#Preview {
  DebugAnimations()
}
