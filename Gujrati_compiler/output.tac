x = 5
y = 10
t0 = x + y
x = t0
t1 = x > y
print "x is greater!"
print "y is greater!"
if t1 goto L3
goto L3
L3:
goto L3
L3:
L3:
t2 = x < 20
t3 = x + 1
x = t3
print x
L5:
if not t2 goto L5
goto L5
L5:
return x
