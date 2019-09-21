
import UIKit
import Kingfisher
import Alamofire
import VK_ios_sdk

class PhotoViewController: UICollectionViewController {
    let token = VKSdk.accessToken()?.accessToken
    var arrPhoto: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            
            self.navigationItem.hidesBackButton = true
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrPhoto.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        
        DispatchQueue.main.async {
            
            cell.activity.isHidden = false
            cell.activity.startAnimating()
            cell.backgroundColor = #colorLiteral(red: 0.8681824287, green: 0.8681824287, blue: 0.8681824287, alpha: 1)
            cell.photoVK.kf.setImage(with: URL(string: self.arrPhoto[indexPath.row]))
            cell.activity.stopAnimating()
            cell.activity.isHidden = true
        }
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let queue = DispatchQueue.global(qos: .utility)
        DispatchQueue.main.async {
            
            let story = UIStoryboard(name: "Main", bundle: nil)
            let VC = story.instantiateViewController(withIdentifier: "ZoomVC") as! ZoomPhotoController
            queue.sync {
                
                VC.photo = self.arrPhoto[indexPath.row]
            }
            
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func about(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            let story = UIStoryboard(name: "Main", bundle: nil)
            let VC = story.instantiateViewController(withIdentifier: "AboutVC")
            
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    
}
