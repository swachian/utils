

var result = db.query("select ...")
等待数据库返回内容时,整个进程就被阻塞



db.query("select..", function(result){...})
允许程序注册完callback后即返回主执行程序线