from gurobipy import *
import math
import numpy as np

def readData ( inputFile ):
    ''' read data from a file and return the header and content seperately'''
    file = open( inputFile , "r" )
    contents = file.readlines()
    header = contents[0][1:-1].split(',')
    table = []
    for row in contents[1:]:
        table.append(row[:-1].split(','))
    return header, table


def best_dish(table, weights):
    ''' from table return the dish with maximum score '''
    score = {}
    for i in range(len(table)):
        score[table[i][0]] = model(table[i][2:], weights)
    return min(score, key=lambda k: score[k])


def model(row, weights):
    '''return the minimum nutrition score for a dish'''
    # create an empty shell for our linear program
    myModel = Model("Best_Dishes")
    Var = [0 for i in range(len(row))]

    # construct the decision variables and add them to the model
    for i in range(len(row)):
        myVar = myModel.addVar(vtype=GRB.CONTINUOUS, name=header[i + 2])
        Var[i] = myVar

    myModel.update()

    # create an empty linear expression to keep the objective function
    objExpr = LinExpr()
    for i in range(len(row)):
        myVar = Var[i]
        coeff = weights[i]
        objExpr += coeff * (myVar - row[i])

    myModel.setObjective(objExpr, GRB.MINIMIZE)

    # solve the model
    myModel.optimize()
    return myModel.ObjVal



header, Dishes = readData( "dishes.csv" )
table = []
for i in Dishes:
    table.append(i[:2] + [float(x) for x in i[2:]])

weights = [1,1,1,1,1,1,1,1,1,1,1]

print(best_dish(table, weights))

