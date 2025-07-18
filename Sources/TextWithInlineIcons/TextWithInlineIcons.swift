// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI
import UIKit

public enum AttributedTextElement {
    case text(String)
    case image(String)
}

public struct TextWithInlineIcons: UIViewRepresentable {
    public let elements: [AttributedTextElement]
    public let textAlignment: NSTextAlignment
    @Environment(\.twiiFontSize) private var fontSize
     @Environment(\.twiiImageWidth) private var imageWidth
     @Environment(\.twiiImageHeight) private var imageHeight
    private var maxWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public init(elements: [AttributedTextElement], textAlignment: NSTextAlignment = .right) {
          self.elements = elements
          self.textAlignment = textAlignment
      }
    

    public func makeUIView(context: Context) -> UITextView {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
       
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.widthTracksTextView = true
        textView.textAlignment = textAlignment
        textView.setContentHuggingPriority(.required, for: .vertical)
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
                    textView.widthAnchor.constraint(equalToConstant: 100)
                ])
        return textView
    }

    public func updateUIView(_ textView: UITextView, context: Context) {
        let font = UIFont.systemFont(ofSize: fontSize)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = textAlignment

        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.gray
        ]

        let lines = buildLines(elements: elements, font: font, maxWidth: maxWidth)
        

        let result = NSMutableAttributedString()

        for lineElements in lines {
            for element in lineElements {
                switch element {
                case .text(let string):
                    result.append(NSAttributedString(string: string, attributes: attrs))
                case .image(let imageName):
                    guard let image = UIImage(named: imageName) else {
                        print("⚠️ Image not found: \(imageName)")
                        continue
                    }
                    result.append(NSAttributedString(string: " ", attributes: attrs))
                    let attachment = NSTextAttachment()
                    attachment.image = image
                    attachment.bounds = CGRect(x: 0, y: -2, width: imageWidth, height: imageHeight)
                    let attachmentString = NSAttributedString(attachment: attachment)
                    let imageAttrString = NSMutableAttributedString(attributedString: attachmentString)
                    imageAttrString.addAttributes([.baselineOffset: -1], range: NSRange(location: 0, length: imageAttrString.length))
                    result.append(imageAttrString)
                    result.append(NSAttributedString(string: " ", attributes: attrs))
                }
            }
            result.append(NSAttributedString(string: "\n", attributes: attrs))
        }

        textView.attributedText = result
    }

    private func widthOfString(_ string: String, font: UIFont) -> CGFloat {
        return (string as NSString).size(withAttributes: [.font: font]).width
    }
    private func buildLines(elements: [AttributedTextElement], font: UIFont, maxWidth: CGFloat) -> [[AttributedTextElement]] {
        var lines: [[AttributedTextElement]] = []
        var currentLine: [AttributedTextElement] = []
        var currentLineWidth: CGFloat = 0

        for element in elements {
            let elementWidth: CGFloat

            switch element {
            case .text(let str):
                let words = str.components(separatedBy: " ")
                for (index, word) in words.enumerated() {
                    let wordWidth = widthOfString(word + (index < words.count - 1 ? " " : ""), font: font)
                    if currentLineWidth + wordWidth > maxWidth {
                        if !currentLine.isEmpty {
                            lines.append(currentLine)
                        }
                        currentLine = [.text(word + (index < words.count - 1 ? " " : ""))]
                        currentLineWidth = wordWidth
                    } else {
                        currentLine.append(.text(word + (index < words.count - 1 ? " " : "")))
                        currentLineWidth += wordWidth
                    }
                }
                continue

            case .image(_):
                elementWidth = 13 + widthOfString("  ", font: font)
                if currentLineWidth + elementWidth > maxWidth {
                    if !currentLine.isEmpty {
                        lines.append(currentLine)
                    }
                    currentLine = [element]
                    currentLineWidth = elementWidth
                } else {
                    currentLine.append(element)
                    currentLineWidth += elementWidth
                }
            }
        }

        if !currentLine.isEmpty {
            lines.append(currentLine)
        }

        return lines
    }
}




// MARK: - Environment Keys
private struct TWII_FontSizeKey: EnvironmentKey {
    static let defaultValue: CGFloat = 16
}
private struct TWII_ImageWidthKey: EnvironmentKey {
    static let defaultValue: CGFloat = 16
}
private struct TWII_ImageHeightKey: EnvironmentKey {
    static let defaultValue: CGFloat = 16
}


extension EnvironmentValues {
    var twiiFontSize: CGFloat {
        get { self[TWII_FontSizeKey.self] }
        set { self[TWII_FontSizeKey.self] = newValue }
    }

    var twiiImageWidth: CGFloat {
        get { self[TWII_ImageWidthKey.self] }
        set { self[TWII_ImageWidthKey.self] = newValue }
    }

    var twiiImageHeight: CGFloat {
        get { self[TWII_ImageHeightKey.self] }
        set { self[TWII_ImageHeightKey.self] = newValue }
    }

}

// MARK: - Modifiers
public extension View {
    func twiiFontSize(_ size: CGFloat) -> some View {
        self.environment(\.twiiFontSize, size)
    }

    func twiiImageSize(width: CGFloat, height: CGFloat) -> some View {
        self
            .environment(\.twiiImageWidth, width)
            .environment(\.twiiImageHeight, height)
    }
}
