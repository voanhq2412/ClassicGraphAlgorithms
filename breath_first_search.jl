using XLSX
using DataStructures
import Missings

xl = XLSX.readxlsx("D:\\O.R\\Julia Script\\cases.xlsx")
matrix = xl["Sheet1"]["B4:J12"]
matrix = coalesce.(matrix, 0)

pq = PriorityQueue()
from = 1

nrow = size(matrix,1)
visited = [0 for i in 1:nrow]
distance = [0 for i in 1:nrow]
visited[from] = 1
enqueue!(pq, from, 1)


while (!isempty(pq))
    get = dequeue!(pq)
    for i = 1:nrow
        if matrix[get,i]==1 && visited[i]==0
            enqueue!(pq, i, 1)
            distance[i] = distance[get]+1
            visited[i] = 1
        end
    end
end

println(distance)
println(visited)
