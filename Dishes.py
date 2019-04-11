def readData ( inputFile ):
    # read data from a file and return the header and content seperately
    file = open( inputFile , "r" )
    contents = file.readlines()
    header = contents[0][1:-1].split(',')
    data = []
    for row in contents[1:]:
        data.append(row[:-1].split(','))
    table = []
    for i in data:
        table.append(i[:2] + [float(x) for x in i[2:]])
    return header, data, table


def cal_recommend(height, weight):
    recommend = [200, 5, 10, 15, 3, 30]
    recommend += [30, 30, 30, 30, 30]
    return recommend


def get_weights(day):
    # fat and calories
    if day == 1:
        return [1, 1, 1,1,1,1,1,1,1,1,1]
    # protein
    elif day == 2:
        return [1] * 11
    # vitamin
    elif day == 3:
        return [1] * 11
    # fat and calories
    elif day == 4:
        return [1] * 11
    # vitamin
    elif day == 5:
        return [1] * 11
    else:
        return [1] * 11


def cal_score(dish, recommend, weights):
    score = 0
    for i in range(len(dish)):
        if i in [0,2,4,5]:
            score += weights[i] * max(dish[i] - recommend[i], 0)
        else:
            score += weights[i] * max(recommend[i] - dish[i], 0)
    return score


def best_dish(table, weights, recommend):
    # from table return the dish with maximum score
    score = {}
    for i in range(len(table)):
        score[table[i][0]] = cal_score(table[i][2:], recommend, weights)
    return min(score, key=lambda k: score[k])
