import UIKit

protocol MyChangeColorProtocol: class {
    func updateColorView(color: UIColor)
}

//UpperCamelCase не забываем!
class BackgroundColorVC: UIViewController {
 
    @IBOutlet weak var myViewForBackgroundWhite: UIView!
    @IBOutlet weak var getButton: UIButton!
    
    @IBAction func getColorBttnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewCintroller = storyboard.instantiateViewController(identifier: "ViewControllerSB") as? ViewController else { return }
        viewCintroller.colorMainVC = myViewForBackgroundWhite.backgroundColor
        // (2) Назначить делегата
        viewCintroller.delegate = self
    
        show(viewCintroller, sender: nil)
    }
}

// (1) Подписываем класс через расширение:
//      Лучше выглядит (когда много протоколов)
//      Сразу легко понять какие (3) методы обязательны ))
extension BackgroundColorVC: MyChangeColorProtocol {
    func updateColorView(color: UIColor) {
        myViewForBackgroundWhite.backgroundColor = color
    }
}
