utils
=====

### 2012.6.1  compare_answer.rb 
Some script to assistant my business   
* Write a script to compare two answers.  
  The first one is stardard followed by an answer file.   
  Only the characters in the files make sense. Others will be just ignored.  
  Example:   
  		ruby compare_answer.rb compare_answer_fixtures/stardard_answer.txt compare_answer_fixtures/own_answer.txt  
        # => 'same: 55, disparities: 20'  

### 2012.6.2 试用nodejs, 用coffeescript写一个http server.  
  - httpserver.coffee  
  很简单也很自然, 越来越喜欢coffee了  
  而且加入callback并不影响链式调用与定义. Great!  
  
### 2012.6.1  write the compare_answer.rb in coffeescript 
Some script to assistant my business   
* Write a script to compare two answers.  
  The first one is stardard followed by an answer file.   
  Only the characters in the files make sense. Others will be just ignored.  
  Example:   
  		coffee compare_answer.coffee compare_answer_fixtures/stardard_answer.txt compare_answer_fixtures/own_answer.txt  
        # => 'same: 55, disparities: 20'  
  还是有很多地方需要习惯. 比如:  
  1. `in`和`of`的微妙区别  
  2. coffeescript本质上还是javascript,所以正则表达式用`match`必须从js的参考中学习.  
  3. 文件读写有fs,是node实现的lib,通过`require 'fs'`载入,所有的文件操作方法都有同步和异步两类.当然,写js肯定主要是吃它的异步,而且可以少声明变量
  也确实够简洁的.  
  4. `process`是全局变量,参数可通过`process.argv[2]`的方式来获取.它的第0个参数就是命令行的命令,第1个通常就是执行的文件名,第2个参数才是运行时填入的  
  5. 在一个类的成员函数中如果要调用其他的成员函数,需要加上`@`, 也就是`this.`, 不然根本找不到.  
  6. `=>`在避免回调函数的this混乱方面确实有用.否则读写文件里面的this变掉后,再调用外面的不是一般的麻烦.  
  难怪 https://github.com/styleguide/javascript 里明言 **Write new JS in CoffeeScript**. 诚哉斯言!  
  
### 2012.6.14 net.coffee
* 练习net的用法 

### 2012.6.18 readline.coffee
* 练习编写命令行函数  
  - 自动补完的功能还是很厚道的
  - 1.欢迎辞
  - 2.创建读取interface，同时加入自动补全的内容  
  - 3.提示符设置，要包含颜色  
  - 4.命令处理函数，根据输入做反应：1.数字，2.命令提示符，3.错误信息
  - 5.监听line和close事件 
