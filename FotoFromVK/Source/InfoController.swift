
import UIKit
import VK_ios_sdk
import Alamofire

class InfoController: UIViewController {
    let token = VKSdk.accessToken()?.accessToken
    let aid = 260284257   //album id "test album"
    
    func resUploadReq(result: URL) {
        
        request(result).validate()
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(_):
                    
                    print("SuccessUpload")
                    self.progressBar.progress = 0
                    self.progressBar.isHidden = true
                    
                case .failure(let error):
                
                    print(error)
                    self.resUploadReq(result: result)
                }
        }
    }
    
    func uploadReq(uploadRequest: UploadRequest) {
        uploadRequest.validate().responseJSON() { responseJSON in
            switch responseJSON.result {
            case .success(let value):
                let result = self.parseRequestUpload(json: value as! [String: Any])
                
                self.resUploadReq(result: result)
                
            case .failure(let error):
                print(error)
                self.uploadReq(uploadRequest: uploadRequest)
            }
        }
    }
    
    
    func uploadImages(uploadURL: URL, img: UIImage) {

        //let data = img.pngData()!
        guard let data = img.pngData() else { return }
        
        self.progressBar.isHidden = false
        
        upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(data, withName: "file1", fileName: "image.jpg", mimeType: "image/jpeg")
            
        }, to: uploadURL) { (encodingResult) in
            switch encodingResult {
            case .success(let uploadRequest, _, _):
                uploadRequest.uploadProgress(closure: { (Progress) in
                    self.progressBar.progress = Float(Progress.fractionCompleted)
                })
                self.uploadReq(uploadRequest: uploadRequest)

            case .failure(let error):
                print(error)
                self.uploadImages(uploadURL: uploadURL, img: img)
            }
        }
    }
    
    func startUploadImages(aid: Int, img: UIImage){
        let resp = URL(string: "https://api.vk.com/method/photos.getUploadServer?album_id=\(aid)&access_token=\(token!)&v=5.92")!

        request(resp).validate()
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let value):
                    let response = value as! [String: Any]
                    let json = response["response"] as! [String: Any]

                    self.uploadImages(uploadURL: URL(string: json["upload_url"] as! String)!, img: img)

                case .failure(let error):
                    self.startUploadImages(aid: aid, img: img)
                    print(error)

                }
            }
    }
    
    func parseRequestUpload(json: [String: Any]) -> URL {
        
        let domain = "https://api.vk.com"
        let path = "/method/photos.save"
        let queryItems = [
            URLQueryItem(name: "album_id", value: (json["aid"] as? Int).flatMap { String($0) } ),    
            URLQueryItem(name: "server", value: (json["server"] as? Int).flatMap { String($0) } ),
            URLQueryItem(name: "photos_list", value: json["photos_list"] as? String),
            URLQueryItem(name: "hash", value: json["hash"] as? String),
            URLQueryItem(name: "access_token", value: self.token),
            URLQueryItem(name: "v", value: "5.92")
        ]
        
        var site = URLComponents(string: domain)
        site?.path = path
        site?.queryItems = queryItems
        
        return (site?.url)!
    }
    
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    @IBAction func uploadFoto(_ sender: Any) {
        
        let imagePicker = UIImagePickerController() // 1
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
   
    }
    
    
    @IBAction func Logout(_ sender: Any) {
        VKSdk.forceLogout()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.popToRootViewController(animated: true)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressBar.progress = 0
        self.progressBar.isHidden = true
    
    }

    func goToPhotoVC(arr: [String]) {
        
        let queue = DispatchQueue.global(qos: .utility)
        
        DispatchQueue.main.async {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = story.instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
            
            queue.sync {
                
                mainVC.arrPhoto = arr
            }
            
            self.navigationController?.pushViewController(mainVC, animated: true)
        }
        
    }
    
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

                    self.goToPhotoVC(arr: urls)
                    
                case .failure(let error):
                    print(error)
                    
                    self.photoRequest(token: token)            //<- костыль
                }
            }
    }
    
    
    @IBAction func reloadPhoto(_ sender: Any) {
        
        photoRequest(token: token)
    }
}

    

extension InfoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageFromPC = info[UIImagePickerController.InfoKey.originalImage] as! UIImage // 1
        startUploadImages(aid: aid, img: imageFromPC)
        self.dismiss(animated: true, completion: nil) // 3
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
