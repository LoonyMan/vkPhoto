
import UIKit

class ZoomPhotoController: UIViewController {

    var photo: String = ""
    
    @IBOutlet weak var imagePhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePhoto.kf.setImage(with: URL(string: photo))
    }
    
}
