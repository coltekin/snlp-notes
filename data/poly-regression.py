#!/usr/bin/env python3

import numpy as np
import matplotlib.pyplot as plt

#x = np.random.uniform(low=0,high=10,size=10)
# x = np.array(list(range(1, 21)))/2 + np.random.uniform(low=-0.1,high=0.1,size=20)
# y = 0.2*x*x - x + 3 + np.random.normal(size=20)
# 
# with open('/tmp/xy', 'w') as fp:
#     for xx, yy in zip(x, y):
#         print(xx, yy, file=fp)
# 

x, y = [], []
with open('poly-regressio.text', 'r') as fp:
    _ = next(fp)
    for line in fp:
        xx, yy = line.strip().split()
        x.append(float(xx))
        y.append(float(yy))
x = np.array(x)
y = np.array(y)

xt = np.array(list(range(1, 21)))/2 + np.random.uniform(low=-0.1,high=0.1,size=20)
yt = 0.2*xt*xt - xt + 3 + np.random.normal(size=20)

for rank in range(1, 20):
#    print('rank', rank)
    coef = np.polyfit(x, y, rank)
#    for j, w in enumerate(coef):
#        if j < rank:
#            print("{:.6f}*x^{}".format(w,rank-j), end="+")
#        else:
#            print("{:.6f}".format(w))
    pred = []
    predt = []
    for i, xx in enumerate(x):
        yy = 0
        yyt = 0
        for j, w in enumerate(np.flip(coef)):
            yy += w * xx ** j
            yyt += w * xt[i] ** j
        pred.append(yy)
        predt.append(yyt)
    pred = np.array(pred)
    predt = np.array(predt)
    rmse = np.power(y - pred, 2).mean()
    rmset = np.power(yt - predt, 2).mean()
    r2 = 1 - (rmse /y.std()) ** 2
    r2t = 1 - (rmset /yt.std()) ** 2
#    print('RMSE:', rmse, 'R2:', r2)
    print(rank, r2, r2t, rmse, rmset)


# plt.scatter(x,y)
# plt.show()
