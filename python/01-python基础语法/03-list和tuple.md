# List[ ]
Python内置的一种数据类型是列表：list。list是一种有序的集合，可以随时添加和删除其中的元素。
```plain
1、对list可以取length；len()；
2、list加索引；list[n]，超出会数组越界
3、也可以用list[负数]，表示倒数第几个
4、list是一个可变的有序表，所以，可以往list中追加元素到末尾；list.append('**')
5、可以插入指定的索引：list.insert(1,'**')
6、要删除list末尾的元素，用`pop()`方法：list.pop()
7、删除指定索引，用pop(n)
8、要把某个元素替换成别的元素：list[n]=new_value
9、list里面的元素的数据类型也可以不同，比如：L = ['Apple', 123, True]
10、list元素也可以是另一个list，比如：s = ['python', 'java', ['asp', 'php'], 'scheme'];len(s)=4
11、p = ['asp', 'php']；s = ['python', 'java', p, 'scheme']；p[1]/s[2][1]='php'
```
list必须是同一类型的数据集合
# tuple()
另一种有序列表叫元组：tuple。tuple和list非常类似，但是tuple一旦初始化就不能修改
```plain
tupleee('Michael', 'Bob', 'Tracy')
1、可以使用`classmates[0]`，`classmates[-1]`；但是不能增删改
2、tuple不可变，所以代码更安全。如果可能，能用tuple代替list就尽量用tuple。
3、当你定义一个tuple时，在定义的时候，tuple的元素就必须被确定下来
4、如果要定义一个空的tuple，可以写成`()`
5、要定义一个只有1个元素的tuple；t=(‘1’，)，避免与数学符号()
6、利用了list实现tuple可变；tuplee=('a','n',['A','B'])
```

tuple 是：
> 固定长度 + 固定位置语义
```
t = (1, 2, "hello")
这个其实是一条数据；如果有多条也是类似数据的组合；
```
