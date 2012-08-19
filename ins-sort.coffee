# 对MIT公开课做的练习。插入排序算法， insert sort alg。
S = [ 1, 8, 999, 7, 0, 865, 222, 999, 1, 8, 999, 7, 0, 865, 222, 999, 1, 8, 999, 7, 0, 865, 222, 999, 1, 8, 999, 7, 0, 865, 222, 999]

S2 = [].concat(S)

insSort = (A) ->
  for j in [1..(A.length-1)]
    key = A[j]
    i = j - 1
    while i>=0 && A[i]>key
      A[i+1] = A[i]
      i = i - 1
    A[i+1] = key
    console.log A
  A


mergeSort = (A) -> 
  
  if A.length == 1
    return A
  n = A.length
  p = n/2 - 1
  q = n/2 
  AL = A[0..p]
  AR = A[q..n-1]

  AL = mergeSort(AL)
  AR = mergeSort(AR)
  sortedA = []
  i = 0
  j = 0
  for k in [0..n-1]
    if typeof(AR[j])=="undefined" || (AL[i] <= AR[j])
      sortedA[k] = AL[i]
      i += 1
    else 
      sortedA[k] = AR[j]
      j += 1
    #console.log sortedA[k]
  console.log sortedA
  sortedA

    

insSort(S)
mergeSort(S2)

