//
//  ContentView.swift
//  UIElement
//
//  Created by cl d on 2024/7/28.
//

import SwiftUI

import AppKit
import SwiftUI

class CustomPopUpButtonCell: NSPopUpButtonCell {
  var customArrowImage: NSImage?

  override func drawBorderAndBackground(withFrame cellFrame: NSRect, in controlView: NSView) {
    controlView.layer?.backgroundColor = .white
    controlView.layer?.cornerRadius = 10
  }

  override func drawTitle(_ title: NSAttributedString, withFrame frame: NSRect, in controlView: NSView) -> NSRect {
    debugPrint("title: \(title)")
    var titleRect = super.drawTitle(title, withFrame: frame, in: controlView)

    // 绘制自定义箭头
    if let arrowImage = customArrowImage {
      let arrowSize = NSSize(width: 12, height: 12)
      let arrowRect = NSRect(x: frame.maxX - arrowSize.width - 8,
                             y: frame.midY - arrowSize.height / 2,
                             width: arrowSize.width,
                             height: arrowSize.height)
      arrowImage.draw(in: arrowRect)

      // 调整标题矩形以避免与箭头重叠
      titleRect.size.width -= (arrowSize.width + 12)
    }

    return titleRect
  }
}

struct CustomPopUpButton: NSViewRepresentable {
  @Binding var selection: String
  let options: [String]
  let placeholder: String
  let font: NSFont
  let arrowImage: NSImage?

  func makeNSView(context: Context) -> NSPopUpButton {
    let popUpButton = NSPopUpButton(frame: .zero, pullsDown: false)
    let customCell = CustomPopUpButtonCell(textCell: placeholder)
    customCell.font = font
    customCell.customArrowImage = arrowImage
    customCell.arrowPosition = .noArrow
    popUpButton.cell = customCell

    popUpButton.target = context.coordinator
    popUpButton.action = #selector(Coordinator.selectionChanged(_:))

    updateNSView(popUpButton, context: context)
    return popUpButton
  }

  func updateNSView(_ nsView: NSPopUpButton, context: Context) {
    nsView.removeAllItems()
    nsView.addItems(withTitles: options)

    if selection.isEmpty {
      nsView.selectItem(withTitle: placeholder)
    } else if let index = options.firstIndex(of: selection) {
      nsView.selectItem(at: index)
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject {
    var parent: CustomPopUpButton

    init(_ parent: CustomPopUpButton) {
      self.parent = parent
    }

    @objc func selectionChanged(_ sender: NSPopUpButton) {
      if let selectedItem = sender.selectedItem {
        parent.selection = selectedItem.title
      }
    }
  }
}

struct ContentView: View {
  @State private var selectedOption = ""
  let options = ["Option 1", "Option 2", "Option 3", "Option 4"]

  var body: some View {
    VStack {
      CustomPopUpButton(
        selection: $selectedOption,
        options: options,
        placeholder: "Option 1",
        font: .systemFont(ofSize: 14),
        arrowImage: NSImage(systemSymbolName: "chevron.up.chevron.down", accessibilityDescription: nil)
      )

      Text("Selected option: \(selectedOption)")
        .padding(.top)
    }
    .padding()
  }
}

#Preview {
  ContentView()
    .frame(width: 200, height: 100)
}
