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
    
    @State private var showResult = false
    
    @FocusState private var isVehiclePriceFocused: Bool
    
    //MARK: - Calculating amount financed by leasing
    var financedAmount: Double {
        let participationAmount = vehiclePrice * (participationPercentage / 100)
        return vehiclePrice - participationAmount
    }
    
    //MARK: - Calculating the monthly Leasing installment
    var monthlyRate: Double {
        let monthlyInterest = (interestRate / 100) / 12
        let numPayments = repaymentPeriod
        let numerator = financedAmount * monthlyInterest * pow(1 + monthlyInterest, numPayments)
        let denominator = pow(1 + monthlyInterest, numPayments) - 1
        return denominator != 0 ? numerator / denominator : 0
    }
    
    //MARK: -
    var initialPayment: Double {
        let pdvOnInterest = (monthlyRate * repaymentPeriod) * 0.2
        let processingFee = 150.0
        let registryFee = 19.4
        return (vehiclePrice * (participationPercentage / 100)) + pdvOnInterest + processingFee + registryFee
    }
    
    //    var mounthlyPayment: Double {
    //        let mounthlyInterest = (interestRate / 100) / 12
    ////        let paymentsNumber = repaymentPeriod
    //        let totalMonthlyInstallments = vehiclePrice * mounthlyInterest * pow(1 + mounthlyInterest, repaymentPeriod)
    //        let installmentsCalculation = pow(1 + mounthlyInterest, repaymentPeriod) - 1
    //
    //        return totalMonthlyInstallments / installmentsCalculation
    //    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                //MARK: - Vehicle value
                Section("Vehicle value with PDV in EUR") {
                    //                    TextField("Vehicle value", value: $vehiclePrice, format: .currency(code: "RSD"))
                    TextField("Vehicle value", value: $vehiclePrice, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isVehiclePriceFocused)
                }
                //MARK: - Contract length
                Section("contract period") {
                    Picker("Enter the number of months", selection: $repaymentPeriod) {
                        ForEach(12..<73) { month in
                            Text("\(month) months").tag(Double(month))
                        }
                    }
                    //                    .pickerStyle(MenuPickerStyle())
                    .pickerStyle(NavigationLinkPickerStyle())
                }
                //MARK: - Participation in the Purchase
                Section("Percentage purchase participation") {
                    Text("Enter the purchase participation")
                    Stepper("\(participationPercentage.formatted()) %", value: $participationPercentage, in: 0...72, step: 1.0)
                }
                //MARK: - Interest rate
                Section("Leasing interest rate") {
                    Text("Enter interest rate")
                    Stepper("\(interestRate.formatted()) %", value: $interestRate, in: 0...10, step: 0.10)
                }
                //MARK: - Monthly installment
                Section("Monthly installment") {
                    //                    Text(monthlyRate, format: .currency(code: "RSD"))
                    Text("Monthly installment EUR \(monthlyRate, specifier: "%.2f")")
                        .font(.headline).bold()
                }
                
            }
            .navigationTitle("Leasing Calculator")
        }
    }
}

#Preview {
    ContentView()
}
