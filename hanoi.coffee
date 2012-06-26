# 汉诺塔

hanoi = (n, src, aux, dst) -> 
    if n > 0
        hanoi(n - 1, src, dst, aux)
        console.log("move disc #{n} from #{src} to #{dst}")
        hanoi(n - 1, aux, src, dst)

for i in [1..3] 
    console.log("#### #{i} discs")   
    hanoi i, 'SRC', 'AUX', 'DST'