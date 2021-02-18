import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    
    @IBOutlet weak var setButton: UIButton!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    weak var delegate: myChangeColorProtocol?
    var colorMainVC: UIColor!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMyDesign()
    }
    
    @IBAction func rgbSliderAction(_ sender: UISlider) {
        switch sender.tag {                                                //выделяем Slider -> Attributes inspector -> View -> Tag
        case 0:
            redLabel.text = strRound(from: sender)
            redTextField.text = strRound(from: sender)
        case 1:
            greenLabel.text = strRound(from: sender)
            greenTextField.text = strRound(from: sender)
        case 2:
            blueLabel.text = strRound(from: sender)
            blueTextField.text = strRound(from: sender)
        case 3:
            break
        default:
            break
        }
        setMainVCColor()
    }
    
    @IBAction func TextFieldAction(_ sender: UITextField) {
        redTextField.keyboardType = .decimalPad
        greenTextField.keyboardType = .decimalPad
        blueTextField.keyboardType = .decimalPad
        textFieldDidEndEditing(sender)
        
    }
    
    @IBAction func setColorAction(_ sender: UIButton) {
        
        delegate?.updateColorView(color: colorMainVC)
        settingSliderValuePreBackground()
        navigationController?.popViewController(animated: true)
    }
    
    func setMyDesign() {
        colorView.layer.cornerRadius = 13                                  //закругление краев
        colorView.layer.borderWidth = 1
        
        setButton.layer.cornerRadius = 13
        setButton.layer.borderWidth = 1
        
        redSlider.tintColor = .red
        greenSlider.tintColor = .green
        alphaSlider.tintColor = .lightGray
        //alphaSlider.maximumTrackTintColor = .darkGray

        colorView.backgroundColor = colorMainVC
        settingSliderValuePreBackground()
        
        setMainVCColor()   //что бы сразу цвета и значения подгрузились
        setBeautifulValueLabelAndTextfield()
        
        addDoneButtonTo(redTextField)
        addDoneButtonTo(greenTextField)
        addDoneButtonTo(blueTextField)
    }
    
    //установка цвета в предпросмотр
    func setMainVCColor() {
        colorMainVC = UIColor(red: CGFloat(redSlider.value),
                              green: CGFloat(greenSlider.value),
                              blue: CGFloat(blueSlider.value),
                              alpha: CGFloat(alphaSlider.value))
        
        colorView.backgroundColor = colorMainVC
    }
    
    //Установка значениев Слайдера в соотвествии с предыдущим фоном
    //Без не цвет передаеться "одним значением" и ставиться в зеленный
    func settingSliderValuePreBackground() {
        let ciColor = CIColor(color: colorMainVC)
        
        redSlider.value = Float(ciColor.red)
        greenSlider.value = Float(ciColor.green)
        blueSlider.value = Float(ciColor.blue)
        alphaSlider.value = Float(ciColor.alpha)
    }

    //установка значения для лейбла и для текстового поля
    func setBeautifulValueLabelAndTextfield() {
        redLabel.text = strRound(from: redSlider)
        greenLabel.text = strRound(from: greenSlider)
        blueLabel.text = strRound(from: blueSlider)
        redTextField.text = strRound(from: redSlider)
        greenTextField.text = strRound(from: greenSlider)
        blueTextField.text = strRound(from: blueSlider)
    }
    
    //преоброзование в строку и сразу округление что бы не писать каждый раз
    func strRound(from slider: UISlider) -> String {
        String(format: "%.0f", slider.value * 255)
    }
}

//Клавиатура и алерты
extension ViewController: UITextFieldDelegate {
    //скрываем клавиатуру по нажатию на "Done"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //скрывает клавиатуру по тапу за пределами TextField (без опционала не работает)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)                                              //скрывает клавиатуру для любого объекта
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if let currentValue = Float(text) {
            if currentValue >= 0 && currentValue <= 255 {
                switch textField.tag {                                        //тоже tag настраиваем
                case 0: redSlider.value = currentValue
                case 1: greenSlider.value = currentValue
                case 2: blueSlider.value = currentValue
                default: break
                }
                setMainVCColor()
                setBeautifulValueLabelAndTextfield()
            } else { showAllert(tittle: "Warning", message: "Попробуй от 0 до 255") }
        } else { showAllert(tittle: "Warning", message: "Только цифры!") }
    }
}

extension ViewController {
    //метод для отображения кнопки "Готово" на цифровой клавиатуре
    func addDoneButtonTo(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        textField.inputAccessoryView = keyboardToolbar
        keyboardToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDone))
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
    
    @objc func didTapDone() {
        view.endEditing(true)
    }
    
    func showAllert(tittle: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Понял понял", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
