import Dishes

header, data, table = Dishes.readData("dishes.csv")

weights = Dishes.get_weights(1)
recommend = Dishes.cal_recommend(170, 55)

dish = Dishes.best_dish(table, weights, recommend)

print(dish)