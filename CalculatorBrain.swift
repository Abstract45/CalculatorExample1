//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Miwand Najafe on 2015-07-13.
//  Copyright (c) 2015 Miwand Najafe. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private  enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation (String, (Double, Double) -> Double)
    }
    
    private var opStack = [Op]()
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    private   var knownOps = [String:Op]()
    
    init(){
        knownOps["✕"] = Op.BinaryOperation("✕"){ $0 * $1 }
        knownOps["+"] = Op.BinaryOperation("+"){ $0 + $1 }
        knownOps["÷"] = Op.BinaryOperation("÷"){ $1 / $0 }
        knownOps["-"] = Op.BinaryOperation("-"){ $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√"){ sqrt($0) }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result
                {
                return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result
                {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
                
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double?
    {
        let (result, remainder) = evaluate(opStack)
        return result
    }
    
    func performOperation(symbol: String) {
        if let operation = knownOps [symbol] {
        opStack.append(operation)
        }
    }
}