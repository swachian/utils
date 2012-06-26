# 简单的memoization
s1 = 0
s2 = 0  
s3 = 0
fibonacci = (n) ->
  s1++
  if n < 2 then n else fibonacci(n-1) + fibonacci(n - 2)

for i in [0..10]
  console.log(fibonacci(i)) 
console.log s1

# utilize the featur of closure
outer = ->
  memo = []
  inner = (n) ->
    result = memo[n]
    s2++
    if !result?
      result = if n < 2 then n else inner(n-1) + inner(n-2)
      memo[n] = result
    result
  return inner

fab = outer()

for i in [0..10]
  console.log(fab(i)) 
console.log s2

# furthermore, generalize it
memoizer = (memo, fundamental) ->
  shell = (n) ->
    s3++
    result = memo[n]
    if typeof result != 'number'
      result = fundamental(shell, n)
      memo[n] = result
    return result
  return shell;

fm = memoizer [0, 1], (shell, n) ->
  return shell(n - 1) + shell(n-2)
  
for i in [0..10]
  console.log fm(i)
console.log s3






