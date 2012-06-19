https://github.com/coolaj86/node-jquery
https://github.com/learnboost/socket.io
https://github.com/senchalabs/connect

### 2012.06.19 recite http-console  
  1.接受命令行的输入，按下面的选项分配好。对于help version的选项执行后即退出。
  'usage: http-console [username:password@host:port] [options]',
  '',
  'options:',
  '    --cookies      remember cookies',
  '-v, --verbose      print requests',
  '    --json         set "Content-Type" header to application/json',
  '    --notimeout    don\'t timeout requests',
  '    --ssl          create a secure connection',
  '    --version      print version',
  '-h, --help         display this message'
  
  options = {
        rememberCookies: true,
        useSSL:          protocol === 'https',
        json:            false,
        timeout:         true,
        verbose:         false
    };