# TextWithInlineIcons

Swift Package для отображения текста с иконками внутри, с поддержкой автоматического переноса строк и настраиваемыми отступами, размером шрифта и иконок.

## Особенности

- Отображение текста с встроенными иконками (через enum `AttributedTextElement`)
- Автоматический перенос строк с учетом ширины контейнера
- Настраиваемые отступы (padding), размер шрифта и размер иконок
- Простое использование в SwiftUI через UIViewRepresentable

## Установка

Через Swift Package Manager добавь URL репозитория в Xcode:
https://github.com/Haidarov-04/TextWithInlineIcons


## Пример использования

```swift
import SwiftUI
import TextWithInlineIcons

struct ContentView: View {
    let textElements: [AttributedTextElement] = [
        .text("TextWithInlineIcons "),
        .image("logo"),
        .text(" — это легкий и гибкий компонент для SwiftUI"),
        .image("Swiftui"),
        .text(", который позволяет отображать смешанный контент из текста и иконок, при этом автоматически управляя переносом строк и выравниванием. Такой подход делает интерфейс вашего приложения более выразительным и информативным."),
    ]
    var body: some View {
        VStack{
            TextWithInlineIcons(elements: textElements)
                .paddingTWII(10)
                .fontSize(20)
                .imageSize(width: 20, height: 20)
        }
        
    }
}

```
<img width="441" height="803" alt="Screenshot 2025-07-17 at 11 37 25" src="https://github.com/user-attachments/assets/266b4f36-5618-41ab-b73d-3ada48460ff5" />

