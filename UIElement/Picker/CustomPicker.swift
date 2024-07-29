//
//  CustomPicker.swift
//  UIElement
//
//  Created by cl d on 2024/7/28.
//

import AppKit
import Foundation
import SwiftUI

struct CustomPicker: View {
  @State private var selectedStrength = "Mild"
  let strengths = ["Mild", "Medium", "Mature"]

  var body: some View {
    VStack {
      Picker("Strength", selection: $selectedStrength) {
        ForEach(strengths, id: \.self) {
          Text($0)
        }
      }
      .pickerStyle(PopUpButtonPickerStyle())
      .accentColor(.blue)
      .font(.headline) // 改变字体

      RealCustomPicker("Strength", selection: $selectedStrength) {
        ForEach(strengths, id: \.self) {
          Text($0)
        }
      }
    }
  }
}

struct RealCustomPicker<SelectionValue: Hashable, Content: View>: View {
  let titleString: String
  let content: Content
  let selection: Binding<SelectionValue>
  
  @State private var tapped = false

  init(_ title: String, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
    self.content = content()
    self.selection = selection
    self.titleString = title
  }

  var body: some View {
    HStack {
      Text(titleString)
      
      HStack {
        Text("\(selection.wrappedValue)")
      }
      .onTapGesture {
        tapped.toggle()
      }
    }
    
    .sheet(isPresented: $tapped) {
      content
    }
  }
}

#Preview {
  CustomPicker()
}
