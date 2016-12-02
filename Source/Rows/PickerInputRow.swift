//  PickerInputRow.swift
//  Eureka ( https://github.com/xmartlabs/Eureka )
//
//  Copyright (c) 2016 Xmartlabs SRL ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

class PickerInputTextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
}

//MARK: PickerInputCell

open class PickerInputCell<T> : _FieldCell<T>, CellType, UIPickerViewDataSource, UIPickerViewDelegate where T: InputTypeInitiable, T: Equatable {
    
    public var picker: UIPickerView
    
    private var pickerInputRow : _PickerInputRow? { return row as? _PickerInputRow }
    
    private var textFieldStartColor: UIColor?
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String?){
        self.picker = UIPickerView()
        self.picker.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField = PickerInputTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.inputView = picker
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setup() {
        super.setup()
        accessoryType = .none
        editingAccessoryType = .none
        picker.delegate = self
        picker.dataSource = self
    }
    
    deinit {
        picker.delegate = nil
        picker.dataSource = nil
    }
    
    open override func update(){
        super.update()
        
        textField.clearButtonMode = .never
        if row.isHighlighted {
            textFieldStartColor = textField.textColor
            textField.textColor = textField.tintColor
        } else if textFieldStartColor != nil {
            textField.textColor = textFieldStartColor
        }
        
        textLabel?.text = nil
        detailTextLabel?.text = nil
        
        picker.reloadAllComponents()
        if let selectedValue = pickerInputRow?.value, let index = pickerInputRow?.options.index(of: selectedValue){
            picker.selectRow(index, inComponent: 0, animated: true)
        }
        
    }
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerInputRow?.options.count ?? 0
    }
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerInputRow?.displayValueFor?(pickerInputRow?.options[row])
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let picker = pickerInputRow, !picker.options.isEmpty {
            picker.value = picker.options[row]
            textField.text = picker.value
        }
    }
    
}

//MARK: PickerInputRow

open class _PickerInputRow : FieldRow<PickerInputCell<String>> {
    
    open var options = [String]()
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

/// A generic row where the user can pick an option from a picker view displayed in the keyboard area
public final class PickerInputRow: _PickerInputRow, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
