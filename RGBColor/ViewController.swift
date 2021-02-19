import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    
    @IBOutlet weak var setButton: UIButton!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    // (4) Создаем слабую ссылку на протокол (Протокол должен быть AnyObject)
    weak var delegate: MyChangeColorProtocol?
    var colorMainVC: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMyDesign()
    }
    
    //Свитч для дергания слайдов (элегантно через tag - запоминаем работаем)
    @IBAction func rgbSliderAction(_ sender: UISlider) {
        //выделяем Slider -> Attributes inspector -> View -> Tag
        switch sender.tag {
        case 0:     redTextField.text = strRound(from: sender)
        case 1:     greenTextField.text = strRound(from: sender)
        case 2:     blueTextField.text = strRound(from: sender)
        default:    break
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
        // (5) Вызываем метод делегата
        delegate?.updateColorView(color: colorMainVC)
        settingSliderValuePreBackground()
        navigationController?.popViewController(animated: true)
    }
    
    func setMyDesign() {
        colorView.layer.cornerRadius = 13
        
        redSlider.tintColor = .red
        greenSlider.tintColor = .green
        alphaSlider.tintColor = .lightGray
        
        
        let myColor = UIColor.white
        redTextField.layer.borderColor = myColor.cgColor
        redTextField.layer.borderColor = myColor.cgColor
        
        colorView.backgroundColor = colorMainVC
        settingSliderValuePreBackground()
        
        //что бы сразу цвета и значения подгрузились
        setMainVCColor()
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
        //скрывает клавиатуру для любого объекта
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if let currentValue = Float(text) {
            if currentValue >= 0 && currentValue <= 255 {
                switch textField.tag {                                        //тоже tag настраиваем
                case 0: redSlider.value = currentValue / 255
                case 1: greenSlider.value = currentValue / 255
                case 2: blueSlider.value = currentValue / 255
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
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Понял понял", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

//Кастомный класс для украшения слайдов )))
class CustomSlider: UISlider {
    override func awakeFromNib() {
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.4
    }
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 13))
    }
}

//Кастомный класс для кнопок (УЧИМСЯ НЕ ДУБЛИРОВАТЬ КОД)
class CustomButton: UIButton {
    override func awakeFromNib() {
        layer.cornerRadius = 13
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.4
    }
}

//Кастом для Label (Да бы был единный стиль, как сильно РАЗГРУЗИЛИ основной класс)
class CustomLabel: UILabel {
    override func awakeFromNib() {
        layer.cornerRadius = 13
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.4
    }
}

//Кастомный класс для превьюшки, а точнее ее подложки (красивая тень)
class CustomView: UIView{
    override func awakeFromNib() {
        layer.cornerRadius = 13
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.4
    }
}
