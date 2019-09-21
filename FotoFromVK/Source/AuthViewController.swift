
import UIKit
import VK_ios_sdk
import Alamofire

class AuthViewController: UIViewController {
    
    let permission = ["email", "photos", "wall", "offline", "friends", "groups"]
    var const_urls: [String] = []
    
    
    func goToPhotoVC(arr: [String]) {
        
        let queue = DispatchQueue.global(qos: .utility)
        
        DispatchQueue.main.async {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = story.instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
            
            queue.sync {
                
                mainVC.arrPhoto = arr
            }
            self.authButton.isHidden = false
            self.loading.isHidden = true
            
            self.navigationController?.pushViewController(mainVC, animated: false)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sdkInst = VKSdk.initialize(withAppId: "6748800")
        sdkInst?.register(self)
        sdkInst?.uiDelegate = self
        
        DispatchQueue.main.async {
            self.navigationItem.hidesBackButton = true
            self.authButton.isHidden = true
            self.authButton.layer.cornerRadius = 5
            self.progress.setProgress(0, animated: false)
            self.progress.isHidden = true
            self.loading.startAnimating()
            self.mainImage.image = UIImage(named: "vk")
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        VKSdk.wakeUpSession(permission, complete:  { [weak self] (state, error) -> Void in
            
            guard let sself = self else { return }
            
            if (state == VKAuthorizationState.authorized){
                
                sself.photoRequest(token: VKSdk.accessToken()?.accessToken)
            } else {
                
                print("Error \(String(describing: error))")
                DispatchQueue.main.async {
                    sself.authButton.isHidden = false
                    sself.loading.isHidden = true
                }
            }
        })

    }
    //MARK: Outlets
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var authButton: UIButton!
    
    //MARK: Actions
    @IBAction func pushButton(_ sender: Any) {
        
        self.authButton.isHidden = true
        self.loading.isHidden = false
        VKSdk.authorize(self.permission)
    }
}

//MARK: Extension
extension AuthViewController: VKSdkDelegate, VKSdkUIDelegate  {
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("vkSdkNeedCaptchaEnter")
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            
            self.photoRequest(token: VKSdk.accessToken()?.accessToken)
        } else {
            DispatchQueue.main.async {
                
                self.authButton.isHidden = false
                self.loading.isHidden = true
            }
        }
    }
    
    func vkSdkAccessAuthorizationFinishedWithResult(result:VKAuthorizationResult?) {
        print("vkSdkAccessAuthorizationFinishedWithResult", result?.token as Any)
    }
    
    func vkSdkUserAuthorizationFailed() -> Void {
        print("vkSdkUserAuthorizationFailed")
    }
    
    func vkSdkAuthorizationStateUpdatedWithResult(with result: VKAuthorizationResult) -> Void {
        print("vkSdkAuthorizationStateUpdatedWithResult")
    }
    
    func vkSdkAccessTokenUpdated(newToken: VKAccessToken?, oldToken: VKAccessToken?) -> Void {
        print("vkSdkAuthorizationStateUpdatedWithResult")
    }
    
    func vkSdkTokenHasExpired(expiredToken: VKAccessToken?) -> Void {
        print("vkSdkTokenHasExpired")
}
    
}


//Загрузка картинок в VK.     +
//push msg                    -
//Прочитать про weak          +
//ObjectMapper                - Реализовать в программе
//MVP || MVVM архитектуры     - Реализовать в программе(MVP)
//pusher
//In app Purchase
//.flatMap?
//guard                       +
