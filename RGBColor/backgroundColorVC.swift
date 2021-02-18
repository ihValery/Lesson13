import UIKit

protocol myChangeColorProtocol: class {
    func updateColorView(color: UIColor)
}

class backgroundColorVC: UIViewController, myChangeColorProtocol {
 
    @IBOutlet weak var myViewForBackgroundWhite: UIView!
    @IBOutlet weak var getButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMyDesign()
    }
    
    @IBAction func getColorBttnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewCintroller = storyboard.instantiateViewController(identifier: "ViewControllerSB") as? ViewController else { return }
        viewCintroller.colorMainVC = myViewForBackgroundWhite.backgroundColor
        //Назначить делегата
        viewCintroller.delegate = self
    
        show(viewCintroller, sender: nil)
    }
    
    func setMyDesign() {
        getButton.layer.cornerRadius = 13
        getButton.layer.borderWidth = 1
    }
    
    func updateColorView(color: UIColor) {
        myViewForBackgroundWhite.backgroundColor = color
    }
}
