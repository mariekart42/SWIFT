import Foundation

struct CatFactDTO : Decodable {
    let fact : String?
    let len : Int?
}

enum MyError : Error {
    case badUrl
    case otherError
    case jsonDecodeError
}

extension ViewModel {
    func buttonDidPressed() {
        self.getWeather(handler: { result in
            switch result {
            case .success(let res):
                self.catDTO = res
            case .failure(let err):
                self.textLabelValue = err.localizedDescription
            }
        })
    }
    
    
    func getWeather(handler : @escaping (Result<CatFactDTO,MyError>) -> Void) {
        let urlString = "https://catfact.ninja/fact"
        let urlOptional = URL(string: urlString)
        guard let url = urlOptional else {
            handler(.failure(.badUrl))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data,response,error in
            DispatchQueue.main.async {
            if let error = error {
                print("error")
                handler(.failure(.otherError))
            } else {
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(CatFactDTO.self, from: data)
                        handler(.success(res))
                    }
                    catch {
                        handler(.failure(.jsonDecodeError))
                    }
                   
                }
            }
            }
        }
        task.resume()
    }
}
