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
    private var topPadding: CGFloat = 0
    private var bottomPadding: CGFloat = 0
    private var leftPadding: CGFloat = 0
    private var rightPadding: CGFloat = 0
    private var maxWidth: CGFloat {
        return UIScreen.main.bounds.width - self.leftPadding - self.rightPadding
    }
    private var imageWidth: CGFloat = 13
    private var imageHeight: CGFloat = 13
    private var fontSize: CGFloat = 13
    
    public init(elements: [AttributedTextElement]) {
        self.elements = elements
    }
    

    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.widthTracksTextView = true
        textView.textAlignment = .left
        textView.setContentHuggingPriority(.required, for: .vertical)
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        return textView
    }

    public func updateUIView(_ textView: UITextView, context: Context) {
        let font = UIFont.systemFont(ofSize: fontSize)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .left

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

public extension TextWithInlineIcons {
    func fontSize(_ size: CGFloat) -> TextWithInlineIcons {
        var copy = self
        copy.fontSize = size
        return copy
    }

    func imageSize(width: CGFloat, height: CGFloat) -> TextWithInlineIcons {
        var copy = self
        copy.imageWidth = width
        copy.imageHeight = height
        return copy
    }

    func paddingTWII(_ value: CGFloat) -> TextWithInlineIcons {
        var copy = self
        copy.topPadding = value
        copy.bottomPadding = value
        copy.leftPadding = value
        copy.rightPadding = value
        return copy
    }

    func paddingTWII(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> TextWithInlineIcons {
        var copy = self
        copy.leftPadding = horizontal
        copy.rightPadding = horizontal
        copy.topPadding = vertical
        copy.bottomPadding = vertical
        return copy
    }

    func paddingTWII(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) -> TextWithInlineIcons {
        var copy = self
        copy.topPadding = top
        copy.bottomPadding = bottom
        copy.leftPadding = left
        copy.rightPadding = right
        return copy
    }
}
