# 根据给出的样本，计算HMM模型中的Pi，A和B
# 来自《入侵检测报警数据融合与关联技术研究》 国防科技大学 孙一品

###
  N - 状态总数 S={S1, S2, ... SN}
  M - 观察值总数，对应观测值有限集 O={V1, V2, ... VM}
  Pi  - 初始状态分布pi={PIi}, PIi=P(q1=Si)
  A - 状态转移概率 A={aij}, aij = (由状态i向j转换的次数)/(i转向其他状态的总次数)
  B - 观察值产生概率 B={bi(k)}, bij=(状态i出现观察值k的次数)/状态i出现的次数
###

# 样本序列，共包含3组样本，每组样本又由两个数组构成
samples = [
  [["V1", "V2", "V3"], ["S1", "S2", "S3"]],
  [["V1", "V2", "V3", "V4"], ["S1", "S2", "S2", "S3"]],
  [["V2", "V3", "V4", "V4"], ["S2", "S2", "S3", "S3"]]
]

# 根据样本samples产生状态和观察值的集合
# return： 一个二维数组，里面存放状态的数组，观察值的数组
genMN = ->
  N = {}
  M = {}
  
  for sample in samples
    m = sample[0]
    n = sample[1]
    m.forEach (v) ->
      M[v] = v
    n.forEach (s) ->
      N[s] = s
  
  rN = []
  rM = []
  for s of N
    rN.push(s)
  for v of M
    rM.push(v)
  
  [rN, rM]

r = genMN()
N = r[0]
M = r[1]

# 计算第一位出现的状态值的次数，然后根据次数得到总次数，次数/总次数得到概率Pi的向量
genPI = ->
  countPi = {}
  Pi = []
  N.forEach (s) ->
    countPi[s] = 0
  for sample in samples
    n = sample[1]
    countPi[n[0]] += 1
  #console.log countPi
  sum = 0
  for s of countPi
    sum += countPi[s]
  for s of countPi
    Pi.push(countPi[s]/sum)
  Pi

PI = genPI()

# 产生状态转移概率A
# Return [ [ 0, 1, 0 ], [ 0, 0.4, 0.6 ], [ 0, 0, 1 ] ]
genA = -> 
  a = {}
  for x in N
    for y in N
      a["#{x},#{y}"] = 0
  
  for sample in samples
    n = sample[1] # n是一个向量
    for i in [0..(n.length-2)]
      a["#{n[i]},#{n[i+1]}"] += 1 
  console.log a
  
  countA = {}
  for s1 in N
    countA[s1] = 0
    for s2 in N
      countA[s1] += a["#{s1},#{s2}"]
  A = []
  for i in [0..N.length-1]
    A[i] = []
    for j in [0..N.length-1]
      A[i][j] = a["#{N[i]},#{N[j]}"] / countA[N[i]] 
  A

      
A = genA()

# 产生B矩阵
genB = -> 
  a = {}
  for x in N
    for y in M
      a["#{x},#{y}"] = 0
  
  for sample in samples
    n = sample[1] # n是一个向量
    m = sample[0]

    for i in [0..(n.length-1)]
      a["#{n[i]},#{m[i]}"] += 1 
  console.log a
  
  countA = {}
  for s in N
    countA[s] = 0
    for v in M
      countA[s] += a["#{s},#{v}"]
  console.log countA
  A = []
  for i in [0..N.length-1]
    A[i] = []
    for j in [0..M.length-1]
      A[i][j] = a["#{N[i]},#{M[j]}"] / countA[N[i]] 
  A
  
B = genB()

[M, N, PI, A, B].forEach (x) ->
  console.log x
