using XLSX
using DataStructures
import Missings

xl = XLSX.readxlsx("D:\\O.R\\Julia Script\\cases.xlsx")
matrix = xl["Sheet1"]["B31:J39"]
matrix = coalesce.(matrix, 0)

pq = Queue{Int}()
bn = Queue{Int}()
from = 1
sink = 9
nrow = size(matrix,1)
flow =  zeros(Int8,nrow , nrow)



function bfs(capacity,flow,s,t)
    pq = Queue{Int}()
    enqueue!(pq,s)
    paths = Dict()
    paths[s] = [s]

    while (!isempty(pq))
        prev = dequeue!(pq)
        for i = 1:nrow
            p = copy(paths[prev])
            if (matrix[prev,i] - flow[prev,i] >0) && !(i in keys(paths))
                # println("All Paths: $paths")
                new = append!(p,i)
                paths[i] = new
                # println(paths[i])
                # println("\n")

                if (i==t)
                    return paths[i]
                else
                    enqueue!(pq,i)
                end
            end
        end
    end
    return nothing
end


# path = bfs(matrix,flow,1,9)
# println(path)


function max_flow(capacity,flow,s,t)
    path = bfs(capacity,flow,s,t)

    while (!isnothing(path))

        # Bottleneck value
        min = Inf
        for i=1:(length(path)-1)
            if matrix[path[i],path[i+1]]<min
                min = matrix[path[i],path[i+1]]
            end
        end

        # Remaining capacity
        for i=1:(length(path)-1)
            flow[path[i],path[i+1]] = flow[path[i],path[i+1]] + min
            flow[path[i+1],path[i]] = flow[path[i+1],path[i]] + min
        end

        # for i=1:nrow
        #     println(matrix[i,:],"            ", flow[i,:])
        # end
        # println("\n\n")
        path = bfs(matrix,flow,s,t)
    end


    mf = 0
    for i = 1:nrow
        mf+=flow[i,t]
    end

    return mf
end


println(max_flow(matrix,flow,1,9))
