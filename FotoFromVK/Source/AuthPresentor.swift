import VK_ios_sdk
import Alamofire

class AuthPresentor {
    
    func photoRequest(token: String?) {
        
        let reqURL = "https://api.vk.com/method/photos.getAll?count=200&access_token=\(token!)&v=5.92"
        print("URL \(reqURL)")
        
        request(reqURL).validate()
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let value):
                    var urls: [String] = []
                    let json = value as! [String: Any]
                    let response = json["response"] as! [String: Any]
                    let items = response["items"] as! [[String: Any]]
                    for element in items {
                        let sizes = element["sizes"] as! [[String: Any]]
                        let urlPhoto = sizes.last!
                        urls.append(urlPhoto["url"] as! String)
                    }
                    self.const_urls = urls
                    self.goToPhotoVC(arr: urls)
                    
                case .failure(let error):
                    print(error)
                    
                    self.photoRequest(token: token)            //<- костыль
                }
            }
            
            .downloadProgress { (progress) in
                self.progress.setProgress(Float(progress.fractionCompleted), animated: true)
        }
    }
    
}
