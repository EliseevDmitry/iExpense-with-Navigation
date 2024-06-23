//
//  ContentView.swift
//  iExpense
//
//  Created by Dmitriy Eliseev on 07.06.2024.
//

import SwiftUI

enum TypeExpense {
    case Business
    case Personal
}

struct CustomStyle: ViewModifier {
    var amount: Double
    func body(content: Content) -> some View {
        if amount < 10 {
            content
                .font(.caption)
        } else if amount > 100 {
            content
                .font(.title)
        } else {
            content
                .font(.title2)
        }
    }
}

extension View {
    func customStyle(with amount: Double) -> some View {
        modifier(CustomStyle(amount: amount))
    }
}

struct ExpenseItem: Identifiable, Codable{
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem](){
        didSet{
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){
            if let decoderItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems){
                items = decoderItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    //MARK: - PROPORTIES
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var businessExpenses: [ExpenseItem] {
        if !expenses.items.isEmpty {
            return expenses.items.filter{$0.type == "\(TypeExpense.Business)"}
        } else {
            return []
        }
    }
    
    var personalExpenses: [ExpenseItem] {
        if !expenses.items.isEmpty {
            return expenses.items.filter{$0.type == "\(TypeExpense.Personal)"}
        } else {
            return []
        }
    }
    
    //MARK: - BODY
    var body: some View {
        NavigationStack{
            List{
                Section("\(TypeExpense.Business)"){
                    ForEach(businessExpenses){item in
                        HStack{
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }//: VSTACK
                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .customStyle(with: item.amount)
                        }//: HSTACK
                    }
                    .onDelete{index in
                        removeItems(at: index, from: businessExpenses)
                    }

                }
                Section("\(TypeExpense.Personal)"){
                    ForEach(personalExpenses){item in
                        HStack{
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }//: VSTACK
                            Spacer()
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .customStyle(with: item.amount)
                        }//: HSTACK
                    }
                    .onDelete{index in
                        removeItems(at: index, from: personalExpenses)
                    }
                }
                
            } //: List
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink {
                    AddView(expenses: expenses)
                        .navigationBarBackButtonHidden()
                }
                
            label: {
                        Image(systemName: "plus")
                }
           
            }
        }
    }
    
    //MARK: - FUNCTIONS
    func removeItems(at offsets: IndexSet, from arrayExpense: [ExpenseItem]) {
        for offset in offsets {
            let item = arrayExpense[offset]
            expenses.items.removeAll { element in
                element.id == item.id
            }
        }
    }
}

//MARK: - PREVIEW
#Preview {
    ContentView()
}
