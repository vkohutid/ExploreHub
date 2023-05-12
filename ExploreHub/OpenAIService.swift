//
//  OpenAIService.swift
//  ExploreHub
//
//  Created by Vitalii Kohut on 11.05.2023.
//

import Foundation
import Alamofire
import Combine

class OpenAIService {
    let baseUrl = "https://api.openai.com/v1/"
    
    func sendMessage(message: String) -> AnyPublisher<OpenAICompletionsResponse, Error> {
        let body = OpenAICompletionsBody(model: "text-davinci-003", prompt: message, temperature: 0.7, max_tokens: 2048, stream: false)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIAPIKey)"]
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            AF.request(self.baseUrl + "completions", method: .post, parameters: body, encoder: .json, headers: headers)
                .responseDecodable(of: OpenAICompletionsResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        promise(.success(result))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func sendMessageAsync(message: String) -> AnyPublisher<OpenAICompletionsResponse, Error> {
        let body = OpenAICompletionsBody(model: "text-davinci-003", prompt: message, temperature: 0.7, max_tokens: 2048, stream: true)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIAPIKey)"]
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            AF.streamRequest(self.baseUrl + "completions", method: .post, parameters: body, encoder: .json, headers: headers).responseStreamString { stream in
                switch stream.event {
                case let .stream(result):
                    switch result {
                    case let .success(string):
                        print(string)
                    }
                case let .complete(completion):
                    print(completion)
                }
            }
        }
        .eraseToAnyPublisher()
    }
}


struct OpenAICompletionsBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int
    let stream: Bool
}


struct OpenAICompletionsResponse: Decodable {
    let id: String
    let choices: [OpenAICompletionsChoice]
}

struct OpenAICompletionsChoice: Decodable {
    let text: String
}
