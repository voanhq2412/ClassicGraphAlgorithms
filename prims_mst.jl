using XLSX
using DataStructures
import Missings

xl = XLSX.readxlsx("D:\\O.R\\Julia Script\\cases.xlsx")
matrix = xl["Sheet1"]["B17:J25"]
matrix = coalesce.(matrix, 0)
pq = PriorityQueue()
from = 1
nrow = size(matrix,1)
visited = [0 for i in 1:nrow]

mst =   zeros(Int8,nrow , nrow)

for i = 1:nrow
    if matrix[from,i]>0
        pq[from,i] = matrix[from,i]
    end
end
visited[from] = 1


while (!isempty(pq))
    get = dequeue!(pq)

    if visited[get[2]]==1
        continue
    end
    visited[get[2]] = 1
    mst[get[1],get[2]] = 1

    for i = 1:nrow
        if matrix[get[2],i]>0
            pq[get[2],i] = matrix[get[2],i]
        end
    end
end


for i = 1:nrow
    for j = 1:nrow
        if mst[i,j] == 1
            println("($i , $j)")
        end
    end
end
