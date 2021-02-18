using XLSX
using DataStructures
import Missings

xl = XLSX.readxlsx("D:\\O.R\\Julia Script\\cases.xlsx")
matrix = xl["Sheet1"]["B17:J25"]
matrix = coalesce.(matrix, 0)
pq = PriorityQueue()
from = 1
nrow = size(matrix,1)
mst =   zeros(Int8,nrow , nrow)


for i = 1:nrow
    for j=1:nrow
        d = matrix[i,j]
        if d>0
            pq[i,j] = d
        end
    end
end
# println(pq)


s = IntDisjointSets(nrow)
while (!isempty(pq))
    get = dequeue!(pq)

    if find_root!(s,get[1])!= find_root!(s,get[2])
        union!(s,get[1],get[2])
        mst[get[1],get[2]] = 1
    else
        continue
    end

    mst[get[1],get[2]] = 1
end


for i = 1:nrow
    for j = 1:nrow
        if mst[i,j] == 1
            println("($i , $j)")
        end
    end
end
