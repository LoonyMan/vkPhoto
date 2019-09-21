
import UIKit
import Alamofire
import VK_ios_sdk

class CheckVC: UIViewController {
//    //MARK: Variable
//    @IBOutlet weak var progressBar: UIProgressView!
//    @IBOutlet weak var progressLabel: UILabel!
//
//    var permission = ["photos"]
//
////    func goToAuthVC() {
////        DispatchQueue.main.async {
////            let story = UIStoryboard(name: "Main", bundle: nil)
////            let VC = story.instantiateViewController(withIdentifier: "AuthVC")
////
////            self.navigationController?.pushViewController(VC, animated: true)
////        }
////    }
////    https://api.vk.com/method/METHOD_NAME?PARAMETERS&access_token=ACCESS_TOKEN&v=V
////    func takePhotos() {
////        var token = VKSdk.accessToken()
////        print(token)
////        var urlRequest = "https://api.vk.com/method/photos.getAll?count=200&access_token=\(token)&v=5.92 "
////        //request(<#T##url: URLConvertible##URLConvertible#>)
////    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //MARK: Поднятие сессии
//        VKSdk.wakeUpSession(permission, complete: {(state, error) -> Void in
//            if (state == VKAuthorizationState.authorized) {
//                print("Session is alive")
//                //self.takePhotos()
//            } else if ((error) != nil) {
//                print(error as Any)
//            } else {
//                //self.goToAuthVC()
//            }
//
//        })
//
//    }
//
}


// Из-за этих протоколов, CheckVC не уходил из памяти, в следствии чего происходила "рекурсивная авторизация" при частых logout'ах
//
//extension CheckVC: VKSdkDelegate, VKSdkUIDelegate {
//    //Функции VK
//    func vkSdkShouldPresent(_ controller: UIViewController!) {
//        print("vkSdkShouldPresent")
//        self.present(controller, animated: true, completion: nil)
//    }
//
//    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
//        print("vkSdkNeedCaptchaEnter")
//    }
//
//    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
//        print("TokenMain ->", result.token)
//        if result.token != nil {
//            self.reqPhoto()
//        }
//
//    }
//
//
//    func vkSdkAccessAuthorizationFinishedWithResult(result:VKAuthorizationResult?) {
//        print("vkSdkAccessAuthorizationFinishedWithResult", result?.token as Any)
//    }
//
//    func vkSdkUserAuthorizationFailed() -> Void {
//        print("vkSdkUserAuthorizationFailed")
//    }
//
//    func vkSdkAuthorizationStateUpdatedWithResult(with result: VKAuthorizationResult) -> Void {
//        print("vkSdkAuthorizationStateUpdatedWithResult")
//    }
//
//    func vkSdkAccessTokenUpdated(newToken: VKAccessToken?, oldToken: VKAccessToken?) -> Void {
//        print("vkSdkAuthorizationStateUpdatedWithResult")
//    }
//
//    func vkSdkTokenHasExpired(expiredToken: VKAccessToken?) -> Void {
//        print("vkSdkTokenHasExpired")
//    }
//}
