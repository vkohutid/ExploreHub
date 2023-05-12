//
//  ChatView.swift
//  ExploreHub
//
//  Created by Vitalii Kohut on 11.05.2023.
//

import SwiftUI
import Combine

struct ChatView: View {
    @Binding var mainTitle : String

    @State var chatMessages: [ChatMessage] = []
    @State var messageText: String = ""
    @State var cancellables = Set<AnyCancellable>()
    
    @FocusState private var isFocused: Bool
    let openAIService = OpenAIService()
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(chatMessages) { message in
                            messageView(message: message)
                                .id(message.id)
                        }
                    }
                }
                .onTapGesture {
                    isFocused = false
                }
                .onChange(of: chatMessages.count, perform: { _ in
                    proxy.scrollTo(chatMessages.last?.id)
                })
            }
            HStack {
                TextField("Enter a message", text: $messageText)
                    .focused($isFocused)
                    .padding(12)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(12)
                Button {
                    sendMesasge()
                } label: {
                    Text("Send")
                        .foregroundColor(messageText.isEmpty ? .gray.opacity(0.5) : .white)
                        .padding(12)
                        .background(.blue.opacity(0.5))
                        .cornerRadius(12)
                }
                .disabled(messageText.isEmpty)
                
            }
        }
        .padding()
        .onAppear {
            mainTitle = "Chat"
        }
    }
    
    func messageView(message: ChatMessage) -> some View {
        HStack {
            if message.sender == .me { Spacer()}
            Text(message.content)
                .foregroundColor(message.sender == .me ? .white : .black)
                .padding()
                .background(message.sender == .me ? .blue.opacity(0.7) : .gray.opacity(0.1))
                .cornerRadius(16)
            if message.sender == .gpt { Spacer()}
            
        }
    }
    
    
    func sendMesasge() {
        let myMessage = ChatMessage(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .me)
        chatMessages.append(myMessage)
        openAIService.sendMessage(message: messageText).sink { completion in
            // Handle error
        } receiveValue: { response in
            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            let gptMessage = ChatMessage(id: UUID().uuidString, content: textResponse, dateCreated: Date(), sender: .gpt)
            print(response.choices)
            
            chatMessages.append(gptMessage)
        }
        .store(in: &cancellables)
        
        messageText = ""
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView( mainTitle: .constant("Chat"), chatMessages: ChatMessage.sampleMessages)
    }
}


struct ChatMessage: Identifiable {
    let id: String
    var content: String
    let dateCreated: Date
    let sender: MessageSender
    
    mutating func appendToContent(character: String) -> Void {
        self.content = content+character
    }
}

enum MessageSender  {
    case me
    case gpt
}


extension ChatMessage {
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "Sample Message From Me", dateCreated: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Sample Message From GPT", dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Sample Message From Me", dateCreated: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Sample Message From GPT", dateCreated: Date(), sender: .gpt)
    ]
}


enum Constants {
    static let openAIAPIKey = "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"
}
