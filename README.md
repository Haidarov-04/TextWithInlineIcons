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
            TextWithInlineIcons(elements: textElements, textAlignment: .left)
                 .twiiFontSize(16)
                 .twiiImageSize(width: 20, height: 20)
        }
        .padding(30)
        
    }
}

```
<img width="414" height="808" alt="Screenshot 2025-07-18 at 13 59 58" src="https://github.com/user-attachments/assets/146ff852-9b47-4ea4-b730-5953dac04cc9" />


