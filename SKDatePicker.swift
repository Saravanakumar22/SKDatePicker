class SKDatePicker: UIView {
    
    typealias DateAction = (Date) -> ()
    
    var dateAction: DateAction?
    var sheetViewBottom: NSLayoutConstraint!
    
    var datePicker: UIDatePicker!
    
    var minimumDate: Date? {
        get {
            return datePicker.minimumDate
        }
        set {
            datePicker.minimumDate = newValue
        }
    }
    
    var maximumDate: Date? {
        get {
            return datePicker.minimumDate
        }
        set {
            datePicker.minimumDate = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(dateMode: UIDatePicker.Mode, date: Date? = nil, minDate: Date? = nil, maxDate: Date? = nil, dateHandler: DateAction? = nil) {
        self.init()

        self.alpha = 0

        createUI(dateMode: dateMode, date: date, minDate: minDate, maxDate: maxDate)
    }
    
    private func createUI(dateMode: UIDatePicker.Mode, date: Date?, minDate: Date?, maxDate: Date?) {

        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        addSubview(backgroundView)
        
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        
        let sheetView = UIView()
        sheetView.isUserInteractionEnabled = true
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.backgroundColor = .clear
        backgroundView.addSubview(sheetView)
        
        sheetView.heightAnchor.constraint(equalToConstant: 340).isActive = true
        sheetViewBottom = sheetView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 350)
        sheetViewBottom.isActive = true
        sheetView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 10).isActive = true
        sheetView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: 10).isActive = true
        
        let button = UIButton()
        button.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 239/255, alpha: 1.0)//237, 237, 239
        button.setTitleColor(UIColor(red: 0/255, green: 123/255, blue: 255/255, alpha: 1.0), for: .normal)
        button.setTitle("Done", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        sheetView.addSubview(button)
        
        button.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: sheetView.rightAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: sheetView.leftAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        let datePickerContainer = UIView()
        datePickerContainer.layer.cornerRadius = 10
        datePickerContainer.translatesAutoresizingMaskIntoConstraints = false
        datePickerContainer.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 239/255, alpha: 1.0)//237, 237, 239
        sheetView.addSubview(datePickerContainer)

        datePickerContainer.bottomAnchor.constraint(equalTo: button.topAnchor,constant: -15).isActive = true
        datePickerContainer.rightAnchor.constraint(equalTo: sheetView.rightAnchor).isActive = true
        datePickerContainer.leftAnchor.constraint(equalTo: sheetView.leftAnchor).isActive = true
        datePickerContainer.heightAnchor.constraint(equalToConstant: 250).isActive = true

        let titleLabel = UILabel()
        titleLabel.text = "Date picker"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .gray
        titleLabel.backgroundColor = .clear
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        datePickerContainer.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: datePickerContainer.topAnchor, constant: 15).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: datePickerContainer.rightAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: datePickerContainer.leftAnchor).isActive = true
        
        datePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = dateMode
        datePicker.date = date ?? Date()
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePickerContainer.addSubview(datePicker)
        
        datePicker.bottomAnchor.constraint(equalTo: datePickerContainer.bottomAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: datePickerContainer.rightAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: datePickerContainer.leftAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true

        self.layoutIfNeeded()
    }
    
    @objc private func datePickerValueChanged(_ sender:UIDatePicker) {
        dateAction?(sender.date)
    }
    
    @objc private func didTapDone() {
        dateAction?(datePicker.date)
        sheetViewBottom.constant = 350
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.layoutIfNeeded()
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    func show() {
        if let controller = UIApplication.shared.windows.first!.rootViewController {
            self.frame = controller.view.bounds
            controller.view.addSubview(self)

            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
            }, completion: { _ in
                self.presentDatePicker()
            })
        }
    }
    
    private func presentDatePicker() {
        sheetViewBottom.constant = -10

        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}
