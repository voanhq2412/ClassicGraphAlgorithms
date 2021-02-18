using XLSX
using DataStructures
import Missings

xl = XLSX.readxlsx("D:\\O.R\\Julia Script\\cases.xlsx")
matrix = xl["Sheet1"]["B17:J25"]
matrix = coalesce.(matrix, 0)



function sp_dj(matrix,from)
    pq = PriorityQueue()
    # start node, end node

    nrow = size(matrix,1)
    visited = [0 for i in 1:nrow]
    distance = [Inf for i in 1:nrow]
    distance[from] = 0
    pq[from]=0

    path = Dict()
    path[from] = [from]

    while (!isempty(pq))
        get = dequeue!(pq)
        visited[get] = 1


        for i = 1:nrow
            p = copy(path[get])
            if matrix[get,i]>0 && visited[i]==0
                d = distance[get]+matrix[get,i]
                if distance[i]>d
                    pq[i] = d
                    distance[i] = d

                    new = append!(p,i)
                    path[i] = new
                end
            end
        end
    end
    return path
end
#
# res = sp_dj(matrix,1)
# println(res)
