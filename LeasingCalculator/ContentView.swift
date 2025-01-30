//
//  ContentView.swift
//  LeasingCalculator
//
//  Created by Marko Zivanovic on 29.1.25..
//

import SwiftUI

struct ContentView: View {
    
    @State private var vehiclePrice = 0.0
    @State private var repaymentPeriod: Double = 60
    @State private var participationPercentage = 20.0
    @State private var interestRate = 3.0
    
    var mounthlyPayment: Double {
        let mounthlyInterest = (interestRate / 100) / 12
//        let paymentsNumber = repaymentPeriod
        let totalMonthlyInstallments = vehiclePrice * mounthlyInterest * pow(1 + mounthlyInterest, repaymentPeriod)
        let installmentsCalculation = pow(1 + mounthlyInterest, repaymentPeriod) - 1
        
        return totalMonthlyInstallments / installmentsCalculation
    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                //MARK: - Vehicle value
                Section("The value of the vehicle with PDV in RSD") {
                    TextField("Vehicle value", value: $vehiclePrice, format: .currency(code: "RSD"))
                        .keyboardType(.decimalPad)
                }
                
                Section("Contract duration in months") {
                    Picker("Enter the number of months", selection: $repaymentPeriod) {
                        ForEach(12..<73) { month in
                            Text("\(month) months").tag(Double(month))
                        }
                    }
//                    .pickerStyle(MenuPickerStyle())
                    .pickerStyle(NavigationLinkPickerStyle())
                }
                
                Section("Amount of participation in vehicle purchase") {
                    Text("Enter the participation percentage")
                    Stepper("\(participationPercentage.formatted()) %", value: $participationPercentage, in: 0...72, step: 0.10)
                }
                
                Section("Leasing interest rate") {
                    Text("Enter interest rate")
                    Stepper("\(interestRate.formatted()) %", value: $interestRate, in: 0...10, step: 0.10)
                }
                
                Section("Monthly payment") {
                    Text(mounthlyPayment, format: .currency(code: "RSD"))
                }
                
            }
            .navigationTitle("Leasing Calculator")
        }
    }
}

#Preview {
    ContentView()
}
