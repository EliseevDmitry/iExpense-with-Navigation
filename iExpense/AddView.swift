//
//  AddView.swift
//  iExpense
//
//  Created by Dmitriy Eliseev on 08.06.2024.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = "Enter you item here ..."
    @State private var type = ""
    @State private var amount = 0.0
    
    var expenses: Expenses
    let types = ["Business", "Personal"]
    var body: some View {
        NavigationStack{
            Form{
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self){
                        Text($0)
                    }
                }//: Picker
                TextField("", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }//: FORM
     //   .navigationTitle(name)
        .navigationTitle($name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Save"){
                let expense = ExpenseItem(name: name, type: type, amount: amount)
                expenses.items.append(expense)
                dismiss()
            }
        }
        }//: NavigationStack
        .onAppear(){
            type = types[0]
        }
    }
}

//MARK: - PREVIEWS
#Preview {
    AddView(expenses: Expenses())
}
